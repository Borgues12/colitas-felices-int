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
            //LOGIN Y REGISTRO
            routes.MapPageRoute("Login", "iniciar_sesion", "~/src/webform/login/login_registro.aspx");
            routes.MapPageRoute("VerificarCodigo", "verificar", "~/src/webform/login/verificarCodigo.aspx");
            routes.MapPageRoute("Recuperar", "recuperar", "~/src/webform/login/recuperarPassword.aspx");


            //LANDING PAGES
            routes.MapPageRoute("Panel_usuario", "Home", "~/src/webform/usuario/user_main.aspx");
            routes.MapPageRoute("Panel_admin", "Admin", "~/src/webform/admin/ad_main.aspx");
            routes.MapPageRoute("Voluntariado", "Voluntariado", "~/src/webform/frontend/voluntariado.aspx");
            routes.MapPageRoute("Nosotros", "Nosotros", "~/src/webform/frontend/nosotros.aspx");
            routes.MapPageRoute("Adopta", "Adopta", "~/src/webform/frontend/fr_adopta.aspx");

            //ADMIN PAGES
            routes.MapPageRoute("MascotasAdmin", "MascotasAdmin", "~/src/webform/admin/Mascotas/view_mascotas.aspx");
            routes.MapPageRoute("CrearEditMascotas", "MascotasAdmin/Form", "~/src/webform/admin/Mascotas/mascotasForm.aspx");

        }
    }
}
