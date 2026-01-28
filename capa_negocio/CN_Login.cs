using BCrypt.Net;
using capa_datos;
using capa_dto;
using capa_dto.DTO;
using System.Threading.Tasks;

namespace capa_negocio
{
    public class CN_Login
    {
        private CD_Login_Registro objCD = new CD_Login_Registro();
        private const int BCRYPT_WORK_FACTOR = 11;

        /// <summary>
        /// Registra usuario nuevo y envía email de verificación
        /// </summary>
        public async Task<notifyDTO> RegistrarAsync(
            string email,
            string password,
            string confirmarPassword,
            string primerNombre,
            string primerApellido)
        {
            // ========== VALIDACIONES ==========

            if (string.IsNullOrWhiteSpace(email))
                return Respuesta(false, "El correo electrónico es obligatorio.");

            if (string.IsNullOrWhiteSpace(password))
                return Respuesta(false, "La contraseña es obligatoria.");

            if (password != confirmarPassword)
                return Respuesta(false, "Las contraseñas no coinciden.");

            if (password.Length < 6)
                return Respuesta(false, "La contraseña debe tener al menos 6 caracteres.");

            if (string.IsNullOrWhiteSpace(primerNombre))
                return Respuesta(false, "El nombre es obligatorio.");

            if (string.IsNullOrWhiteSpace(primerApellido))
                return Respuesta(false, "El apellido es obligatorio.");

            // ========== GENERAR HASH ==========

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(password, BCRYPT_WORK_FACTOR);

            // ========== LLAMAR CD ==========

            var resultado = objCD.Registrar(
                email.Trim().ToLower(),
                passwordHash,
                primerNombre.Trim(),
                primerApellido.Trim()
            );

            // ========== ENVIAR EMAIL DE VERIFICACIÓN ==========

            if (resultado.Exitoso && !string.IsNullOrEmpty(resultado.Token))
            {
                var emailResult = await CN_Email.Verificacion(
                    resultado.Email,
                    resultado.Nombre,
                    resultado.Token
                );

                // Log si falla el email (registro sigue siendo exitoso)
                if (!emailResult.Exitoso)
                {
                    System.Diagnostics.Debug.WriteLine($"⚠️ Email no enviado: {emailResult.Mensaje}");
                }
            }

            // ========== RETORNAR ==========

            return Respuesta(resultado.Exitoso, resultado.Mensaje);
        }

        // ========== HELPER ==========

        private notifyDTO Respuesta(bool exito, string mensaje)
        {
            return new notifyDTO { resultado = exito, mensajeSalida = mensaje };
        }
    }
}