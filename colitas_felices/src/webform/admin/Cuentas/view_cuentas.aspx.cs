using capa_dto;
using capa_dto.DTO.Crud;
using capa_negocio.Crud;
using System;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.admin.Cuentas
{
    public partial class view_cuentas : System.Web.UI.Page
    {
        private CN_CuentaAdmin negocio = new CN_CuentaAdmin();
        private NotifyLogic n = new NotifyLogic();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarUsuarios();
            }
        }

        // ===== CARGAR LISTADO =====
        private void CargarUsuarios()
        {
            var filtro = new CuentaFiltroDTO
            {
                Busqueda = txtBusqueda.Text.Trim(),
                RolID = string.IsNullOrEmpty(ddlRol.SelectedValue)
                    ? (byte?)null
                    : byte.Parse(ddlRol.SelectedValue),
                Estado = string.IsNullOrEmpty(ddlEstado.SelectedValue)
                    ? null
                    : ddlEstado.SelectedValue
            };

            var lista = negocio.Listar(filtro);

            rptCuentas.DataSource = lista;
            rptCuentas.DataBind();

            rptCuentas.Visible = lista.Count > 0;
            pnlSinResultados.Visible = lista.Count == 0;
        }

        // ===== BUSCAR =====
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarUsuarios();
        }

        // ===== LIMPIAR FILTROS =====
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtBusqueda.Text = "";
            ddlRol.SelectedIndex = 0;
            ddlEstado.SelectedIndex = 0;
            CargarUsuarios();
        }

        // ===== CAMBIAR ROL =====
        protected void rptCuentas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CambiarRol")
            {
                int cuentaId = int.Parse(e.CommandArgument.ToString());
                int cuentaLogueada = ObtenerCuentaLogueada();

                notifyDTO resultado = negocio.CambiarRol(cuentaId, cuentaLogueada);

                string tipo = resultado.resultado ? "success" : "error";
                n.MostrarMensaje(resultado.mensajeSalida, tipo);

                CargarUsuarios();
            }
        }

        // ===== HELPERS =====
        private int ObtenerCuentaLogueada()
        {
            // TODO: adaptar según cómo guardas la sesión en tu login
            if (Session["CuentaID"] != null)
                return (int)Session["CuentaID"];
            return 0;
        }

        protected string GetEstadoCssClass(string estado)
        {
            switch ((estado ?? "").ToLower())
            {
                case "activo": return "estado-badge--activo";
                case "bloqueado": return "estado-badge--bloqueado";
                case "inactivo": return "estado-badge--inactivo";
                default: return "estado-badge--inactivo";
            }
        }
    }
}