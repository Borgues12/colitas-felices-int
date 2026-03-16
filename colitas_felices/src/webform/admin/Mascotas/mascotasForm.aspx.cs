using capa_dto;
using capa_negocio.Mascotas;
using capa_negocio.Crud;
using capa_DTO.DTO.Crud;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.IO;
using System.Diagnostics;

namespace colitas_felices.src.webform.admin.Mascotas
{
    public partial class mascotasForm : NotifyLogic
    {
        private readonly CN_Mascotas _cn = new CN_Mascotas();
        private readonly CN_Catalogo _cnCatalogo = new CN_Catalogo();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarEspecies();
                CargarEstados();
                CargarCondiciones();
                CargarRazas(0); // Sin filtro — dropdown vacío hasta que elijan especie
            }
        }

        // ============================================================
        // CATÁLOGOS
        // ============================================================

        private void CargarEspecies()
        {
            var especies = _cnCatalogo.ObtenerEspecies();
            ddlEspecie.Items.Clear();
            ddlEspecie.Items.Add(new ListItem("Seleccione...", "0"));
            foreach (var e in especies)
                ddlEspecie.Items.Add(new ListItem(e.Nombre, e.EspecieID.ToString()));
        }

        private void CargarRazas(byte especieID)
        {
            ddlRaza.Items.Clear();

            if (especieID == 0)
            {
                ddlRaza.Items.Add(new ListItem("Seleccione especie primero", "0"));
                ddlRaza.Enabled = false;
                return;
            }

            var razas = _cnCatalogo.ObtenerRazasPorEspecie(especieID);
            ddlRaza.Items.Add(new ListItem("Seleccione...", "0"));
            foreach (var r in razas)
                ddlRaza.Items.Add(new ListItem(r.Nombre, r.RazaID.ToString()));

            ddlRaza.Enabled = true;
        }

        private void CargarEstados()
        {
            var estados = _cnCatalogo.ObtenerEstadosMascota();
            ddlEstado.Items.Clear();
            ddlEstado.Items.Add(new ListItem("Seleccione...", "0"));
            foreach (var e in estados)
                ddlEstado.Items.Add(new ListItem(e.Nombre, e.EstadoMascotaID.ToString()));
        }

        private void CargarCondiciones()
        {
            var condiciones = _cnCatalogo.ObtenerCondiciones();
            cblCondiciones.Items.Clear();
            foreach (var c in condiciones)
                cblCondiciones.Items.Add(new ListItem(c.Nombre, c.CondicionID.ToString()));
        }

        // ============================================================
        // EVENTO — cambio de especie recarga razas desde BD
        // ============================================================

        protected void ddlEspecie_SelectedIndexChanged(object sender, EventArgs e)
        {
            byte.TryParse(ddlEspecie.SelectedValue, out byte especieID);
            CargarRazas(especieID);
        }

        // ============================================================
        // GUARDAR
        // ============================================================

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
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

            dto.CondicionesSeleccionadas = new List<short>();
            foreach (ListItem item in cblCondiciones.Items)
                if (item.Selected && short.TryParse(item.Value, out short cid))
                    dto.CondicionesSeleccionadas.Add(cid);

            var fotos = new List<MascotasFotoStreamDto>();
            var archivos = fuFotos.PostedFiles; // múltiples archivos del mismo FileUpload


            // DEBUG TEMPORAL
            System.Diagnostics.Debug.WriteLine("=== PostedFiles.Count: " + archivos.Count);
            System.Diagnostics.Debug.WriteLine("=== Request.Files.Count: " + Request.Files.Count);

            for (int i = 0; i < Request.Files.Count; i++)
                System.Diagnostics.Debug.WriteLine("  File[" + i + "]: '" +
                    Request.Files[i].FileName + "' size: " + Request.Files[i].ContentLength);

            foreach (var archivo in archivos)
            {
                if (archivo != null && archivo.ContentLength > 0)
                    fotos.Add(new MascotasFotoStreamDto
                    {
                        Stream = archivo.InputStream,
                        ContentType = archivo.ContentType,
                        NombreArchivo = archivo.FileName
                    });
                if (fotos.Count == 5) break;
            }

            //DEBUG
            System.Diagnostics.Debug.WriteLine("=== GUARDAR MASCOTA ===");
            System.Diagnostics.Debug.WriteLine("Nombre: " + dto.Nombre);
            System.Diagnostics.Debug.WriteLine("EspecieID: " + dto.EspecieID);
            System.Diagnostics.Debug.WriteLine("RazaID: " + dto.RazaID);
            System.Diagnostics.Debug.WriteLine("Sexo: " + dto.Sexo);
            System.Diagnostics.Debug.WriteLine("Tamanio: " + dto.Tamanio);
            System.Diagnostics.Debug.WriteLine("Color: " + dto.Color);
            System.Diagnostics.Debug.WriteLine("EstadoID: " + dto.EstadoMascotaID);

            notifyVarDTO resultado = _cn.Insertar(dto, fotos);

            //DEBUG
            System.Diagnostics.Debug.WriteLine("Resultado: " + resultado.resultado);
            System.Diagnostics.Debug.WriteLine("Mensaje: " + resultado.mensajeSalida);

            MostrarResultado(resultado);
            if (resultado.resultado)
            {
                string url = ResolveUrl("~/MascotasAdmin");
                string script = $"setTimeout(function(){{ window.location.href='{url}'; }}, 4000);";

                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("MascotasAdmin");
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