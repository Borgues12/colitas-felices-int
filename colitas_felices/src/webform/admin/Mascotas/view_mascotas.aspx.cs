using capa_DTO.DTO.Crud;
using capa_negocio.Mascotas;
using capa_negocio.Crud;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.admin.Mascotas
{
    public partial class view_mascotas : System.Web.UI.Page
    {
        private readonly CN_Mascotas _cnMascota = new CN_Mascotas();
        private readonly CN_Catalogo _cnCatalogo = new CN_Catalogo();

        // Página actual guardada en ViewState
        private int PaginaActual
        {
            get { return ViewState["Pagina"] != null ? (int)ViewState["Pagina"] : 1; }
            set { ViewState["Pagina"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            PassarEstadosAJS();

            if (!IsPostBack)
            {
                CargarFiltros();
                CargarGrilla();
            }
        }

        #region carga de datos
        // ---- Carga inicial ----

        private void CargarFiltros()
        {
            // Especies
            var especies = _cnCatalogo.ObtenerEspecies();
            ddlEspecie.Items.Clear();
            ddlEspecie.Items.Add(new System.Web.UI.WebControls.ListItem("Todas las especies", ""));
            foreach (var e in especies)
                ddlEspecie.Items.Add(new System.Web.UI.WebControls.ListItem(e.Nombre, e.EspecieID.ToString()));

            // Estados
            var estados = _cnCatalogo.ObtenerEstadosMascota();
            ddlEstado.Items.Clear();
            ddlEstado.Items.Add(new System.Web.UI.WebControls.ListItem("Todos los estados", ""));
            foreach (var e in estados)
                ddlEstado.Items.Add(new System.Web.UI.WebControls.ListItem(e.Nombre, e.EstadoMascotaID.ToString()));
        }

        private void CargarGrilla()
        {
            var filtro = ObtenerFiltroActual();
            var lista = _cnMascota.Listar(filtro);

            gvMascotas.DataSource = lista;
            gvMascotas.DataBind();

            // Paginación
            lblPagina.Text = "Página " + PaginaActual;
            btnAnterior.Enabled = PaginaActual > 1;
            btnSiguiente.Enabled = lista.Count == filtro.RegistrosPorPagina;
        }

        private void PassarEstadosAJS()
        {
            var estados = _cnCatalogo.ObtenerEstadosMascota();

            // Usar JSON.NET si lo tienes, o construir manualmente con escape
            var sb = new System.Text.StringBuilder();
            sb.Append("[");
            for (int i = 0; i < estados.Count; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append("{");
                sb.Append("\"id\":" + estados[i].EstadoMascotaID + ",");
                // EscapeString evita problemas con tildes y caracteres especiales
                sb.Append("\"nombre\":\"" + estados[i].Nombre
                    .Replace("\\", "\\\\")
                    .Replace("\"", "\\\"") + "\"");
                sb.Append("}");
            }
            sb.Append("]");

            // Agregar charset al script
            ClientScript.RegisterStartupScript(
                this.GetType(),
                "estados",
                "var ESTADOS = " + sb.ToString() + ";",
                true);
        }

        #endregion
        private DTO_MascotaFiltro ObtenerFiltroActual()
        {
            var filtro = new DTO_MascotaFiltro
            {
                Pagina = PaginaActual,
                RegistrosPorPagina = 20,
                NombreBusqueda = txtBusqueda.Text.Trim()
            };

            if (byte.TryParse(ddlEspecie.SelectedValue, out byte especie))
                filtro.EspecieID = especie;

            if (byte.TryParse(ddlEstado.SelectedValue, out byte estado))
                filtro.EstadoMascotaID = estado;

            return filtro;
        }

        // ---- Eventos de filtros ----

        protected void ddlEspecie_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarGrilla();
        }

        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarGrilla();
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            PaginaActual = 1;
            CargarGrilla();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBusqueda.Text = "";
            ddlEspecie.SelectedIndex = 0;
            ddlEstado.SelectedIndex = 0;
            PaginaActual = 1;
            CargarGrilla();
        }

        // ---- Paginación ----

        protected void btnAnterior_Click(object sender, EventArgs e)
        {
            if (PaginaActual > 1)
            {
                PaginaActual--;
                CargarGrilla();
            }
        }

        protected void btnSiguiente_Click(object sender, EventArgs e)
        {
            PaginaActual++;
            CargarGrilla();
        }

        // ---- Acciones de la grilla ----

        protected void gvMascotas_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
                Response.Redirect("~/MascotasAdmin/Form?id=" + id);
        }

        protected void btnNueva_Click(object sender, EventArgs e)
        {
            Response.Redirect("MascotasAdmin/Form");
        }

        // ---- Mensajes ----

        private void MostrarMensaje(string texto, bool esError = false)
        {
            lblMensaje.Text = texto;
            lblMensaje.ForeColor = esError
                ? System.Drawing.Color.Red
                : System.Drawing.Color.Green;
            lblMensaje.Visible = true;
        }
    }
}