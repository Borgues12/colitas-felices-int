using capa_negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.masterPage
{
    public partial class panel : System.Web.UI.MasterPage
    {

        public dynamic perfilUsuario = null;
        protected void Logout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/login.aspx");
        }

        public string ObtenerFotoUsuario()
        {
            return "https://cdn-icons-png.flaticon.com/512/149/149071.png";
        }

        public string ObtenerNombreNormalizado()
        {
            return "Usuario";
        }

        public string ObtenerNombreRol()
        {
            return "Administrador";
        }

    }
}