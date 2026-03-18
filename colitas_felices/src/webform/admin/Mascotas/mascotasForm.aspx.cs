using capa_dto;
using capa_DTO.DTO.Crud;
using capa_negocio.Crud;
using capa_negocio.Mascotas;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.admin.Mascotas
{
    public partial class mascotasForm : NotifyLogic
    {
        private readonly CN_Mascotas _cn = new CN_Mascotas();
        private readonly CN_Catalogo _cnCatalogo = new CN_Catalogo();

        //Obtener el MascotaID
        private int MascotaID
        {
            get { return ViewState["MascotaID"] != null ? (int)ViewState["MascotaID"] : 0; }
            set { ViewState["MascotaID"] = value; }
        }
        private bool EsModoEditar => MascotaID > 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //Siempre se cargas los catalogos 
                CargarEspecies();
                CargarEstados();
                CargarCondiciones();

                if (int.TryParse(Request.QueryString["id"], out int id) && id > 0)
                {
                    MascotaID = id;
                    CargarMascota(id);
                    lblTitulo.Text = "Editar mascota";
                }
                else
                {
                    CargarRazas(0); // Sin filtro — dropdown vacío hasta que elijan especie
                    lblTitulo.Text = "Nueva mascota";
                }
            }
        }

       //METODO PARA CARGAR LOS DATOS SI VAN A EDITAR
        private void CargarMascota(int id)
        {
            var m = _cn.ObtenerPorId(id);
            if (m == null) { Response.Redirect("~/MascotasAdmin"); return; }

            // Datos básicos
            txtNombre.Text = m.Nombre;
            txtColor.Text = m.Color;
            txtMicrochip.Text = m.NumeroMicrochip;
            txtDescripcion.Text = m.Descripcion;

            // Especie → cargar razas → seleccionar raza
            ddlEspecie.SelectedValue = m.EspecieID.ToString();
            CargarRazas(m.EspecieID);
            ddlRaza.SelectedValue = m.RazaID.ToString();

            // Resto de dropdowns
            ddlSexo.SelectedValue = m.Sexo.ToString();
            ddlTamanio.SelectedValue = m.Tamanio.ToString();
            ddlEstado.SelectedValue = m.EstadoMascotaID.ToString();

            // Checkboxes
            chkAdoptable.Checked = m.EsAdoptable;
            chkEsterilizado.Checked = m.Esterilizado;

            // Fecha nacimiento
            if (m.FechaNacimientoAprox.HasValue)
            {
                txtFechaNacimiento.Text = m.FechaNacimientoAprox.Value.ToString("yyyy-MM-dd");
                hfTipoEdad.Value = "fecha";
            }

            // Fecha esterilización
            if (m.FechaEsterilizacion.HasValue)
                txtFechaEsterilizacion.Text = m.FechaEsterilizacion.Value.ToString("yyyy-MM-dd");

            // Condiciones — marca las que ya tiene
            if (m.Condiciones != null)
            {
                var idsActivos = new HashSet<string>(
                    m.Condiciones.Select(c => c.CondicionID.ToString())
                );
                foreach (ListItem item in cblCondiciones.Items)
                    item.Selected = idsActivos.Contains(item.Value);
            }
        }

        #region CATALOGOS
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

        #endregion


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

            dto.FechaNacimientoAprox = ObtenerFechaNacimiento();

            if (dto.Esterilizado && DateTime.TryParse(txtFechaEsterilizacion.Text, out DateTime fechaEst))
                dto.FechaEsterilizacion = fechaEst;

            dto.CondicionesSeleccionadas = new List<short>();
            foreach (ListItem item in cblCondiciones.Items)
                if (item.Selected && short.TryParse(item.Value, out short cid))
                    dto.CondicionesSeleccionadas.Add(cid);

            //DEBUG TEMPORAL
            System.Diagnostics.Debug.WriteLine("=== GUARDAR MASCOTA ===");
            System.Diagnostics.Debug.WriteLine("Nombre: " + dto.Nombre);
            System.Diagnostics.Debug.WriteLine("EspecieID: " + dto.EspecieID);
            System.Diagnostics.Debug.WriteLine("RazaID: " + dto.RazaID);
            System.Diagnostics.Debug.WriteLine("Sexo: " + dto.Sexo);
            System.Diagnostics.Debug.WriteLine("Tamanio: " + dto.Tamanio);
            System.Diagnostics.Debug.WriteLine("Color: " + dto.Color);
            System.Diagnostics.Debug.WriteLine("EstadoID: " + dto.EstadoMascotaID);

            //declarar variable y cambiar si es edicion o insertar
            notifyDTO resultado = EsModoEditar
               ? _cn.Actualizar(dto)
               : _cn.Insertar(dto);


            //DEBUG
            System.Diagnostics.Debug.WriteLine("Resultado: " + resultado.resultado);
            System.Diagnostics.Debug.WriteLine("Mensaje: " + resultado.mensajeSalida);

            MostrarMensaje(resultado.mensajeSalida, "success");
            if (resultado.resultado)
            {
                string url = ResolveUrl("~/MascotasAdmin");
                string script = $"setTimeout(function(){{ window.location.href='{url}'; }}, 2500);";

                ClientScript.RegisterStartupScript(this.GetType(), "redirect", script, true);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/MascotasAdmin");
        }

        // ============================================================
        // HELPERS
        // ============================================================

        //Sacar el ID de la Session
        private int ObtenerCuentaID()
        {
            return Session["CuentaID"] != null ? (int)Session["CuentaID"] : 1;
        }

        // El usuario puede ingresar una fecha exacta o una edad aproximada. Se valida y convierte a DateTime.
        private DateTime? ObtenerFechaNacimiento()
        {
            string tipo = hfTipoEdad.Value;

            if (tipo == "fecha")
            {
                if (DateTime.TryParse(txtFechaNacimiento.Text, out DateTime fechaExacta))
                    return fechaExacta;
            }
            else if (tipo == "aproximada")
            {
                if (int.TryParse(txtEdadAnios.Text, out int anios) && anios >= 0 && anios <= 30)
                    return DateTime.Today.AddYears(-anios);
            }

            return null; // Campo opcional — puede no saberse nada
        }
    }
}