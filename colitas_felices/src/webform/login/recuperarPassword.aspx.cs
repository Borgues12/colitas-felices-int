using capa_negocio.Seguridad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.login
{
    public partial class recuperarPassword : System.Web.UI.Page
    {
        private readonly CN_RecuperarPassword _negocio = new CN_RecuperarPassword();

        protected void Page_Load(object sender, EventArgs e) { }

        // PASO 1
        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            Session["Recuperacion_Email"] = email;

            RegisterAsyncTask(new PageAsyncTask(async () =>
            {
                await _negocio.SolicitarRecuperacion(email);

                MostrarPanel(2);
                MostrarMensaje("Si el correo existe recibirás un código en tu bandeja.", false);
            }));
        }

        // PASO 2
        protected void btnVerificar_Click(object sender, EventArgs e)
        {
            string email = Session["Recuperacion_Email"]?.ToString();
            string codigo = txtCodigo.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                MostrarPanel(1);
                MostrarMensaje("Sesión expirada, vuelve a ingresar tu correo.", true);
                return;
            }

            bool valido = _negocio.VerificarCodigo(email, codigo);

            if (!valido)
            {
                MostrarPanel(2);
                MostrarMensaje("Código incorrecto o expirado.", true);
                return;
            }

            Session["Recuperacion_Codigo"] = codigo;
            MostrarPanel(3);
            MostrarMensaje("", false);
        }

        // PASO 3
        protected void btnCambiar_Click(object sender, EventArgs e)
        {
            string email = Session["Recuperacion_Email"]?.ToString();
            string codigo = Session["Recuperacion_Codigo"]?.ToString();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(codigo))
            {
                MostrarPanel(1);
                MostrarMensaje("Sesión expirada, vuelve a empezar.", true);
                return;
            }

            bool ok = _negocio.CambiarPassword(email, codigo, txtPassword.Text);

            if (!ok)
            {
                MostrarPanel(3);
                MostrarMensaje("Error al cambiar la contraseña, intenta de nuevo.", true);
                return;
            }

            Session.Remove("Recuperacion_Email");
            Session.Remove("Recuperacion_Codigo");

            MostrarMensaje("Contraseña actualizada correctamente.", false);
            Response.AddHeader("Refresh", "2;url=Login");
        }

        // HELPERS
        private void MostrarPanel(int paso)
        {
            pnlEmail.Visible = paso == 1;
            pnlCodigo.Visible = paso == 2;
            pnlPassword.Visible = paso == 3;
        }

        private void MostrarMensaje(string texto, bool esError)
        {
            if (string.IsNullOrEmpty(texto))
            {
                lblMensaje.Visible = false;
                return;
            }
            lblMensaje.Text = texto;
            lblMensaje.CssClass = esError ? "msg-error" : "msg-exito";
            lblMensaje.Visible = true;
        }
    }
}