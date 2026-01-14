using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using capa_negocio;
using capa_dto;

namespace colitas_felices.src.webform.admin
{
    public partial class ad_perfiles : notificaciones
    {
        private CN_Perfil objPerfil = new CN_Perfil();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!EstaLogueado)
            {
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (RolUsuario != 1)
            {
                Response.Redirect(ObtenerRutaPorRol(), false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                CargarPerfiles("todos");
            }
        }

        // ============= CARGAR PERFILES ==============
        private void CargarPerfiles(string filtro, string busqueda = "")
        {
            var perfiles = objPerfil.ObtenerPerfiles();

            // Aplicar filtro
            switch (filtro)
            {
                case "completos":
                    perfiles = perfiles.Where(p => p.PerfilCompleto == 1).ToList();
                    break;

                case "incompletos":
                    perfiles = perfiles.Where(p => p.PerfilCompleto == 0).ToList();
                    break;
            }

            // Aplicar búsqueda
            if (!string.IsNullOrEmpty(busqueda))
            {
                busqueda = busqueda.ToLower();
                perfiles = perfiles.Where(p =>
                    (p.Nombres != null && p.Nombres.ToLower().Contains(busqueda)) ||
                    (p.Apellidos != null && p.Apellidos.ToLower().Contains(busqueda)) ||
                    (p.Email != null && p.Email.ToLower().Contains(busqueda)) ||
                    (p.Cedula != null && p.Cedula.Contains(busqueda)) ||
                    (p.Telefono != null && p.Telefono.Contains(busqueda))
                ).ToList();
            }

            gv_perfiles.DataSource = perfiles;
            gv_perfiles.DataBind();

            lbl_mostrando.Text = perfiles.Count.ToString();
            lbl_total.Text = objPerfil.ObtenerPerfiles().Count.ToString();

            hfFiltroActual.Value = filtro;
            ActualizarEstiloFiltros(filtro);
        }

        // ============= FILTROS ==============
        protected void btnFiltro_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string filtro = btn.CommandArgument;
            CargarPerfiles(filtro, txt_Buscar.Text.Trim());
        }

        private void ActualizarEstiloFiltros(string filtroActivo)
        {
            btnTodos.CssClass = "tab-filtro" + (filtroActivo == "todos" ? " activo" : "");
            btnCompletos.CssClass = "tab-filtro" + (filtroActivo == "completos" ? " activo" : "");
            btnIncompletos.CssClass = "tab-filtro" + (filtroActivo == "incompletos" ? " activo" : "");
        }

        // ============= BÚSQUEDA ==============
        protected void btn_BuscarOculto_Click(object sender, EventArgs e)
        {
            string busqueda = txt_Buscar.Text.Trim();
            btn_LimpiarBusqueda.Visible = !string.IsNullOrEmpty(busqueda);
            CargarPerfiles(hfFiltroActual.Value, busqueda);
        }

        protected void btn_LimpiarBusqueda_Click(object sender, EventArgs e)
        {
            txt_Buscar.Text = "";
            btn_LimpiarBusqueda.Visible = false;
            CargarPerfiles(hfFiltroActual.Value);
        }

        // ============= ACCIONES GRID ==============
        protected void AccionesGrid_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "Editar")
            {
                int perfilID = Convert.ToInt32(e.CommandArgument);
                // Asignar el valor al HiddenField
                hf_CuentaID_Editar.Value = perfilID.ToString();
                CargarDatosParaEditar(perfilID);
            }
        }

        // ============= CARGAR DATOS PARA EDITAR ==============
        private void CargarDatosParaEditar(int cuentaID)
        {
            try
            {
                var perfil = objPerfil.ObtenerPerfilPorID(cuentaID);

                if (perfil != null)
                {
                    hf_CuentaID_Editar.Value = cuentaID.ToString();
                    lbl_email.Text = perfil.Email;
                    txt_cedula.Text = perfil.Cedula;
                    txt_nombres.Text = perfil.Nombres;
                    txt_apellidos.Text = perfil.Apellidos;
                    txt_telefono.Text = perfil.Telefono;
                    txt_direccion.Text = perfil.Direccion;

                    // Mostrar foto si existe
                    if (perfil.FotoPerfil != null && perfil.FotoPerfil.Length > 0)
                    {
                        img_foto_actual.ImageUrl = "data:image/jpeg;base64," + Convert.ToBase64String(perfil.FotoPerfil);
                        img_foto_actual.Visible = true;
                    }
                    else
                    {
                        img_foto_actual.Visible = false;
                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                }
                else
                {
                    MostrarMensaje("Perfil no encontrado", "error");
                    return;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al cargar datos:{ex.Message}");
            }
        }

        // ============= GUARDAR CAMBIOS ==============
        protected void btn_guardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones
                if (string.IsNullOrWhiteSpace(txt_cedula.Text) || txt_cedula.Text.Length != 10)
                {
                    MostrarMensaje("La cédula debe tener 10 dígitos", "error");
                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txt_nombres.Text))
                {
                    MostrarMensaje("Los nombres son obligatorios", "error");
                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txt_apellidos.Text))
                {
                    MostrarMensaje("Los apellidos son obligatorios", "error");
                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                    return;
                }

                if (string.IsNullOrWhiteSpace(txt_telefono.Text) || txt_telefono.Text.Length != 10)
                {
                    MostrarMensaje("El teléfono debe tener 10 dígitos", "error");
                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                    return;
                }

                int cuentaID = Convert.ToInt32(hf_CuentaID_Editar.Value);

                // Procesar la foto si se subió una nueva
                byte[] fotoPerfil = null;

                if (fu_foto.HasFile)
                {
                    // Validar el tipo de archivo
                    string extension = System.IO.Path.GetExtension(fu_foto.FileName).ToLower();
                    string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".gif" };

                    if (!extensionesPermitidas.Contains(extension))
                    {
                        MostrarMensaje("Solo se permiten imágenes (JPG, PNG, GIF)", "error");
                        ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                        return;
                    }

                    // Validar el tamaño del archivo (máximo 5MB)
                    if (fu_foto.PostedFile.ContentLength > 5242880)
                    {
                        MostrarMensaje("La imagen no debe superar los 5MB", "error");
                        ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                        return;
                    }

                    // Convertir la imagen a byte array
                    fotoPerfil = fu_foto.FileBytes;
                }

                notifyDTO resultado = objPerfil.ActualizarPerfil(
                    cuentaID,
                    txt_cedula.Text.Trim(),
                    txt_nombres.Text.Trim(),
                    txt_apellidos.Text.Trim(),
                    txt_telefono.Text.Trim(),
                    txt_direccion.Text.Trim(),
                    fotoPerfil  // Enviar la foto (puede ser null si no se subió una nueva)
                );

                if (resultado.resultado)
                {
                    MostrarMensaje(resultado.mensajeSalida, "success");
                    CargarPerfiles(hfFiltroActual.Value, txt_Buscar.Text.Trim());
                    ScriptManager.RegisterStartupScript(this, GetType(), "cerrarModal", "cerrarModalEditar();", true);
                }
                else
                {
                    MostrarMensaje(resultado.mensajeSalida, "error");
                    ScriptManager.RegisterStartupScript(this, GetType(), "abrirModal", "abrirModalEditar();", true);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "error");
            }
        }

        // ============= HELPERS ==============
        protected string MostrarAvatar(object fotoPerfil, object nombres)
        {
            if (fotoPerfil != null && fotoPerfil is byte[] foto && foto.Length > 0)
            {
                string base64 = Convert.ToBase64String(foto);
                return $"<img src='data:image/jpeg;base64,{base64}' alt='Avatar' />";
            }

            string inicial = "?";
            if (nombres != null && !string.IsNullOrEmpty(nombres.ToString()))
            {
                inicial = nombres.ToString().Substring(0, 1).ToUpper();
            }
            return $"<span class='avatar-inicial'>{inicial}</span>";
        }

        protected bool EvaluarPerfilCompleto(object cedula, object nombres, object apellidos, object telefono, object fotoperfil)
        {
            return !string.IsNullOrEmpty(cedula?.ToString()) &&
                   !string.IsNullOrEmpty(nombres?.ToString()) &&
                   !string.IsNullOrEmpty(apellidos?.ToString()) &&
                   !string.IsNullOrEmpty(telefono?.ToString()) &&
                   !string.IsNullOrEmpty(fotoperfil?.ToString());
        }

        protected string TruncateText(string text, int maxLength)
        {
            if (string.IsNullOrEmpty(text))
                return "No registrada";

            if (text.Length <= maxLength)
                return text;

            return text.Substring(0, maxLength) + "...";
        }
    }
}