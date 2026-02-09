using capa_dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_datos
{
    public class CD_Registro
    {
        //Instancia de la base de datos
        private ColitasFelicesDataContext db = new ColitasFelicesDataContext();

        #region CONSULTAS DIRECTAS
        /// <summary>
        /// Verifica si el email ya existe en la tabla cuenta
        /// </summary>
        public bool ExisteEmailEnCuenta(string email)
        {
            email = email.Trim().ToLower();
            return db.cuenta.Any(c => c.Email == email);
        }


        /// <summary>
        /// Obtiene registro temporal por email
        /// </summary>
        public registro_temporal ObtenerRegistroTemporal(string email)
        {
            email = email.Trim().ToLower();
            return db.registro_temporal.FirstOrDefault(r => r.Email == email);
        }

        /// <summary>
        /// Obtiene registro temporal por ID
        /// </summary>
        public registro_temporal ObtenerRegistroTemporalPorID(int registroId)
        {
            return db.registro_temporal.FirstOrDefault(r => r.RegistroID == registroId);
        }

        /// <summary>
        /// Inserta nuevo registro temporal
        /// </summary>
        public int InsertarRegistroTemporal(RegistroTemporalDTO dto)
        {
            try
            {
                var registro = new registro_temporal
                {
                    Email = dto.Email.Trim().ToLower(),
                    PasswordHash = dto.PasswordHash,
                    PrimerNombre = dto.PrimerNombre.Trim(),
                    SegundoNombre = string.IsNullOrWhiteSpace(dto.SegundoNombre) ? null : dto.SegundoNombre.Trim(),
                    PrimerApellido = dto.PrimerApellido.Trim(),
                    SegundoApellido = string.IsNullOrWhiteSpace(dto.SegundoApellido) ? null : dto.SegundoApellido.Trim(),
                    Telefono = string.IsNullOrWhiteSpace(dto.Telefono) ? null : dto.Telefono.Trim(),
                    CodigoVerificacion = dto.CodigoVerificacion,
                    CodigoExpiracion = DateTime.Now,
                    FechaCreacion = DateTime.Now.AddMinutes(10)

                    // CodigoExpiracion y FechaCreacion usan DEFAULT de la BD
                };

                db.registro_temporal.InsertOnSubmit(registro);
                db.SubmitChanges();

                return registro.RegistroID;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en InsertarRegistroTemporal: " + ex.Message);
                return 0;
            }
        }

        /// <summary>
        /// Actualiza código de verificación (para reenvío)
        /// </summary>
        public bool ActualizarCodigoVerificacion(string correo, string nuevoCodigo)
        {
            try
            {
                var registro = db.registro_temporal.FirstOrDefault(r => r.Email == correo);
                if (registro == null) return false;

                registro.CodigoVerificacion = nuevoCodigo;
                registro.CodigoExpiracion = DateTime.Now.AddMinutes(15);
                registro.Reenvios = (byte)(registro.Reenvios + 1);
                registro.UltimoReenvio = DateTime.Now;

                db.SubmitChanges();
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ActualizarCodigoVerificacion: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Incrementa contador de intentos fallidos
        /// </summary>
        public bool IncrementarIntentos(int registroId)
        {
            try
            {
                var registro = db.registro_temporal.FirstOrDefault(r => r.RegistroID == registroId);
                if (registro == null) return false;

                registro.Intentos = (byte)(registro.Intentos + 1);
                db.SubmitChanges();
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en IncrementarIntentos: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Elimina registro temporal
        /// </summary>
        public bool EliminarRegistroTemporal(int registroId)
        {
            try
            {
                var registro = db.registro_temporal.FirstOrDefault(r => r.RegistroID == registroId);
                if (registro == null) return false;

                db.registro_temporal.DeleteOnSubmit(registro);
                db.SubmitChanges();
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en EliminarRegistroTemporal: " + ex.Message);
                return false;
            }
        }

        #endregion

        #region STORED PROCEDURE

        /// <summary>
        /// Confirma el registro: mueve datos de registro_temporal a cuenta + perfil
        /// Retorna: >0 = CuentaID creada, 0 = Error, -1 = Email duplicado
        /// </summary>
        public int ConfirmarRegistro(int registroId)
        {
            try
            {
                int? cuentaId = null;
                db.SEG_ConfirmarRegistro(registroId, ref cuentaId);
                return cuentaId ?? 0;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ConfirmarRegistro: " + ex.Message);
                return 0;
            }
        }

        #endregion
    }
}












