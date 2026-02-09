using System;
using System.Collections.Generic;
using System.Web;

namespace colitas_felices
{
    /// <summary>
    /// Helper minimalista para manejo de sesiones.
    /// SOLO almacena lo mínimo necesario para identificar al usuario.
    /// </summary>
    public static class Sessions
    {
        #region CONSTANTES

        // Roles del sistema
        public const int ROL_USUARIO = 1;
        public const int ROL_ADMIN = 2;

        // Keys de sesión - SOLO LO ESENCIAL
        private const string KEY_CUENTA_ID = "CuentaID";
        private const string KEY_ROL = "Rol";

        // Keys para registro temporal
        private const string KEY_REGISTRO_CORREO = "RegistroCorreo";

        #endregion

        #region PROPIEDADES - SESIÓN DE USUARIO

        /// <summary>
        /// ID de la cuenta del usuario logueado
        /// </summary>
        public static int CuentaID
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session?[KEY_CUENTA_ID] != null)
                    return Convert.ToInt32(session[KEY_CUENTA_ID]);
                return 0;
            }
            private set
            {
                HttpContext.Current.Session[KEY_CUENTA_ID] = value;
            }
        }

        /// <summary>
        /// Rol del usuario logueado
        /// </summary>
        public static int Rol
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session?[KEY_ROL] != null)
                    return Convert.ToInt32(session[KEY_ROL]);
                return 0;
            }
            private set
            {
                HttpContext.Current.Session[KEY_ROL] = value;
            }
        }

        #endregion

        #region PROPIEDADES - REGISTRO TEMPORAL

        /// <summary>
        /// ID del registro temporal (para verificación)
        /// </summary>
        public static string RegistroCorreo
        {
            get
            {
                var session = HttpContext.Current?.Session;
                return session?[KEY_REGISTRO_CORREO] as string;
            }
            private set
            {
                HttpContext.Current.Session[KEY_REGISTRO_CORREO] = value;
            }
        }

        #endregion

        #region PROPIEDADES - VERIFICACIÓN DE ESTADO

        /// <summary>
        /// Verifica si hay un usuario logueado
        /// </summary>
        public static bool EstaLogueado
        {
            get { return CuentaID > 0; }
        }

        /// <summary>
        /// Verifica si el usuario es administrador
        /// </summary>
        public static bool EsAdmin
        {
            get { return Rol == ROL_ADMIN; }
        }

        /// <summary>
        /// Verifica si hay un registro pendiente de verificación
        /// </summary>
        public static bool TieneRegistroPendiente
        {
            get
            {
                return !string.IsNullOrWhiteSpace(RegistroCorreo);
            }
        }

        #endregion

        #region MÉTODOS - INICIAR/CERRAR SESIÓN

        /// <summary>
        /// Inicia sesión de usuario (SOLO guarda ID y Rol)
        /// </summary>
        public static void IniciarSesion(int cuentaId, int rol)
        {
            // ✅ Regenerar sesión para prevenir fixation
            RegenerarSesion();

            CuentaID = cuentaId;
            Rol = rol;

            // ✅ Registrar última actividad
            UltimaActividad = DateTime.Now;
        }
        private static void RegenerarSesion()
        {
            var session = HttpContext.Current.Session;

            // Guardar datos temporalmente si existen
            var datosTemp = new Dictionary<string, object>();
            foreach (string key in session.Keys)
            {
                datosTemp[key] = session[key];
            }

            // Abandonar sesión vieja
            session.Abandon();

            // Limpiar cookie
            HttpContext.Current.Response.Cookies.Add(
                new HttpCookie("ASP.NET_SessionId", "")
            );
        }

        // ✅ Validar timeout personalizado
        private static DateTime? UltimaActividad
        {
            get
            {
                var session = HttpContext.Current?.Session;
                if (session?["UltimaActividad"] != null)
                    return (DateTime)session["UltimaActividad"];
                return null;
            }
            set
            {
                HttpContext.Current.Session["UltimaActividad"] = value;
            }
        }

        public static bool ValidarTimeout(int minutosMax = 20)
        {
            if (!EstaLogueado || UltimaActividad == null)
                return false;

            if (DateTime.Now.Subtract(UltimaActividad.Value).TotalMinutes > minutosMax)
            {
                CerrarSesion();
                return false;
            }

            UltimaActividad = DateTime.Now; // Renovar
            return true;
        }


        /// <summary>
        /// Cierra la sesión completamente
        /// </summary>
        public static void CerrarSesion()
        {
            var session = HttpContext.Current?.Session;
            if (session != null)
            {
                session.Clear();
                session.Abandon();
            }
        }

        #endregion

        #region MÉTODOS - REGISTRO TEMPORAL

        /// <summary>
        /// Guarda ID de registro temporal para verificación
        /// </summary>
        public static void GuardarRegistroTemporal(string correoGuardar)
        {
            RegistroCorreo = correoGuardar;
        }
     
        /// <summary>
        /// Limpia datos de registro temporal
        /// </summary>
        public static void LimpiarRegistroTemporal()
        {
            var session = HttpContext.Current?.Session;
            session?.Remove(KEY_REGISTRO_CORREO);
        }

        #endregion

        #region MÉTODOS - VALIDACIÓN DE ACCESO

        /// <summary>
        /// Valida que el usuario esté logueado
        /// </summary>
        /// <returns>True si está logueado, False si no</returns>
        public static bool ValidarLogin()
        {
            return EstaLogueado;
        }

        /// <summary>
        /// Valida que el usuario sea administrador
        /// </summary>
        /// <returns>True si es admin, False si no</returns>
        public static bool ValidarAdmin()
        {
            return EsAdmin;
        }

        #endregion
    }
}