using colitas_felices;
using System.Web;

namespace capa_negocio
{
    /// <summary>
    /// Helper para manejo de navegación y redirecciones.
    /// Separado de Sessions para mantener responsabilidades únicas.
    /// </summary>
    public class Navigation
    {
     #region RUTAS

        public const string RUTA_LOGIN_REGISTRO = "~/iniciar_sesion";
    public const string RUTA_VERIFICAR = "~/verificar";
    public const string RUTA_HOME = "~/";
    public const string RUTA_DASHBOARD = "~/dashboard";
    public const string RUTA_ADMIN = "~/admin";

#endregion

    #region REDIRECCIÓN POR ROL

    /// <summary>
    /// Obtiene la ruta según el rol del usuario
    /// </summary>
    public static string ObtenerRutaPorRol()
    {
        if (!Sessions.EstaLogueado)
            return RUTA_HOME;

        return Sessions.EsAdmin ? RUTA_ADMIN : RUTA_DASHBOARD;
    }

    /// <summary>
    /// Redirige al usuario según su rol
    /// </summary>
    public static void RedirigirPorRol()
    {
        HttpContext.Current.Response.Redirect(ObtenerRutaPorRol(), true);
    }

    #endregion

    #region REDIRECCIONES ESPECÍFICAS

    public static void IrALogin()
    {
        HttpContext.Current.Response.Redirect(RUTA_LOGIN_REGISTRO, true);
    }

    public static void IrARegistro()
    {
        HttpContext.Current.Response.Redirect(RUTA_LOGIN_REGISTRO, true);
    }

    public static void IrAVerificacion()
    {
        HttpContext.Current.Response.Redirect(RUTA_VERIFICAR, true);
    }

    public static void IrAHome()
    {
        HttpContext.Current.Response.Redirect(RUTA_HOME, true);
    }

    public static void IrADashboard()
    {
        HttpContext.Current.Response.Redirect(RUTA_DASHBOARD, true);
    }

    #endregion

    #region VALIDACIÓN CON REDIRECCIÓN

    /// <summary>
    /// Requiere que el usuario esté logueado, sino redirige a login
    /// </summary>
    public static void RequiereLogin()
    {
            if (!Sessions.ValidarTimeout())
            {
                Sessions.CerrarSesion();
                IrALogin();
            }

            if (!Sessions.EstaLogueado)
            {
                IrALogin();
            }
        }

        /// <summary>
        /// Requiere que el usuario sea admin, sino redirige
        /// </summary>
        public static void RequiereAdmin()
    {
        if (!Sessions.EstaLogueado)
        {
            IrALogin();
        }
        else if (!Sessions.EsAdmin)
        {
            IrADashboard();
        }
    }

    /// <summary>
    /// Si el usuario ya está logueado, redirige a su dashboard
    /// </summary>
    public static void RedirigirSiYaLogueado()
    {
        if (Sessions.EstaLogueado)
        {
            RedirigirPorRol();
        }
    }

    /// <summary>
    /// Cierra sesión y redirige a login
    /// </summary>
    public static void CerrarSesionYRedirigir()
    {
        Sessions.CerrarSesion();
        IrALogin();
    }

    #endregion
}
}
