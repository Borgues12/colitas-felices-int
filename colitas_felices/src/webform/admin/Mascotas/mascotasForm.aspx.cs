using capa_dto;
using capa_DTO.DTO.Crud;
using capa_negocio.Mascotas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.admin.Mascotas
{
    public partial class mascotasForm : NotifyLogic
    {
        private readonly CN_Mascotas _cn = new CN_Mascotas();
        private readonly CN_Catalogo _cnCatalogo = new CN_Catalogo();


        protected void Page_Load(object sender, EventArgs e)
        {
            GenerarRazasJson();

            if (!IsPostBack)
                CargarCatalogos();
        }

        // ============================================================
        // CARGA DE CATÁLOGOS
        // ============================================================

        private void CargarCatalogos()
        {
            // Especies
            var especies = _cnCatalogo.ObtenerEspecies();
            ddlEspecie.Items.Clear();
            ddlEspecie.Items.Add(new ListItem("Seleccione...", "0"));
            foreach (var e in especies)
                ddlEspecie.Items.Add(new ListItem(e.Nombre, e.EspecieID.ToString()));

            // Estados
            var estados = _cnCatalogo.ObtenerEstadosMascota();
            ddlEstado.Items.Clear();
            ddlEstado.Items.Add(new ListItem("Seleccione...", "0"));
            foreach (var e in estados)
                ddlEstado.Items.Add(new ListItem(e.Nombre, e.EstadoMascotaID.ToString()));

            // Condiciones
            var condiciones = _cnCatalogo.ObtenerCondiciones();
            cblCondiciones.Items.Clear();
            foreach (var c in condiciones)
                cblCondiciones.Items.Add(new ListItem(c.Nombre, c.CondicionID.ToString()));
        }

        private void GenerarRazasJson()
        {
            var razas = _cnCatalogo.ObtenerRazas();
            litRazasJson.Text = new JavaScriptSerializer().Serialize(razas);
        }

        // ============================================================
        // GUARDAR
        // ============================================================

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Armar DTO
            var dto = new MascotaDto
            {
                Nombre = txtNombre.Text.Trim(),
                Color = txtColor.Text.Trim(),
                Descripcion = txtDescripcion.Text.Trim(),
                NumeroMicrochip = txtMicrochip.Text.Trim(),
                EsAdoptable = chkAdoptable.Checked,
                Esterilizado = chkEsterilizado.Checked,
                RegistradoPor = ObtenerCuentaID()
            };

            if (byte.TryParse(ddlEspecie.SelectedValue, out byte especie) && especie != 0)
                dto.EspecieID = especie;

            if (short.TryParse(ddlRaza.SelectedValue, out short raza) && raza != 0)
                dto.RazaID = raza;

            if (byte.TryParse(ddlSexo.SelectedValue, out byte sexo) && sexo != 0)
                dto.Sexo = sexo;

            if (byte.TryParse(ddlTamanio.SelectedValue, out byte tamanio) && tamanio != 0)
                dto.Tamanio = tamanio;

            if (byte.TryParse(ddlEstado.SelectedValue, out byte estado) && estado != 0)
                dto.EstadoMascotaID = estado;

            if (DateTime.TryParse(txtFechaNacimiento.Text, out DateTime fechaNac))
                dto.FechaNacimientoAprox = fechaNac;

            if (dto.Esterilizado && DateTime.TryParse(txtFechaEsterilizacion.Text, out DateTime fechaEst))
                dto.FechaEsterilizacion = fechaEst;

            // Condiciones seleccionadas
            dto.CondicionesSeleccionadas = new List<short>();
            foreach (ListItem item in cblCondiciones.Items)
                if (item.Selected && short.TryParse(item.Value, out short cid))
                    dto.CondicionesSeleccionadas.Add(cid);

            // Fotos — extraer Stream desde cada FileUpload
            var fotos = new List<MascotasFotoStreamDto>();
            AgregarFoto(fotos, fuFoto1);
            AgregarFoto(fotos, fuFoto2);
            AgregarFoto(fotos, fuFoto3);
            AgregarFoto(fotos, fuFoto4);
            AgregarFoto(fotos, fuFoto5);

            // Llamar al negocio
            notifyVarDTO resultado = _cn.Insertar(dto, fotos);

            MostrarResultado(resultado);

            if (resultado.resultado)
                Response.Redirect("mascotas.aspx");
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("mascotas.aspx");
        }

        // ============================================================
        // HELPERS
        // ============================================================

        private void AgregarFoto(List<MascotasFotoStreamDto> lista, System.Web.UI.WebControls.FileUpload fu)
        {
            if (!fu.HasFile) return;

            lista.Add(new MascotasFotoStreamDto
            {
                Stream = fu.PostedFile.InputStream,
                ContentType = fu.PostedFile.ContentType,
                NombreArchivo = fu.PostedFile.FileName
            });
        }

        private int ObtenerCuentaID()
        {
            return Session["CuentaID"] != null ? (int)Session["CuentaID"] : 1;
        }
    }
}