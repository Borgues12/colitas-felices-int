using System;
using System.Threading.Tasks;
using System.Web.UI;
using capa_negocio;
using capa_dto;

namespace colitas_felices.src.webform.login
{
    public partial class verificarCodigo : notificaciones
    {
        private notifyDTO _resultado;
        private CN_Verificacion objVerificacion = new CN_Verificacion();
        private string _accion;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar que venga del registro
                var datos = SessionRegistrarHelper.ObtenerRegistroTemporal();

                if (datos.CuentaID <= 0 || string.IsNullOrEmpty(datos.Email))
                {
                    Response.Redirect("~/registrarse", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                lblEmail.Text = datos.Email;
            }
        }

        // ========== VERIFICAR CÓDIGO ==========
        protected void btnVerificar_Click(object sender, EventArgs e)
        {
            var datos = SessionRegistrarHelper.ObtenerRegistroTemporal();

            _resultado = objVerificacion.Verificar(datos.CuentaID, txtCodigo.Text);

            if (_resultado.resultado)
            {
                SessionRegistrarHelper.LimpiarRegistroTemporal();
            }

            _accion = "verificar";
        }

        // ========== REENVIAR CÓDIGO ==========
        protected void btnReenviar_Click(object sender, EventArgs e)
        {
            _accion = "reenviar";
            RegisterAsyncTask(new PageAsyncTask(ReenviarCodigoAsync));
        }

        private async Task ReenviarCodigoAsync()
        {
            var datos = SessionRegistrarHelper.ObtenerRegistroTemporal();
            _resultado = await objVerificacion.ReenviarCodigoAsync(datos.CuentaID);
        }

        // ========== CAMBIAR EMAIL ==========
        protected void btnConfirmarCambio_Click(object sender, EventArgs e)
        {
            _accion = "cambiar";
            RegisterAsyncTask(new PageAsyncTask(CambiarEmailAsync));
        }

        private async Task CambiarEmailAsync()
        {
            var datos = SessionRegistrarHelper.ObtenerRegistroTemporal();
            _resultado = await objVerificacion.CambiarEmailAsync(datos.CuentaID, txtNuevoEmail.Text.Trim());

            if (_resultado.resultado)
            {
                SessionRegistrarHelper.ActualizarEmail(txtNuevoEmail.Text.Trim().ToLower());
            }
        }

        protected void btnCancelarCambio_Click(object sender, EventArgs e)
        {
            pnlCambiarEmail.Visible = false;
            txtNuevoEmail.Text = "";
        }

        // ========== MOSTRAR RESULTADO ==========
        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);

            if (_resultado == null) return;

            MostrarMensaje(_resultado.mensajeSalida, _resultado.resultado ? "success" : "error");

            if (_resultado.resultado)
            {
                switch (_accion)
                {
                    case "verificar":
                        // Redirigir al login después de 2 segundos
                        string script = "setTimeout(function(){ window.location.href = 'registrar.aspx'; }, 2000);";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect", script, true);
                        break;

                    case "cambiar":
                        // Actualizar label y ocultar panel
                        var datos = SessionRegistrarHelper.ObtenerRegistroTemporal();
                        lblEmail.Text = datos.Email;
                        pnlCambiarEmail.Visible = false;
                        txtNuevoEmail.Text = "";

                        // Mostrar opciones de nuevo
                        string showOptions = "document.getElementById('divOpciones').style.display = 'block';";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "showOptions", showOptions, true);
                        break;
                }
            }
        }
    }
}