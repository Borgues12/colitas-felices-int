using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;

namespace colitas_felices
{
    public class notificaciones : Page
    {

        // Constantes para roles
        public const int ROL_ADMIN = 1;
        public const int ROL_USUARIO = 2;

        public int UsuarioID
        {
            get
            {
                if (Session["CuentaID"] != null) //BUSCA ID EN SESSION Y LO TRANFORMA, SI NO HAY, DEVUELVE 0
                    return Convert.ToInt32(Session["CuentaID"]);
                return 0;
            }
        }

        public int RolUsuario
        {
            get
            {
                if (Session["Rol"] != null)
                    return Convert.ToInt32(Session["Rol"]);
                return 0;
            }
        }

        public bool EstaLogueado
        {
            get
            {
                return Session["CuentaID"] != null;
                //VERIFICA SI HAY UN USUARIO LOGUEADO AL COMPROBAR SI HAY UN ID EN SESSION
            }
        }

        // MÉTODOS PARA MENSAJES

        protected void MostrarMensaje(string mensaje, string tipo)// recibe el mensaje y el tipo: success, warning, error
        {
            string script = "";

            switch (tipo)
            {
                //construye el script JS según el tipo de mensaje, utiliza $ para interpolación de cadenas
                case "success":
                    script = $"notyf.success('{EscaparJS(mensaje)}');";
                    break;
                case "warning":
                    script = $"notyf.open({{ type: 'warning', message: '{EscaparJS(mensaje)}' }});";
                    break;
                case "error":
                default:
                    script = $"notyf.error('{EscaparJS(mensaje)}');";
                    break;
            }

            // Registra y ejecuta el script en la página
            ScriptManager.RegisterStartupScript(this, GetType(), "mensaje", script, true);
        }

        // Escapa caracteres especiales en el texto para evitar errores en JavaScript
        private string EscaparJS(string texto)
        {
            // Si el texto es nulo o vacío, devuelve una cadena vacía
            if (string.IsNullOrEmpty(texto))
                return "";
            // Reemplaza caracteres especiales
            return texto
                .Replace("\\", "\\\\")
                .Replace("'", "\\'")
                .Replace("\"", "\\\"")
                .Replace("\n", "\\n")
                .Replace("\r", "");
        }

        // MÉTODOS DE SESIÓN

        // Inicia sesión estableciendo las variables de sesión
        protected void IniciarSesion(int usuarioID, int rol)
        {
            Session["CuentaID"] = usuarioID;
            Session["Rol"] = rol;
        }

        protected void CerrarSesion()
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/src/webform/main.aspx");
        }

        // Método para obtener la ruta sin redirigir
        protected string ObtenerRutaPorRol()
        {
            if (!EstaLogueado)
                return "~/src/webform/main.aspx";

            switch (RolUsuario)
            {
                case ROL_ADMIN:
                    return "/src/webform/admin/ad_main.aspx";
                case ROL_USUARIO:
                    return "/src/webform/padrino/pa_main.aspx";
                default:
                    return "/src/webform/main.aspx";
            }
        }
    }
}
