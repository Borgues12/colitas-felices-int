using capa_datos;
using capa_datos.Seguridad;
using capa_dto;
using capa_DTO.DTO.Seguridad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace capa_negocio.Seguridad
{
    public class CN_Login
    {

        private CD_Login objLogin = new CD_Login();

        #region LOGIN
        public notifyDTO Login(string email, string password)
        {
            if (string.IsNullOrWhiteSpace(email))
                return notifyDTO.Error("El correo electrónico es requerido.");

            if (string.IsNullOrWhiteSpace(password))
                return notifyDTO.Error("La contraseña es requerida.");

            var cuenta = objLogin.ObtenerCuentaPorEmail(email);

            if (cuenta == null)
                return notifyDTO.Error("Cuenta no registrada.");

            objLogin.VerificarYDesbloquear(cuenta.CuentaID);

            cuenta = objLogin.ObtenerCuentaPorEmail(email);

            if (cuenta.Estado == 0 && cuenta.BloqueadoHasta.HasValue)
            {
                int minutos = (int)(cuenta.BloqueadoHasta.Value - DateTime.Now).TotalMinutes + 1;
                return notifyDTO.Error($"Cuenta bloqueada. Intenta en {minutos} minuto(s).");
            }

            if (cuenta.Estado == 0)
                return notifyDTO.Error("Tu cuenta ha sido desactivada. Contacta al administrador.");

            if (!BCrypt.Net.BCrypt.Verify(password, cuenta.PasswordHash))
            {
                objLogin.RegistrarIntentoFallido(cuenta.CuentaID);

                cuenta = objLogin.ObtenerCuentaPorEmail(email);
                if (cuenta == null)
                    return notifyDTO.Error("Credenciales incorrectas.");

                if (cuenta.Estado == 0)
                    return notifyDTO.Error("Cuenta bloqueada temporalmente por múltiples intentos fallidos.");

                return notifyDTO.Error("Credenciales incorrectas.");
            }

            objLogin.ReiniciarIntentos(cuenta.CuentaID);

            //  Mapear a DTO — nunca exponer la entidad de base de datos
            var datosLogin = new LoginDTO
            {
                CuentaID = cuenta.CuentaID,
                RolID = cuenta.RolID,
                Email = cuenta.Email
            };

            return notifyVarDTO.ExitoConDatos("Inicio de sesión exitoso.", datosLogin);
        }

        #endregion
    }
}
