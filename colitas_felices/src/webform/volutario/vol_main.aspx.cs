using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.volutario
{
    public partial class vol_main : notificaciones
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!EstaLogueado)
            {
                // Si no está logueado, redirigir al login
                Response.Redirect("~/src/webform/main.aspx");
                return;
            }
        }
        protected void Logout_Click(object sender, EventArgs e)
        {
            CerrarSesion();
        }
    }
}