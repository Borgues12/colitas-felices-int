//using capa_dto;
//using capa_dto.DTO;
//using System;
//using System.Data.Linq;
//using System.Linq;

//namespace capa_datos
//{
//    /// Capa de datos para el módulo de Seguridad
//    /// Maneja: Registro, Login, Verificación, Recuperación
//    public class CD_Login_Registro
//    {
//        private ColitasFelicesDataContext cf = new ColitasFelicesDataContext();

//        // ============================================================
//        // REGISTRO
//        // ============================================================
//        public RegistroInternoDTO Registrar(string email, string passwordHash, string primerNombre, string primerApellido)
//        {
//            try
//            {
//                int? cuentaID = null;
//                string token = null;
//                bool? exitoso = null;
//                string mensaje = null;

//                cf.SEG_Registrar(
//                    email,
//                    passwordHash,
//                    primerNombre,
//                    primerApellido,
//                    ref cuentaID,
//                    ref token,
//                    ref exitoso,
//                    ref mensaje
//                );

//                return new RegistroInternoDTO
//                {
//                    Exitoso = exitoso ?? false,
//                    CuentaID = cuentaID ?? 0,
//                    Token = token,
//                    Email = email,
//                    Nombre = primerNombre,
//                    Mensaje = mensaje ?? ""
//                };
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CD_Seguridad.Registrar: " + ex.Message);
//                return new RegistroInternoDTO
//                {
//                    Exitoso = false,
//                    Mensaje = "Error de conexión: " + ex.Message
//                };
//            }
//        }
    

//        public VerificacionDTO VerificarCodigo(string email, string codigo)
//        {
//            try
//            {
//                string token = null;
//                bool? exitoso = null;
//                string mensaje = null;

//                cf.SEG_VerificarCodigo(
//                    "VERIFICAR",
//                    email,
//                    codigo,
//                    ref token,      // No se usa en verificar
//                    ref exitoso,
//                    ref mensaje
//                );

//                return new VerificacionDTO
//                {
//                    Exitoso = exitoso ?? false,
//                    Mensaje = mensaje ?? ""
//                };
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CD_Login_Registro.VerificarCodigo: " + ex.Message);
//                return new VerificacionDTO
//                {
//                    Exitoso = false,
//                    Mensaje = "Error de conexión: " + ex.Message
//                };
//            }
//        }

//        /// Genera y retorna nuevo código de verificación
//        public VerificacionDTO ReenviarCodigo(string email)
//        {
//            try
//            {
//                string token = null;
//                bool? exitoso = null;
//                string mensaje = null;

//                cf.SEG_VerificarCodigo(
//                    "REENVIAR",
//                    email,
//                    null,           // No se necesita código para reenviar
//                    ref token,
//                    ref exitoso,
//                    ref mensaje
//                );

//                // Obtener nombre del usuario para el email
//                string nombre = "";
//                if (exitoso == true)
//                {
//                    var cuenta = cf.Cuenta.FirstOrDefault(c => c.Email == email);
//                    if (cuenta != null)
//                    {
//                        var persona = cf.Persona.FirstOrDefault(p => p.PersonaID == cuenta.PersonaID);
//                        nombre = persona?.PrimerNombre ?? "";
//                    }
//                }

//                return new VerificacionDTO
//                {
//                    Exitoso = exitoso ?? false,
//                    Token = token,
//                    Nombre = nombre,
//                    Mensaje = mensaje ?? ""
//                };
//            }
//            catch (Exception ex)
//            {
//                System.Diagnostics.Debug.WriteLine("Error en CD_Login_Registro.ReenviarCodigo: " + ex.Message);
//                return new VerificacionDTO
//                {
//                    Exitoso = false,
//                    Mensaje = "Error de conexión: " + ex.Message
//                };
//            }
//        }

//    }
//}