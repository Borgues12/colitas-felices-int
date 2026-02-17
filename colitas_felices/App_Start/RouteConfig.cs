using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace colitas_felices
{
    public static class RouteConfig
    {
        // Método que registra todas las rutas de la aplicación
        public static void RegisterRoutes(RouteCollection routes)
        {
            //no bsucar archivos fisicos
            routes.RouteExistingFiles = false;

            routes.MapPageRoute("Default", "", "~/src/webform/frontend/start.aspx");
            routes.MapPageRoute("Principal", "principal", "~/src/webform/frontend/start.aspx");
            routes.MapPageRoute("Login", "iniciar_sesion", "~/src/webform/login/login_registro.aspx");
            routes.MapPageRoute("VerificarCodigo", "verificar", "~/src/webform/login/verificarCodigo.aspx");
            routes.MapPageRoute("Blob", "blob", "~/src/PruebaBlob.aspx");
        }
    }
}
