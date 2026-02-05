using System;
using System.Web;

namespace colitas_felices
{
    public static class SessionRegistrarHelper
    {
        // ========== PROPIEDADES ==========

        public static int CuentaTemporalID
        {
            get
            {
                if (HttpContext.Current?.Session["CuentaIDTemporal"] != null)
                    return Convert.ToInt32(HttpContext.Current.Session["CuentaIDTemporal"]);
                return 0;
            }
        }

        public static string EmailTemporal
        {
            get
            {
                return HttpContext.Current?.Session["EmailTemporal"]?.ToString() ?? string.Empty;
            }
        }

        public static bool TieneRegistroPendiente
        {
            get
            {
                return HttpContext.Current?.Session["CuentaIDTemporal"] != null;
            }
        }

        // ========== MÉTODOS ==========

        public static void GuardarRegistroTemporal(int cuentaID, string email)
        {
            var session = HttpContext.Current?.Session;
            if (session == null) return;

            session["CuentaIDTemporal"] = cuentaID;
            session["EmailTemporal"] = email;
            session["RegistroTimestamp"] = DateTime.Now;
        }

        /// <summary>
        /// Obtiene los datos del registro temporal como tupla
        /// </summary>
        public static (int CuentaID, string Email) ObtenerRegistroTemporal()
        {
            return (CuentaTemporalID, EmailTemporal);
        }

        public static void ActualizarEmail(string nuevoEmail)
        {
            if (TieneRegistroPendiente && HttpContext.Current?.Session != null)
            {
                HttpContext.Current.Session["EmailTemporal"] = nuevoEmail;
            }
        }

        public static void LimpiarRegistroTemporal()
        {
            var session = HttpContext.Current?.Session;
            if (session == null) return;

            session.Remove("CuentaIDTemporal");
            session.Remove("EmailTemporal");
            session.Remove("RegistroTimestamp");
        }

        public static bool RegistroTemporalValido(int minutosExpiracion = 30)
        {
            if (!TieneRegistroPendiente)
                return false;

            var session = HttpContext.Current?.Session;
            if (session == null || session["RegistroTimestamp"] == null)
                return true;

            DateTime timestamp = Convert.ToDateTime(session["RegistroTimestamp"]);
            return DateTime.Now <= timestamp.AddMinutes(minutosExpiracion);
        }
    }
}