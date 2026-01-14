using capa_dto;
using capa_negocio;
using Microsoft.Owin.Security;
using System;
using System.Linq;
using System.Web;

namespace colitas_felices
{
    public partial class GoogleCallback : notificaciones
    {
        private CN_Login obj = new CN_Login();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine("=== GoogleCallback.aspx Page_Load ===");

                // Verificar error de OAuth
                if (Request.QueryString["error"] != null)
                {
                    string error = Request.QueryString["error"];
                    if (error == "access_denied")
                    {
                        MostrarMensaje("Cancelaste el inicio de sesión con Google", "info");
                    }
                    else
                    {
                        MostrarMensaje($"Error de autenticación: {error}", "error");
                    }
                    Response.Redirect("~/src/webform/main.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Obtener contexto de autenticación
                var auth = HttpContext.Current.GetOwinContext().Authentication;
                var result = auth.AuthenticateAsync("ExternalCookie").Result;

                // Validar autenticación
                if (result == null || result.Identity == null || !result.Identity.IsAuthenticated)
                {
                    MostrarMensaje("No se pudo completar la autenticación con Google.", "error");
                    Response.Redirect("~/src/webform/main.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Extraer datos de Google
                string email = result.Identity.Claims
                    .FirstOrDefault(c => c.Type.Contains("email"))?.Value;

                string nombre = result.Identity.Claims
                    .FirstOrDefault(c => c.Type.Contains("name"))?.Value
                    ?? result.Identity.Name;

                string googleUserId = result.Identity.Claims
                    .FirstOrDefault(c => c.Type.Contains("nameidentifier"))?.Value
                    ?? result.Identity.Claims.FirstOrDefault(c => c.Type == "urn:google:id")?.Value;

                System.Diagnostics.Debug.WriteLine($"Email: {email}");
                System.Diagnostics.Debug.WriteLine($"Nombre: {nombre}");
                System.Diagnostics.Debug.WriteLine($"GoogleID: {googleUserId}");

                // Validar email
                if (string.IsNullOrEmpty(email))
                {
                    MostrarMensaje("No se pudo obtener tu email de Google", "error");
                    Response.Redirect("~/src/webform/main.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Fallbacks
                if (string.IsNullOrEmpty(nombre))
                    nombre = email.Split('@')[0];

                if (string.IsNullOrEmpty(googleUserId))
                    googleUserId = email;

                // Limpiar cookie externa
                auth.SignOut("ExternalCookie");

                // Llamar a la capa de negocio con el DTO correcto
                GoogleLoginDTO cuenta = obj.LoginGoogle(googleUserId, email, nombre);

                System.Diagnostics.Debug.WriteLine($"Exitoso: {cuenta.Exitoso}");
                System.Diagnostics.Debug.WriteLine($"EsNuevoUsuario: {cuenta.EsNuevoUsuario}");
                System.Diagnostics.Debug.WriteLine($"RequiereCompletarPerfil: {cuenta.RequiereCompletarPerfil}");
                System.Diagnostics.Debug.WriteLine($"Mensaje: {cuenta.Mensaje}");

                if (!cuenta.Exitoso)
                {
                    MostrarMensaje(cuenta.Mensaje, "error");
                    Response.Redirect("~/src/webform/main.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Crear sesión
                IniciarSesion(cuenta.CuentaID, cuenta.Rol);

                // Verificar si debe completar perfil
                if (cuenta.RequiereCompletarPerfil)
                {
                    // Guardar en sesión que viene de Google (para el formulario)
                    Session["CompletarPerfil"] = true;
                    Session["NombreGoogle"] = nombre;
                    Session["EmailGoogle"] = email;

                    MostrarMensaje("¡Bienvenido! Por favor completa tu perfil.", "info");
                    Response.Redirect("~/src/webform/registro.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Mensaje de bienvenida
                if (cuenta.EsNuevoUsuario)
                {
                    MostrarMensaje($"¡Bienvenido a Colitas Felices!", "success");
                }
                else
                {
                    MostrarMensaje("¡Bienvenido de nuevo!", "success");
                }

                // Redirigir según rol
                string redirectUrl = ObtenerRutaPorRol();
                System.Diagnostics.Debug.WriteLine($"Redirigiendo a: {redirectUrl}");

                Response.Redirect(redirectUrl, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ERROR: {ex.ToString()}");
                MostrarMensaje("Error al procesar la autenticación: " + ex.Message, "error");
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }
    }
}