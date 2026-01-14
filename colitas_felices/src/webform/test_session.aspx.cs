using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform
{
    public partial class test_session : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnCrearSesion_Click(object sender, EventArgs e)
        {
            // Simular un login
            Session["UsuarioID"] = 1;
            Session["Nombre"] = "Dany";
            Session["Rol"] = "Admin";

            lblEstado.Text = "✅ Sesión creada correctamente";
            lblEstado.ForeColor = System.Drawing.Color.Green;
        }

        protected void btnVerSesion_Click(object sender, EventArgs e)
        {
            if (Session["UsuarioID"] != null)
            {
                lblEstado.Text = $"✅ Sesión activa: " +
                    $"ID={Session["UsuarioID"]}, " +
                    $"Nombre={Session["Nombre"]}, " +
                    $"Rol={Session["Rol"]}";
                lblEstado.ForeColor = System.Drawing.Color.Green;
            }
            else
            {
                lblEstado.Text = "❌ No hay sesión activa";
                lblEstado.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnEliminarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            lblEstado.Text = "🗑️ Sesión eliminada";
            lblEstado.ForeColor = System.Drawing.Color.Orange;
        }
    }
}