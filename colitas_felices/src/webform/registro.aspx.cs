using capa_dto;
using capa_negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform
{
    public partial class registro : notificaciones
    {
        private CN_Perfil objPerfil = new CN_Perfil();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificar que el usuario esté logueado
            if (Session["CuentaID"] == null)
            {
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                // Mostrar datos de Google
                if (Session["EmailGoogle"] != null)
                    lblEmail.Text = Session["EmailGoogle"].ToString();

            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones
                if (string.IsNullOrWhiteSpace(txtCedula.Text) || txtCedula.Text.Length != 10)
                {
                    MostrarError("La cédula debe tener 10 dígitos");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtNombres.Text))
                {
                    MostrarError("Los nombres son obligatorios");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtApellidos.Text))
                {
                    MostrarError("Los apellidos son obligatorios");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtTelefono.Text) || txtTelefono.Text.Length != 10)
                {
                    MostrarError("El teléfono debe tener 10 dígitos");
                    return;
                }

                int cuentaID = Convert.ToInt32(Session["CuentaID"]);

                notifyDTO resultado = objPerfil.ActualizarPerfil(
                    cuentaID,
                    txtCedula.Text.Trim(),
                    txtNombres.Text.Trim(),
                    txtApellidos.Text.Trim(),
                    txtTelefono.Text.Trim(),
                    txtDireccion.Text.Trim(),
                    null
                );

                if (resultado.resultado)
                {
                    LimpiarSesionGoogle();
                    RedirigirPorRol();
                }
                else
                {
                    MostrarError(resultado.mensajeSalida);
                }
            }
            catch (Exception ex)
            {
                MostrarError("Error: " + ex.Message);
            }
        }

        protected void btnOmitir_Click(object sender, EventArgs e)
        {
            LimpiarSesionGoogle();
            RedirigirPorRol();
        }

        private void MostrarError(string mensaje)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
        }

        private void LimpiarSesionGoogle()
        {
            Session.Remove("CompletarPerfil");
            Session.Remove("NombreGoogle");
            Session.Remove("EmailGoogle");
        }

        private void RedirigirPorRol()
        {
            byte rol = Convert.ToByte(Session["Rol"]);
            string url;

            switch (rol)
            {
                case 1:
                    url = "~/src/webform/admin/ad_main.aspx";
                    break;
                case 2:
                    url = "~/src/webform/padrino/pa_main.aspx";
                    break;
                default:
                    url = "~/src/webform/main.aspx";
                    break;
            }

            Response.Redirect(url, false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}