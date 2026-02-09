using System;
using System.Threading.Tasks;
using System.Web.UI;
using capa_negocio;
using capa_negocio.capa_negocio;
using capa_dto;

namespace colitas_felices.src.webform.login
{
    public partial class verificarCodigo : NotifyLogic
    {
        private notifyVarDTO _resultadoVerificar;
        private notifyDTO _resultadoReenviar;
        private CN_Registro objRegistro = new CN_Registro();
        private string _accion;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificar que exista un registro temporal en sesión
                if (!Sessions.TieneRegistroPendiente)
                {
                    Navigation.IrARegistro();
                    return;
                }
                var registro = new CN_Registro().CN_ObtenerRegistroTemporal(Sessions.RegistroCorreo);
                if (registro != null)
                {
                    lblEmail.Text = EnmascararEmail(registro);
                }
                // Mostrar el RegistroID (opcional, solo para debug o referencia)
                // lblRegistroID.Text = Sessions.RegistroID.ToString();
            }
        }

        private string EnmascararEmail(string email)
        {
            if (string.IsNullOrEmpty(email) || !email.Contains("@"))
                return email;

            var partes = email.Split('@');
            string usuario = partes[0];
            string dominio = partes[1];

            if (usuario.Length <= 2)
                return email;

            string usuarioEnmascarado = usuario[0] +
                new string('*', Math.Min(usuario.Length - 2, 5)) +
                usuario[usuario.Length - 1];

            return usuarioEnmascarado + "@" + dominio;
        }

        // ========== CAMBIAR EMAIL ==========
        protected void btnCancelarCambio_Click(object sender, EventArgs e)
        {
            pnlCambiarEmail.Style["display"] = "none";
            txtNuevoEmail.Text = string.Empty;
        }

        protected void btnConfirmarCambio_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNuevoEmail.Text))
            {
                MostrarMensaje("Ingresa el nuevo correo electrónico", "error");
                return;
            }

            _accion = "cambiar";
            RegisterAsyncTask(new PageAsyncTask(CambiarEmailAsync));
        }

        private async Task CambiarEmailAsync()
        {
            string registroCorreo = Sessions.RegistroCorreo;
            string nuevoEmail = txtNuevoEmail.Text.Trim();

            // TODO: Implementar en CN_Registro.CambiarEmailRegistro()
            // _resultadoCambio = await objRegistro.CambiarEmailRegistro(registroId, nuevoEmail);

            // Por ahora, mostrar mensaje de no implementado
            MostrarMensaje("Función en desarrollo", "warning");
        }

        // ========== VERIFICAR CÓDIGO ==========
        protected void btnVerificar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtCodigo.Text))
            {
                MostrarMensaje("Ingresa el código de verificación", "error");
                return;
            }

            _accion = "verificar";
            RegisterAsyncTask(new PageAsyncTask(VerificarCodigoAsync));
        }

        private async Task VerificarCodigoAsync()
        {
            string registroCorreo = Sessions.RegistroCorreo;
            string codigo = txtCodigo.Text.Trim();

            _resultadoVerificar = await objRegistro.VerificarCodigo(registroCorreo, codigo);

            if (_resultadoVerificar.resultado)
            {
                // El código contiene el CuentaID recién creado
                int cuentaId = _resultadoVerificar.codigo;

                // Limpiar sesión temporal
                Sessions.LimpiarRegistroTemporal();

                // OPCIONAL: Iniciar sesión automáticamente
                // Sessions.IniciarSesion(cuentaId, Sessions.ROL_USUARIO);
            }
        }

        // ========== REENVIAR CÓDIGO ==========
        protected void btnReenviar_Click(object sender, EventArgs e)
        {
            _accion = "reenviar";

            RegisterAsyncTask(new PageAsyncTask(ReenviarCodigoAsync));
        }

        private async Task ReenviarCodigoAsync()
        {
            _resultadoReenviar = await objRegistro.ReenviarCodigo(Sessions.RegistroCorreo);
        }

        // ========== CANCELAR Y VOLVER A REGISTRO ==========
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Limpiar datos temporales y redirigir
            Sessions.LimpiarRegistroTemporal();
            Navigation.IrARegistro();
        }

        // ========== MOSTRAR RESULTADO ==========
        protected override void OnPreRenderComplete(EventArgs e)
        {
            base.OnPreRenderComplete(e);

            // Manejar resultado de verificación
            if (_resultadoVerificar != null)
            {
                MostrarMensaje(
                    _resultadoVerificar.mensajeSalida,
                    _resultadoVerificar.resultado ? "success" : "error"
                );

                if (_resultadoVerificar.resultado && _accion == "verificar")
                {
                    // Redirigir al login después de verificación exitosa
                    string script = "setTimeout(function(){ window.location.href = '" +
                        ResolveUrl(Navigation.RUTA_LOGIN_REGISTRO) + "'; }, 2000);";
                    ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
                }
            }

            // Manejar resultado de reenvío
            if (_resultadoReenviar != null)
            {
                MostrarMensaje(
                    _resultadoReenviar.mensajeSalida,
                    _resultadoReenviar.resultado ? "success" : "info"
                );

                if (_resultadoReenviar.resultado)
                {
                    // Limpiar campo de código para que ingrese el nuevo
                    txtCodigo.Text = string.Empty;
                    // Usar JavaScript para limpiar los inputs visuales y hacer focus
                    string script = @"
                        document.querySelectorAll('.code-digit').forEach(input => input.value = '');
                        document.querySelector('.code-digit').focus();
                    ";
                    ClientScript.RegisterStartupScript(this.GetType(), "clearCode", script, true);
                }
            }
        }
    }
}