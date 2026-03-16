using BCrypt.Net;
using capa_datos.Crud;
using capa_datos.Seguridad;
using capa_DTO.DTO.Seguridad;
using System;
using System.Threading.Tasks;

namespace capa_negocio.Seguridad
{
    public class CN_RecuperarPassword
    {
        private readonly CD_cuenta _cdCuenta = new CD_cuenta();
        private readonly CD_TokenRecuperacion _cdToken = new CD_TokenRecuperacion();
        private readonly CD_TokenTipo _cdTokenTipo = new CD_TokenTipo();

        /// <summary>
        /// Paso 1 — Recibe el email, genera el código y envía el correo
        /// Siempre retorna true aunque el email no exista (seguridad)
        /// </summary>
        public async Task<bool> SolicitarRecuperacion(string email)
        {
            try
            {
                var cuenta = _cdCuenta.ObtenerPorEmail(email);
                System.Diagnostics.Debug.WriteLine($"[Recuperar] Cuenta encontrada: {cuenta != null}");
                if (cuenta == null) return true;
                if (cuenta.Estado != 1) return true;

                bool tieneToken = _cdToken.TieneTokenVigente(cuenta.CuentaID);
                if (tieneToken) return true;

                int duracion = _cdTokenTipo.ObtenerDuracion((byte)TokenTipo.RecuperarPassword);
                string codigo = GenerarCodigo();

                _cdToken.InvalidarTokensAnteriores(cuenta.CuentaID);
                _cdToken.Crear(cuenta.CuentaID, codigo, duracion);

                var resultadoEmail = await CN_Email.Recuperacion(email, cuenta.PrimerNombre ?? email, codigo);
                System.Diagnostics.Debug.WriteLine($"[Recuperar] Correo exitoso: {resultadoEmail.Exitoso}");
                System.Diagnostics.Debug.WriteLine($"[Recuperar] Correo mensaje: {resultadoEmail.Mensaje}");

                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"[Recuperar] ERROR: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Paso 2 — Verifica que el código ingresado sea válido
        /// </summary>
        public bool VerificarCodigo(string email, string codigo)
        {
            try
            {
                var cuenta = _cdCuenta.ObtenerPorEmail(email);
                if (cuenta == null) return false;

                var token = _cdToken.ObtenerValido(cuenta.CuentaID, codigo);
                return token != null;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    "[CN_RecuperarPassword] Error en VerificarCodigo: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Paso 3 — Cambia la contraseña y marca el token como usado
        /// </summary>
        public bool CambiarPassword(string email, string codigo, string nuevaPassword)
        {
            try
            {
                var cuenta = _cdCuenta.ObtenerPorEmail(email);
                if (cuenta == null) return false;

                var token = _cdToken.ObtenerValido(cuenta.CuentaID, codigo);
                if (token == null) return false;

                string hash = BCrypt.Net.BCrypt.HashPassword(nuevaPassword);

                bool actualizado = _cdCuenta.ActualizarPassword(cuenta.CuentaID, hash);
                if (!actualizado) return false;

                _cdToken.MarcarUsado(token.TokenID);
                return true;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(
                    "[CN_RecuperarPassword] Error en CambiarPassword: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Genera un código numérico de 6 dígitos
        /// </summary>
        private string GenerarCodigo()
        {
            return new Random().Next(100000, 999999).ToString();
        }
    }
}