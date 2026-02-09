using capa_dto;
using capa_negocio;
using capa_negocio.capa_negocio;
using System;
using System.Runtime.Remoting.Contexts;
using System.Threading.Tasks;
using System.Web.UI;
using static Google.Apis.Requests.BatchRequest;

namespace colitas_felices.src
{
    public partial class login_registro : NotifyLogic
    {
        private notifyVarDTO _resultado;
        private CN_Registro objRegistro = new CN_Registro();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Validar si ya está logueado y redirigir según rol
            Navigation.RedirigirSiYaLogueado();

            if (!IsPostBack)
            {
                string vista = Request.QueryString["v"];
                //Se analiza que campo esta en el hidden field para cargar la pagina
                hdnVistaActual.Value = (vista == "registro") ? "registro" : "login";
            }
        }

        // ==================== REGISTRO ====================

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            //se coloca para que se mantenga en el registro
            hdnVistaActual.Value = "registro";

            if (!chkTerminos.Checked)
            {
                MostrarMensaje("Debes aceptar los términos y condiciones.", "error");
                return;
            }

            RegisterAsyncTask(new PageAsyncTask(IniciarRegistroAsync));
        }

        private async Task IniciarRegistroAsync()
        {
            var request = new RegistroRequestDTO
            {
                Email = txtEmail.Text.Trim(),
                Password = txtPassword.Text,
                ConfirmarPassword = txtConfirmar.Text,
                PrimerNombre = txtPrimerNombre.Text.Trim(),
                SegundoNombre = string.IsNullOrWhiteSpace(txtSegundoNombre.Text)
                   ? null
                   : txtSegundoNombre.Text.Trim(),
                PrimerApellido = txtPrimerApellido.Text.Trim(),
                SegundoApellido = string.IsNullOrWhiteSpace(txtSegundoApellido.Text)
                   ? null
                   : txtSegundoApellido.Text.Trim(),
                Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text)
                   ? null
                   : txtTelefono.Text.Trim()
            };

            _resultado = await objRegistro.IniciarRegistro(request);

            if (_resultado.resultado)
            {
                // Guardar RegistroID en sesión
                Sessions.GuardarRegistroTemporal(txtEmail.Text);
            }
            else if (_resultado.codigo == 1)
            {
                notifyVarDTO datos = (notifyVarDTO)_resultado.datos;
                // Ya existe registro pendiente
                Sessions.GuardarRegistroTemporal(txtEmail.Text);
            }
        }

        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);

            if (_resultado == null) return;

            MostrarMensaje(_resultado.mensajeSalida, _resultado.resultado ? "success" : "error");

            if (_resultado.resultado)
            {
                // Redirigir a verificación usando Navigation
                string script = "setTimeout(function(){ window.location.href = '" +
                    ResolveUrl(Navigation.RUTA_VERIFICAR) + "'; }, 2000);";
                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
            else if (_resultado.codigo == 1)
            {
                // Si ya hay registro pendiente, también redirigir a verificación
                string script = "setTimeout(function(){ window.location.href = '" +
                    ResolveUrl(Navigation.RUTA_VERIFICAR) + "'; }, 2000);";
                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
        }

        // ==================== LOGIN ====================

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // TODO: Implementar login con CN_Login
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