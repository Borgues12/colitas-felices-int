using System;
using System.Threading.Tasks;
using System.Web.UI;
using capa_negocio;
using capa_dto;

namespace colitas_felices.src
{
    public partial class login_registro : notificaciones
    {
        private notifyRegisterDTO _resultado;
        private CN_Registrar objRegistrar = new CN_Registrar();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["CuentaID"] != null)
            {
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        // ==================== REGISTRO ====================

        protected void btnSiguiente_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text))
            {
                MostrarMensaje("El nombre es obligatorio.", "error");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtApellido.Text))
            {
                MostrarMensaje("El apellido es obligatorio.", "error");
                return;
            }

            ViewState["PrimerNombre"] = txtNombre.Text.Trim();
            ViewState["PrimerApellido"] = txtApellido.Text.Trim();
            ViewState["Cedula"] = txtCedula.Text.Trim();
            ViewState["Telefono"] = txtTelefono.Text.Trim();

            pnlPaso1.CssClass = "panel";
            pnlPaso2.CssClass = "panel active";
        }

        protected void btnAtras_Click(object sender, EventArgs e)
        {
            pnlPaso1.CssClass = "panel active";
            pnlPaso2.CssClass = "panel";
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            if (!chkTerminos.Checked)
            {
                MostrarMensaje("Debes aceptar los términos y condiciones.", "error");
                return;
            }

            RegisterAsyncTask(new PageAsyncTask(RegistrarUsuarioAsync));
        }

        private async Task RegistrarUsuarioAsync()
        {
            _resultado = await objRegistrar.RegistrarAsync(
                txtEmail.Text.Trim(),
                txtPassword.Text,
                txtConfirmar.Text,
                ViewState["PrimerNombre"]?.ToString(),
                ViewState["PrimerApellido"]?.ToString(),
                ViewState["Cedula"]?.ToString(),
                ViewState["Telefono"]?.ToString()
            );

            if (_resultado.Exitoso)
            {
                SessionRegistrarHelper.GuardarRegistroTemporal(
                    _resultado.CuentaID,
                    _resultado.Email
                );
            }
        }

        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);

            if (_resultado == null) return;

            MostrarMensaje(_resultado.Mensaje, _resultado.Exitoso ? "success" : "error");

            if (_resultado.Exitoso)
            {
                string script = "setTimeout(function(){ window.location.href = '/verificar'; }, 3000);";
                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
        }

        // ==================== LOGIN (implementar después) ====================

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // TODO: Implementar login
            MostrarMensaje("Login en desarrollo.", "info");
        }

        // ==================== GOOGLE ====================

        protected void btnGoogle_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/src/handlers/GoogleAuth.ashx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}