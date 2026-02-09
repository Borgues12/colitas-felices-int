using System;
using capa_negocio;

namespace colitas_felices.src.webform.padrino
{
    public partial class pa_main : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Validar que el usuario esté logueado
            Navigation.RequiereLogin();

            if (!IsPostBack)
            {
                // Aquí puedes cargar datos iniciales si es necesario
                // Por ejemplo: CargarDatosPadrino();
            }
        }

        protected void Logout_Click(object sender, EventArgs e)
        {
            // Cerrar sesión y redirigir a login
            Navigation.CerrarSesionYRedirigir();
        }
    }
}