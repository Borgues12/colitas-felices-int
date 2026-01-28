using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform
{
    public partial class panleUsuario : notificacionesMaster
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Logout_Click(object sender, EventArgs e)
        {
            CerrarSesion();
        }
    }
}