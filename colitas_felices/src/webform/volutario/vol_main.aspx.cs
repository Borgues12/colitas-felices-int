using capa_negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.volutario
{
    public partial class vol_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Validar que el usuario esté logueado
            Navigation.RequiereLogin();

            if (!IsPostBack)
            {
               
            }
        }
        protected void Logout_Click(object sender, EventArgs e)
        {
            // Cerrar sesión y redirigir a login
            Navigation.CerrarSesionYRedirigir();
        }
    }
}