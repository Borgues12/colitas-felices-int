using System;
using capa_dto.DTO;
using capa_dto;
using System.Threading.Tasks;
using System.Web.UI;
using capa_negocio;

namespace colitas_felices.src
{
    public partial class registrar : Page
    {
        // Variables para resultado async
        private notifyDTO _resultado;
        private string _emailRegistrado;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Si ya está logueado, redirigir
            if (Session["CuentaID"] != null)
            {
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            // Validación de términos (en frontend)
            if (!chkTerminos.Checked)
            {
                MostrarMensaje(false, "Debes aceptar los términos y condiciones");
                return;
            }

            // Guardar email para mostrar después
            _emailRegistrado = txtEmail.Text.Trim();

            // Registrar tarea async
            RegisterAsyncTask(new PageAsyncTask(RegistrarUsuarioAsync));
        }

        private async Task RegistrarUsuarioAsync()
        {
            CN_Login objLogin = new CN_Login();

            // Llamar al método async de la capa de negocio
            // Aquí se valida TODO y se envía el email
            _resultado = await objLogin.RegistrarAsync(
                txtEmail.Text.Trim(),
                txtPassword.Text,
                txtConfirmar.Text,
                txtNombre.Text.Trim(),
                txtApellido.Text.Trim()
            );
        }

        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);

            // Mostrar resultado después de que termine el async
            if (_resultado != null)
            {
                if (_resultado.resultado)
                {
                    // Éxito - mostrar mensaje y ocultar formulario
                    MostrarExito(_emailRegistrado);
                }
                else
                {
                    // Error - mostrar mensaje, mantener formulario
                    MostrarMensaje(false, _resultado.mensajeSalida);
                }
            }
        }

        private void MostrarExito(string email)
        {
            pnlFormulario.Visible = false;
            pnlMensaje.Visible = true;

            litMensaje.Text = $@"
                <div class='mensaje mensaje-exito'>
                    <iconify-icon icon='mdi:check-circle'></iconify-icon>
                    <div>
                        <strong>¡Registro exitoso!</strong><br/>
                        Hemos enviado un código de verificación a:<br/>
                        <strong>{email}</strong>
                    </div>
                </div>
                <div style='text-align: center; margin-top: 25px;'>
                    <p style='color: #666; margin-bottom: 20px;'>
                        Revisa tu bandeja de entrada (y spam) para verificar tu cuenta.
                    </p>
                    <a href='verificar.aspx?email={Server.UrlEncode(email)}' 
                       style='display: inline-block; padding: 14px 30px; background: linear-gradient(135deg, #9C27B0, #7B1FA2); 
                              color: white; text-decoration: none; border-radius: 12px; font-weight: 600;
                              box-shadow: 0 8px 25px rgba(156,39,176,0.35);'>
                        <iconify-icon icon='mdi:email-check' style='vertical-align: middle; margin-right: 8px;'></iconify-icon>
                        Ingresar código
                    </a>
                </div>";
        }

        private void MostrarMensaje(bool exito, string mensaje)
        {
            pnlMensaje.Visible = true;

            string clase = exito ? "mensaje-exito" : "mensaje-error";
            string icono = exito ? "mdi:check-circle" : "mdi:alert-circle";

            litMensaje.Text = $@"
                <div class='mensaje {clase}'>
                    <iconify-icon icon='{icono}'></iconify-icon>
                    <span>{mensaje}</span>
                </div>";
        }

        protected void btnGoogle_Click(object sender, EventArgs e)
        {
            // TODO: Implementar OAuth de Google
            // Por ahora redirigir al handler de Google
            Response.Redirect("~/src/handlers/GoogleAuth.ashx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}