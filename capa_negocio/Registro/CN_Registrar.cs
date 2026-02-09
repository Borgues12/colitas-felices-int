using BCrypt.Net;
using capa_datos;
using capa_dto;
using System;
using System.Threading.Tasks;
using Google.Apis.Gmail.v1.Data;
using Org.BouncyCastle.Asn1.Ocsp;
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace capa_negocio
{

    namespace capa_negocio
    {
        public class CN_Registro
        {
            private CD_Registro cdRegistro = new CD_Registro();

            #region CONSTANTES

            private const int CODIGO_EXPIRACION_MINUTOS = 15;
            private const int MAX_INTENTOS = 5;
            private const int MAX_REENVIOS = 3;
            private const int SEGUNDOS_ENTRE_REENVIOS = 120;
            private const int PASSWORD_MIN_LONGITUD = 5;

            #endregion

            #region PASO 1: INICIAR REGISTRO

            /// <summary>
            /// Inicia el proceso de registro creando un registro temporal
            /// </summary>
            public async Task<notifyVarDTO> IniciarRegistro(RegistroRequestDTO request)
            {
                // ══════════════════════════════════════════
                // VALIDACIONES
                // ══════════════════════════════════════════

                // Campos requeridos
                if (string.IsNullOrWhiteSpace(request.Email))
                    return ErrorVar("El correo electrónico es requerido");

                if (string.IsNullOrWhiteSpace(request.Password))
                    return ErrorVar("La contraseña es requerida");

                if (string.IsNullOrWhiteSpace(request.ConfirmarPassword))
                    return ErrorVar("Debes confirmar la contraseña");

                if (string.IsNullOrWhiteSpace(request.PrimerNombre))
                    return ErrorVar("El nombre es requerido");

                if (string.IsNullOrWhiteSpace(request.PrimerApellido))
                    return ErrorVar("El apellido es requerido");

                // Validar formato email
                if (!EsEmailValido(request.Email))
                    return ErrorVar("El formato del correo no es válido");

                // Validar contraseña
                var validacionPassword = ValidarPassword(request.Password);
                if (!validacionPassword.resultado)
                    return ErrorVar(validacionPassword.mensajeSalida);

                // Validar confirmación
                if (request.Password != request.ConfirmarPassword)
                    return ErrorVar("Las contraseñas no coinciden");

                // Validar teléfono (si se proporcionó)
                if (!string.IsNullOrWhiteSpace(request.Telefono) && !EsTelefonoValido(request.Telefono))
                    return ErrorVar("El formato del teléfono no es válido");

                // ══════════════════════════════════════════
                // VERIFICAR DISPONIBILIDAD
                // ══════════════════════════════════════════

                string emailNormalizado = request.Email.Trim().ToLower();

                // ¿Ya existe en cuenta?
                if (cdRegistro.ExisteEmailEnCuenta(emailNormalizado))
                    return ErrorVar("Este correo ya está registrado. ¿Olvidaste tu contraseña?");

                // ¿Existe en registro temporal?
                var registroExistente = cdRegistro.ObtenerRegistroTemporal(emailNormalizado);

                if (registroExistente != null)
                {
                    // Si expiró, eliminar y permitir nuevo registro
                    if (registroExistente.CodigoExpiracion < DateTime.Now)
                    {
                        cdRegistro.EliminarRegistroTemporal(registroExistente.RegistroID);
                    }
                    else
                    {
                        // Aún vigente
                        return new notifyVarDTO
                        {
                            resultado = false,
                            mensajeSalida = "Correo con verificación pendiente",
                            codigo = 1
                        };

                    }
                }

                // ══════════════════════════════════════════
                // CREAR REGISTRO TEMPORAL
                // ══════════════════════════════════════════

                string codigo = GenerarCodigo();
                string passwordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

                var nuevoRegistro = new RegistroTemporalDTO
                {
                    Email = emailNormalizado,
                    PasswordHash = passwordHash,
                    PrimerNombre = request.PrimerNombre,
                    SegundoNombre = request.SegundoNombre,
                    PrimerApellido = request.PrimerApellido,
                    SegundoApellido = request.SegundoApellido,
                    Telefono = request.Telefono,
                    CodigoVerificacion = codigo
                };

                int registroId = cdRegistro.InsertarRegistroTemporal(nuevoRegistro);

                if (registroId <= 0)
                    return ErrorVar("Error al procesar el registro. Intenta nuevamente.");

                // ══════════════════════════════════════════
                // ENVIAR EMAIL
                // ══════════════════════════════════════════
                string nombreCompleto = $"{request.PrimerNombre} {request.PrimerApellido}";
                var resultadoEmail = await CN_Email.Verificacion(
                    emailNormalizado,
                    nombreCompleto,
                    codigo
                );

                if (!resultadoEmail.Exitoso)
                {
                    // Si falla el email, eliminar el registro temporal
                    cdRegistro.EliminarRegistroTemporal(registroId);
                    return ErrorVar("No pudimos enviar el correo de verificación. Intenta nuevamente.");
                }

                // ══════════════════════════════════════════
                // ÉXITO
                // ══════════════════════════════════════════

                return new notifyVarDTO
                {
                    resultado = true,
                    mensajeSalida = "Te enviamos un código de verificación a tu correo",
                    codigo = registroId
                };
            }

            #endregion

            #region PASO 2: VERIFICAR CÓDIGO

            /// <summary>
            /// Verifica el código ingresado por el usuario
            /// </summary>
            public async Task<notifyVarDTO> VerificarCodigo(string busquedaCorreo, string codigo)
            {
                // Validar entrada
                if (string.IsNullOrWhiteSpace(codigo))
                    return ErrorVar("Ingresa el código de verificación");

                //por si acaso
                codigo = codigo.Trim();
                if (codigo.Length != 6 || !Regex.IsMatch(codigo, @"^\d{6}$"))
                    return ErrorVar("El código debe ser de 6 dígitos");

                // Obtener registro
                var registro = cdRegistro.ObtenerRegistroTemporal(busquedaCorreo);
                int RegistroID = registro.RegistroID;

                if (registro == null)
                    return ErrorVar("Registro no encontrado. Debes registrarte nuevamente.");

                // ¿Ya verificado?
                //Extraño porque ya debio eliminarse
                if (registro.Verificado)
                    return ErrorVar("Este registro ya fue verificado");

                // ¿Excedió intentos?
                if (registro.Intentos >= MAX_INTENTOS)
                {
                    cdRegistro.EliminarRegistroTemporal(RegistroID);
                    return ErrorVar("Excediste el número de intentos. Debes registrarte nuevamente.");
                }

                // ¿Código expirado?
                if (registro.CodigoExpiracion < DateTime.Now)
                    return ErrorVar("El código ha expirado. Solicita uno nuevo.");

                // ¿Código correcto?
                if (registro.CodigoVerificacion != codigo)
                {

                    cdRegistro.IncrementarIntentos(RegistroID);
                    int intentosRestantes = MAX_INTENTOS - (registro.Intentos + 1);
                    return ErrorVar($"Código incorrecto. Te quedan {intentosRestantes} intentos.");
                }

                // ══════════════════════════════════════════
                // CONFIRMAR REGISTRO (SP)
                // ══════════════════════════════════════════

                int cuentaId = cdRegistro.ConfirmarRegistro(RegistroID);

                //EXTRAÑO PORQUE YA SE VERIFICO ANTES
                if (cuentaId == -1)
                    return ErrorVar("Este correo ya fue registrado por otro usuario");

                if (cuentaId <= 0)
                    return ErrorVar("Error al confirmar el registro. Intenta nuevamente.");

                // ══════════════════════════════════════════
                // ENVIAR EMAIL DE BIENVENIDA
                // ══════════════════════════════════════════
                string nombreCompleto = $"{registro.PrimerNombre} {registro.PrimerApellido}";
                await CN_Email.Bienvenida(registro.Email, nombreCompleto);

                // ══════════════════════════════════════════
                // ÉXITO
                // ══════════════════════════════════════════

                return new notifyVarDTO
                {
                    resultado = true,
                    mensajeSalida = "¡Cuenta verificada exitosamente!",
                    codigo = cuentaId
                };
            }

            #endregion

            #region PASO 3: REENVIAR CÓDIGO

            /// <summary>
            /// Reenvía el código de verificación
            /// </summary>
            public async Task<notifyDTO> ReenviarCodigo(string busqueda)
            {
                // Obtener registro
                var registro = cdRegistro.ObtenerRegistroTemporal(busqueda);

                if (registro == null)
                    return notifyDTO.Error("Registro no encontrado. Debes registrarte nuevamente.");

                if (registro.Verificado)
                    return notifyDTO.Error("Este registro ya fue verificado");

                // ¿Excedió reenvíos?
                if (registro.Reenvios >= MAX_REENVIOS)
                    return notifyDTO.Error("Excediste el límite de reenvíos. Debes registrarte nuevamente.");

                // ¿Debe esperar?
                if (registro.UltimoReenvio.HasValue)
                {
                    var segundosTranscurridos = (DateTime.Now - registro.UltimoReenvio.Value).TotalSeconds;
                    if (segundosTranscurridos < SEGUNDOS_ENTRE_REENVIOS)
                    {
                        int esperar = SEGUNDOS_ENTRE_REENVIOS - (int)segundosTranscurridos;
                        return notifyDTO.Error($"Espera {esperar} segundos para solicitar otro código");
                    }
                }

                // Generar nuevo código
                string nuevoCodigo = GenerarCodigo();

                bool actualizado = cdRegistro.ActualizarCodigoVerificacion(busqueda, nuevoCodigo);

                if (!actualizado)
                    return notifyDTO.Error("Error al generar nuevo código");

                // Enviar email
                string nombreCompleto = $"{registro.PrimerNombre} {registro.PrimerApellido}";
                var resultadoEmail = await CN_Email.Verificacion(
                    registro.Email,
                    nombreCompleto,
                    nuevoCodigo
                );

                if (!resultadoEmail.Exitoso)
                    return notifyDTO.Error("No pudimos enviar el correo. Intenta nuevamente.");

                int reenviosRestantes = MAX_REENVIOS - (registro.Reenvios + 1);
                return notifyDTO.Exito($"Código reenviado. Te quedan {reenviosRestantes} reenvíos.");
            }

            #endregion

            #region MÉTODOS AUXILIARES PRIVADOS

            //Verifica el formato del correo
            private bool EsEmailValido(string email)
            {
                if (string.IsNullOrWhiteSpace(email)) return false;
                string patron = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
                return Regex.IsMatch(email.Trim(), patron);
            }

            //Validacion de la contraseña
            private notifyDTO ValidarPassword(string password)
            {
                //Tamaño
                if (password.Length < PASSWORD_MIN_LONGITUD)
                    return notifyDTO.Error($"La contraseña debe tener al menos {PASSWORD_MIN_LONGITUD} caracteres");

                //Minimo una mayuscula
                if (!Regex.IsMatch(password, @"[A-Z]"))
                    return notifyDTO.Error("La contraseña debe tener al menos una mayúscula");

                //Al menos un numero
                if (!Regex.IsMatch(password, @"[0-9]"))
                    return notifyDTO.Error("La contraseña debe tener al menos un número");

                return notifyDTO.Exito("OK");
            }

            //Validar numero de telefono
            private bool EsTelefonoValido(string telefono)
            {
                //si esta vacio se pasa directamente al ser opcional
                if (string.IsNullOrWhiteSpace(telefono)) return true;
                //minimo 7 maximo 15 numeros
                string soloNumeros = Regex.Replace(telefono, @"[^\d]", "");
                return soloNumeros.Length >= 7 && soloNumeros.Length <= 15;
            }

            //Genera codigo aleatorio para validar
            private string GenerarCodigo()
            {
                using (var rng = new RNGCryptoServiceProvider())
                {
                    byte[] bytes = new byte[4];
                    rng.GetBytes(bytes);
                    int numero = Math.Abs(BitConverter.ToInt32(bytes, 0)) % 900000 + 100000;
                    return numero.ToString();
                }
            }
    
            // Obtener el correo a enmascarar
            public string CN_ObtenerRegistroTemporal(string busqueda)
            {
                if (string.IsNullOrWhiteSpace(busqueda))
                    return null;

                string registro;

                // ¿Es un ID?
                if (int.TryParse(busqueda, out int id))
                {
                    var correo = cdRegistro.ObtenerRegistroTemporalPorID(id);
                    registro = correo.Email;
                }
                else
                {
                    // Asumimos que es correo
                    string emailNormalizado = busqueda.Trim().ToLower();
                    var correo = cdRegistro.ObtenerRegistroTemporal(emailNormalizado);
                    registro = correo.Email;
                }

                if (registro == null)
                    return null;

                return registro;
            }
            #endregion

            //Mensaje de error que se envia con formato para presentar en el Notify
            private notifyVarDTO ErrorVar(string mensaje)
            {
                return new notifyVarDTO
                {
                    resultado = false,
                    mensajeSalida = mensaje,
                    codigo = 0
                };
            }

        }
    }
}