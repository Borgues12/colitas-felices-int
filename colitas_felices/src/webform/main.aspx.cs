using capa_dto;
using capa_negocio;
using System;
using Microsoft.Owin.Security;
using System.Web;
using System.Web.UI;

namespace colitas_felices
{
    public partial class main : notificaciones
    {
        private CN_Login obj = new CN_Login();

        protected void btnGoogle_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== Iniciando autenticación con Google ===");
                //Obtiene el gestor de autentificacion de OWIN
                var auth = HttpContext.Current.GetOwinContext().Authentication;

                // Limpiar autenticaciones previas
                auth.SignOut("ExternalCookie");
                auth.SignOut("ApplicationCookie");

                var properties = new AuthenticationProperties
                {
                    // ✅ RUTA CORRECTA CON /src/
                    RedirectUri = "/src/GoogleCallback.aspx",
                    IsPersistent = false
                };

                System.Diagnostics.Debug.WriteLine($"RedirectUri configurado: {properties.RedirectUri}");

                // Iniciar el Challenge
                auth.Challenge(properties, "Google");

                HttpContext.Current.Response.StatusCode = 401;
                HttpContext.Current.Response.End();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error en btnGoogle_Click: {ex.ToString()}");
                MostrarMensaje("Error al iniciar sesión con Google", "error");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (EstaLogueado)
            {
                // Redirigir al panel correspondiente, no a main.aspx
                Response.Redirect(ObtenerRutaPorRol(), false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        protected void login_button(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txt_email.Text))
            {
                MostrarMensaje("Ingrese su email", "error");
                return;
            }
            if (string.IsNullOrEmpty(txt_password.Text))
            {
                MostrarMensaje("Ingrese su contraseña", "error");
                return;
            }

            // Llamar a capa de negocio
            CuentaDTO resultado = obj.ValidarUsuario(
                txt_email.Text.Trim(),
                txt_password.Text.Trim()
            );

            // Si login exitoso
            if (resultado.LoginExitoso)
            {
                // Iniciar sesión
                IniciarSesion(resultado.CuentaID, resultado.Rol);

                // Obtener ruta según rol
                string rutaDestino = ObtenerRutaPorRol();

                // Mensaje de éxito y redirección
                string script = $@"notyf.success('Bienvenido {txt_email.Text.Trim()}!');
                          setTimeout(function(){{ window.location.href = '{rutaDestino}'; }}, 1500);";
                ScriptManager.RegisterStartupScript(this, GetType(), "redirect", script, true);
            }
            else
            {
                // Mostrar mensaje de error del SP
                MostrarMensaje(resultado.Mensaje, "error");
            }
        }
    }
}