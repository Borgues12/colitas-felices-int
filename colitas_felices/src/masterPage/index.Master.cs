using capa_negocio;
using System;
using capa_dto.DTO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices
{
    public partial class index : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //CargarEstadoSesion();
            }
        }

        ///// <summary>
        ///// Carga el estado de la sesión y muestra el panel correspondiente
        ///// </summary>
        //private void CargarEstadoSesion()
        //{
        //    // Verificar si hay sesión activa
        //    if (Session["CuentaID"] != null)
        //    {
        //        int cuentaID = Convert.ToInt32(Session["CuentaID"]);

        //        // Cargar datos del usuario
        //        CN_Login objCN = new CN_Login();
        //        PerfilDTO perfil = objCN.CargarDatosUsuario(cuentaID);

        //        if (perfil != null)
        //        {
        //            // Mostrar panel de usuario logueado
        //            pnlNoLogueado.Visible = false;
        //            pnlLogueado.Visible = true;

        //            // Cargar nombre
        //            litNombreUsuario.Text = !string.IsNullOrEmpty(perfil.NombreCompleto)
        //                ? perfil.NombreCompleto
        //                : perfil.Email.Split('@')[0];

        //            // Cargar foto de perfil
        //            if (perfil.FotoPerfil != null && perfil.FotoPerfil.Length > 0)
        //            {
        //                imgFotoPerfil.ImageUrl = "data:image/jpeg;base64," + Convert.ToBase64String(perfil.FotoPerfil);
        //            }
        //            else
        //            {
        //                // Imagen por defecto
        //                imgFotoPerfil.ImageUrl = "~/Imagenes/avatar-default.png";
        //            }
        //        }
        //        else
        //        {
        //            // Si no se pueden cargar los datos, cerrar sesión
        //            CerrarSesion();
        //        }
        //    }
        //    else
        //    {
        //        // No hay sesión - mostrar botón de login
        //        pnlNoLogueado.Visible = true;
        //        pnlLogueado.Visible = false;
        //    }
        //}

        /// <summary>
        /// Evento para cerrar sesión
        /// </summary>
        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            CerrarSesion();
        }

        /// <summary>
        /// Limpia la sesión y redirige al inicio
        /// </summary>
        private void CerrarSesion()
        {
            // Limpiar todas las variables de sesión
            Session.Clear();
            Session.Abandon();

            // Limpiar cookies de autenticación si existen
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            }

            // Redirigir al inicio
            Response.Redirect("~/Inicio.aspx");
        }

        /// <summary>
        /// Método para verificar si el usuario está logueado (uso en páginas hijas)
        /// </summary>
        public bool EstaLogueado()
        {
            return Session["CuentaID"] != null;
        }

        /// <summary>
        /// Obtiene el ID de la cuenta actual
        /// </summary>
        public int ObtenerCuentaID()
        {
            if (Session["CuentaID"] != null)
            {
                return Convert.ToInt32(Session["CuentaID"]);
            }
            return 0;
        }

        /// <summary>
        /// Obtiene el rol del usuario actual
        /// </summary>
        public int ObtenerRol()
        {
            if (Session["Rol"] != null)
            {
                return Convert.ToInt32(Session["Rol"]);
            }
            return 0;
        }

        /// <summary>
        /// Verifica si el usuario tiene un rol específico
        /// </summary>
        public bool TieneRol(params int[] roles)
        {
            int rolActual = ObtenerRol();
            foreach (int rol in roles)
            {
                if (rolActual == rol) return true;
            }
            return false;
        }

        /// <summary>
        /// Redirige si no está logueado
        /// </summary>
        public void RequiereLogin()
        {
            if (!EstaLogueado())
            {
                // Guardar URL actual para redirigir después del login
                Session["ReturnUrl"] = Request.Url.AbsoluteUri;
                Response.Redirect("~/Login.aspx");
            }
        }

        /// <summary>
        /// Redirige si no tiene el rol requerido
        /// </summary>
        public void RequiereRol(params int[] rolesPermitidos)
        {
            RequiereLogin();

            if (!TieneRol(rolesPermitidos))
            {
                Response.Redirect("~/AccesoDenegado.aspx");
            }
        }
    }
}