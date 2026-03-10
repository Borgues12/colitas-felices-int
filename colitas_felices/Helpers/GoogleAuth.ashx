<%@ WebHandler Language="C#" Class="GoogleAuth" %>

using System;
using System.Web;
using System.Web.Configuration;
using System.Threading.Tasks;
using capa_negocio.Seguridad;
using capa_dto;
using capa_DTO.DTO.Seguridad;
using colitas_felices;
using System.Web.SessionState;

public class GoogleAuth : HttpTaskAsyncHandler, IRequiresSessionState
{
    private static readonly string ClientId =
        WebConfigurationManager.AppSettings["Google:ClientId"];
    private static readonly string ClientSecret =
        WebConfigurationManager.AppSettings["Google:ClientSecret"];
    private static readonly string RedirectUri =
        WebConfigurationManager.AppSettings["Google:RedirectUri"];

    public override async Task ProcessRequestAsync(HttpContext context)
    {
        string code = context.Request.QueryString["code"];
        string error = context.Request.QueryString["error"];

        // Usuario negó el permiso
        if (!string.IsNullOrEmpty(error))
        {
            context.Response.Redirect("~/src/login-registro?v=login&error=google_cancelado");
            return;
        }

        // Primera visita: redirigir a Google
        if (string.IsNullOrEmpty(code))
        {
            string url = "https://accounts.google.com/o/oauth2/v2/auth" +
                $"?client_id={ClientId}" +
                $"&redirect_uri={Uri.EscapeDataString(RedirectUri)}" +
                "&response_type=code" +
                "&scope=openid%20email%20profile" +
                "&access_type=offline";

            context.Response.Redirect(url);
            return;
        }

        // Segunda visita: Google regresó con código
        try
        {
            var cn = new CN_LoginGoogle();
            var resultado = await cn.LoginORegistrar(code, ClientId, ClientSecret, RedirectUri);

            if (!resultado.resultado)
            {
                context.Response.Redirect($"~/src/login-registro?v=login&error={Uri.EscapeDataString(resultado.mensajeSalida)}");
                return;
            }

            // Crear sesión igual que el login normal
            var datos = resultado.datos as LoginDTO;
            Sessions.IniciarSesion(context, datos.CuentaID, datos.RolID);

            // Redirigir según rol
            if (Sessions.EsAdmin)
                context.Response.Redirect("~/Admin");
            else
                context.Response.Redirect("~/Home");
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine("Error GoogleAuth: " + ex.Message);
            context.Response.Redirect("~/src/login-registro?v=login&error=google_error");
        }
    }
}