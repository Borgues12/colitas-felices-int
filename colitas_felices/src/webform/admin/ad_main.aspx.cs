using capa_dto;
using capa_negocio;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace colitas_felices.src.webform.admin
{
    public partial class ad_main : notificaciones
    {
        // Instancia de la capa de negocio
        private CN_Usuario objCN = new CN_Usuario();

        protected void Page_Load(object sender, EventArgs e)
        {
            // DEBUG - Ver qué hay en sesión
            System.Diagnostics.Debug.WriteLine("=== AD_MAIN PAGE_LOAD ===");
            System.Diagnostics.Debug.WriteLine($"Session CuentaID: {Session["CuentaID"]}");
            System.Diagnostics.Debug.WriteLine($"Session Rol: {Session["Rol"]}");
            System.Diagnostics.Debug.WriteLine($"EstaLogueado: {EstaLogueado}");
            System.Diagnostics.Debug.WriteLine($"RolUsuario: {RolUsuario}");

            if (!EstaLogueado)
            {
                System.Diagnostics.Debug.WriteLine(">>> NO LOGUEADO - Redirigiendo a main");
                Response.Redirect("~/src/webform/main.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (RolUsuario != 1)
            {
                System.Diagnostics.Debug.WriteLine(">>> ROL NO ES ADMIN - Redirigiendo");
                Response.Redirect(ObtenerRutaPorRol(), false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            System.Diagnostics.Debug.WriteLine(">>> TODO OK - Cargando página");

            if (!IsPostBack)
            {
                btnActivos.CssClass = "tab-filtro activo";
                CargarUsuarios("todos");
            }
        }

        // ========== METODO PARA ACTUALIZAR ESTADO DE ADMINS EN HIDDENFIELD ==========
        private void ActualizarEstadoAdministradores()
        {
            try
            {
                int adminsActivos = objCN.ContarAdministradoresActivosCN();
                hf_PuedeBloquearAdmins.Value = adminsActivos > 1 ? "1" : "0";

                System.Diagnostics.Debug.WriteLine($"✅ Administradores activos: {adminsActivos} | Puede bloquear: {hf_PuedeBloquearAdmins.Value}");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"❌ Error al actualizar estado admins: {ex.Message}");
                hf_PuedeBloquearAdmins.Value = "0"; // Por seguridad, no permitir bloqueos
            }
        }


        protected void gv_usuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Registrar botón editar para postback
                LinkButton btnEditar = (LinkButton)e.Row.FindControl("btnEditar");
                if (btnEditar != null)
                {
                    ScriptManager.GetCurrent(this).RegisterPostBackControl(btnEditar);
                }

                // Obtener datos de la fila
                string rol = DataBinder.Eval(e.Row.DataItem, "Rol").ToString();
                string estado = DataBinder.Eval(e.Row.DataItem, "Estado").ToString();

                DropDownList ddlEstado = (DropDownList)e.Row.FindControl("ddl_Estado");
                Label lblEstadoAdmin = (Label)e.Row.FindControl("lblEstadoAdmin");

                if (rol == "1")  // ⚙️ Es ADMINISTRADOR
                {
                    // Verificar si hay más de un admin activo
                    bool puedeBloquearAdmins = hf_PuedeBloquearAdmins.Value == "1";
                    bool esAdminActivo = estado == "1";

                    if (esAdminActivo && !puedeBloquearAdmins)
                    {
                        // ⚠️ Es el ÚLTIMO ADMIN ACTIVO: No se puede cambiar
                        if (ddlEstado != null)
                            ddlEstado.Visible = false;

                        if (lblEstadoAdmin != null)
                        {
                            lblEstadoAdmin.Visible = true;
                            lblEstadoAdmin.Text = "Activo";
                            lblEstadoAdmin.CssClass = "badge badge-success";
                            lblEstadoAdmin.ToolTip = "Este es el único administrador activo del sistema";
                        }
                    }
                    else
                    {
                        // ✅ Hay más admins o este está inactivo: Se puede cambiar
                        if (ddlEstado != null)
                        {
                            ddlEstado.Visible = true;
                            ddlEstado.SelectedValue = estado;
                        }

                        if (lblEstadoAdmin != null)
                            lblEstadoAdmin.Visible = false;
                    }
                }
                else  // 👤 Usuario normal
                {
                    // Usuario normal: siempre muestra dropdown
                    if (ddlEstado != null)
                    {
                        ddlEstado.Visible = true;
                        ddlEstado.SelectedValue = estado;
                    }

                    if (lblEstadoAdmin != null)
                        lblEstadoAdmin.Visible = false;
                }
            }
        }

        // ==========================================
        // EVENTOS DEL BUSCADOR
        // ==========================================

        protected void txt_Buscar_TextChanged(object sender, EventArgs e)
        {
            string termino = txt_Buscar.Text.Trim();

            if (!string.IsNullOrEmpty(termino))
            {
                // Buscar con el término
                var usuarios = objCN.BuscarCuentasCN(termino);

                // Mostrar botón limpiar
                btn_LimpiarBusqueda.Visible = true;

                // Actualizar GridView
                ActualizarEstadoAdministradores();
                gv_usuarios.DataSource = usuarios;
                gv_usuarios.DataBind();

                lbl_total.Text = usuarios.Count.ToString();
                lbl_mostrando.Text = usuarios.Count.ToString();
            }
            else
            {
                // Si está vacío, cargar todos
                btn_LimpiarBusqueda.Visible = false;
                CargarUsuarios(hfFiltroActual.Value);
            }
        }

        protected void btn_BuscarOculto_Click(object sender, EventArgs e)
        {
            string termino = txt_Buscar.Text.Trim();

            if (!string.IsNullOrEmpty(termino))
            {
                var usuarios = objCN.BuscarCuentasCN(termino);
                btn_LimpiarBusqueda.Visible = true;

                ActualizarEstadoAdministradores();
                gv_usuarios.DataSource = usuarios;
                gv_usuarios.DataBind();

                lbl_total.Text = usuarios.Count.ToString();
                lbl_mostrando.Text = usuarios.Count.ToString();
            }
            else
            {
                btn_LimpiarBusqueda.Visible = false;
                CargarUsuarios(hfFiltroActual.Value);
            }
        }

        protected void btn_LimpiarBusqueda_Click(object sender, EventArgs e)
        {
            txt_Buscar.Text = string.Empty;
            btn_LimpiarBusqueda.Visible = false;
            CargarUsuarios(hfFiltroActual.Value);
        }

        //METODO PARA CAMBIAR CLASES Y ENVIAR EL FILTRO
        protected void btnFiltro_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string filtro = btn.CommandArgument;

            // 🔄 Quitar clase activa a todos
            btnTodos.CssClass = "tab-filtro";
            btnActivos.CssClass = "tab-filtro";
            btnBloqueados.CssClass = "tab-filtro";

            // ✅ Activar el botón seleccionado
            btn.CssClass = "tab-filtro activo";

            hfFiltroActual.Value = filtro;
            // 📌 Cargar usuarios según filtro
            CargarUsuarios(filtro);
        }

        /// Carga la lista de usuarios según el filtro especificado
        private void CargarUsuarios(string filtro)
        {
            try
            {
                List<UsuarioCuentaDTO> usuarios;

                switch (filtro)
                {
                    case "activos":
                        usuarios = objCN.ListarCuentasCN("ACTIVOS");
                        break;
                    case "bloqueados":
                        usuarios = objCN.ListarCuentasCN("BLOQUEADOS");
                        break;
                    default:
                        usuarios = objCN.ListarCuentasCN();
                        break;
                }

                // ✅ ACTUALIZAR ESTADO DE ADMINS ANTES DE BINDEAR
                ActualizarEstadoAdministradores();

                gv_usuarios.DataSource = usuarios;
                gv_usuarios.DataBind();

                lbl_total.Text = usuarios.Count.ToString();
                lbl_mostrando.Text = usuarios.Count.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al cargar datos:{ex.Message}");
                MostrarMensaje("Error al cargar usuarios", "error");
            }
        }


        /// <summary>
        /// Genera el HTML para mostrar avatar o inicial del usuario
        /// </summary>
        protected string MostrarAvatar(object fotoPerfil, object nombres)
        {
            if (fotoPerfil != null && fotoPerfil != DBNull.Value)
            {
                byte[] imagenBytes = (byte[])fotoPerfil;

                if (imagenBytes != null && imagenBytes.Length > 0)
                {
                    string base64 = Convert.ToBase64String(imagenBytes);
                    return $"<img src='data:image/jpeg;base64,{base64}' alt='Foto perfil' class='avatar-img' />";
                }
            }

            string inicial = "?";
            if (nombres != null && !string.IsNullOrEmpty(nombres.ToString()))
            {
                inicial = nombres.ToString().Substring(0, 1).ToUpper();
            }

            return $"<span class='avatar-inicial'>{inicial}</span>";
        }

        /// <summary>
        /// Obtiene la clase CSS según el estado del usuario
        /// </summary>
        protected string ObtenerClaseEstado(string estado)
        {
            switch (estado?.ToLower())
            {
                case "ACTIVO": return "estado-activo";
                case "BLOQUEADO": return "estado-bloqueado";
                default: return "";
            }
        }

        /// <summary>
        /// Formatea la fecha para mostrar en la tabla
        /// </summary>
        protected string FormatearFecha(object fecha)
        {
            if (fecha == null || fecha == DBNull.Value)
                return "Nunca";

            try
            {
                DateTime dt = Convert.ToDateTime(fecha);
                if (dt == DateTime.MinValue)
                    return "Nunca";

                return dt.ToString("dd MMM yyyy");
            }
            catch
            {
                return "Nunca";
            }
        }


        //Para crear un nuevo usuario
        protected void btn_crear_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones básicas en el lado del servidor (UX)
                if (string.IsNullOrWhiteSpace(txt_email_crear.Text))
                {
                    MostrarMensaje("El email es obligatorio", "error");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txt_password_crear.Text))
                {
                    MostrarMensaje("La contraseña es obligatoria", "error");
                    return;
                }

                // Crear objeto DTO
                CrearCuentaDTO newCuenta = new CrearCuentaDTO
                {
                    Email = txt_email_crear.Text.Trim(),
                    Password = txt_password_crear.Text,
                    Rol = Convert.ToByte(ddl_rol_crear.SelectedValue),

                    // Campos opcionales del perfil
                    Cedula = !string.IsNullOrWhiteSpace(txt_cedula_crear.Text)
                        ? txt_cedula_crear.Text.Trim()
                        : null,
                    Nombres = !string.IsNullOrWhiteSpace(txt_nombres_crear.Text)
                        ? txt_nombres_crear.Text.Trim()
                        : null,
                    Apellidos = !string.IsNullOrWhiteSpace(txt_apellidos_crear.Text)
                        ? txt_apellidos_crear.Text.Trim()
                        : null,
                    Telefono = !string.IsNullOrWhiteSpace(txt_telefono_crear.Text)
                        ? txt_telefono_crear.Text.Trim()
                        : null,
                    Direccion = !string.IsNullOrWhiteSpace(txt_direccion_crear.Text)
                        ? txt_direccion_crear.Text.Trim()
                        : null,
                    FotoPerfil = null
                };

                // Procesar y validar foto de perfil si se subió
                if (FileUpload1.HasFile)
                {
                    newCuenta.FotoPerfil = ValidarYConvertirArchivo(FileUpload1);

                    // Si la validación falló, ValidarYConvertirArchivo retorna null y ya mostró el error
                    if (newCuenta.FotoPerfil == null)
                    {
                        return;
                    }
                }

                // Llamar a la capa de negocio
                notifyDTO resultado = objCN.CrearCuentaCN(newCuenta);

                if (resultado.resultado)
                {
                    MostrarMensaje(resultado.mensajeSalida, "success");
                    LimpiarModalCrear();
                    CargarUsuarios("todos");
                    EjecutarScript("cerrarModalCrear();");
                }
                else
                {
                    MostrarMensaje(resultado.mensajeSalida, "error");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje($"Error inesperado", "error");
                System.Diagnostics.Debug.WriteLine($"Error en btn_crear_Click: {ex.Message}");
            }
        }

        private void LimpiarModalCrear()
        {
            // Limpiar campos de cuenta
            txt_email_crear.Text = "";
            txt_password_crear.Text = "";
            ddl_rol_crear.SelectedIndex = 0;

            // Limpiar campos de perfil
            txt_cedula_crear.Text = "";
            txt_nombres_crear.Text = "";
            txt_apellidos_crear.Text = "";
            txt_telefono_crear.Text = "";
            txt_direccion_crear.Text = "";

            // Nota: FileUpload1 se limpia automáticamente en postback
            Image1.Visible = false;
        }

        private void EliminarUsuario(int cuentaID)
        {
            try
            {
                notifyDTO resultado = objCN.EliminarCuentaCN(cuentaID);

                if (resultado.resultado)
                {
                    MostrarMensaje($"{resultado.mensajeSalida}", "success");
                    CargarUsuarios(hfFiltroActual.Value);
                }
                else
                {
                    MostrarMensaje($"{resultado.mensajeSalida}", "error");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error al eliminar usuario", "error");
                System.Diagnostics.Debug.WriteLine($"Error al eliminar cuenta: {ex.Message}");
            }
        }


        protected void ddl_Estado_Changed(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddl.NamingContainer;
            HiddenField hf = (HiddenField)row.FindControl("hf_CuentaID_Row");

            int cuentaID = Convert.ToInt32(hf.Value);
            byte nuevoEstado = Convert.ToByte(ddl.SelectedValue);

            notifyVarDTO resultado = objCN.CambiarEstadoCuentaCN(cuentaID, nuevoEstado);

            if (resultado.resultado2)
            {
                if (resultado.codigo == 1)
                {
                    string mensajeFormateado = resultado.mensajeSalida2.Replace("\n", "<br>");
                    MostrarMensaje(mensajeFormateado, "warning");
                }
                else
                {
                    MostrarMensaje(resultado.mensajeSalida2, "success");
                }

                CargarUsuarios(hfFiltroActual.Value);
            }
            else
            {
                MostrarMensaje(resultado.mensajeSalida2, "error");
                CargarUsuarios(hfFiltroActual.Value);
            }
        }

        protected void AccionesGrid_Command(object sender, CommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "CambiarRol":
                    // El argumento viene como "CuentaID,RolActual"
                    string[] datos = e.CommandArgument.ToString().Split(',');
                    int cuentaID = Convert.ToInt32(datos[0]);
                    byte rolActual = Convert.ToByte(datos[1]);
                    CambiarRolUsuario(cuentaID, rolActual);
                    break;

                case "ResetearPassword":
                    int cuentaIDReset = Convert.ToInt32(e.CommandArgument);
                    ResetearPassword(cuentaIDReset);
                    break;

                case "Eliminar":
                    int cuentaIDEliminar = Convert.ToInt32(e.CommandArgument);
                    EliminarUsuario(cuentaIDEliminar);
                    break;
            }
        }

        private void CambiarRolUsuario(int cuentaID, byte rolActual)
        {
            try
            {
                // Cambiar al rol opuesto
                byte nuevoRol = (rolActual == 1) ? (byte)2 : (byte)1;

                notifyDTO resultado = objCN.CambiarRol(cuentaID, nuevoRol);

                if (resultado.resultado)
                {
                    string rolTexto = (nuevoRol == 1) ? "Administrador" : "Usuario";
                    MostrarMensaje($"Rol cambiado a {rolTexto}", "success");
                    CargarUsuarios(hfFiltroActual.Value);
                }
                else
                {
                    MostrarMensaje(resultado.mensajeSalida, "error");
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "error");
            }
        }

        // Resetear contraseña (placeholder por ahora)
        private void ResetearPassword(int cuentaID)
        {
            try
            {
                // TODO: Implementar lógica real
                MostrarMensaje("Función de resetear contraseña próximamente", "warning");
            }
            catch (Exception ex)
            {
                MostrarMensaje("Error: " + ex.Message, "error");
            }
        }


        /// <summary>
        /// Valida el archivo subido (tamaño y tipo)
        /// </summary>
        private bool ValidarArchivo(FileUpload fu)
        {
            const int maxSizeBytes = 5 * 1024 * 1024; // 5MB
            string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".gif" };
            string extension = System.IO.Path.GetExtension(fu.FileName).ToLower();

            if (fu.PostedFile.ContentLength > maxSizeBytes)
            {
                MostrarMensaje("La foto no puede superar los 5MB", "error");
                return false;
            }

            if (!extensionesPermitidas.Contains(extension))
            {
                MostrarMensaje("Solo se permiten archivos JPG, PNG o GIF", "error");
                return false;
            }

            return true;
        }

        // Método unificado: valida y convierte en una sola operación
        private byte[] ValidarYConvertirArchivo(FileUpload fu)
        {
            const int maxSizeBytes = 5 * 1024 * 1024; // 5MB
            string[] extensionesPermitidas = { ".jpg", ".jpeg", ".png", ".gif" };

            // Validar tamaño
            if (fu.PostedFile.ContentLength > maxSizeBytes)
            {
                MostrarMensaje("La foto no puede superar los 5MB", "error");
                return null;
            }

            // Validar extensión
            string extension = System.IO.Path.GetExtension(fu.FileName).ToLower();
            if (!extensionesPermitidas.Contains(extension))
            {
                MostrarMensaje("Solo se permiten archivos JPG, PNG o GIF", "error");
                return null;
            }

            // Si pasó las validaciones, convertir a byte array
            using (BinaryReader br = new BinaryReader(fu.PostedFile.InputStream))
            {
                return br.ReadBytes(fu.PostedFile.ContentLength);
            }
        }

        /// <summary>
        /// Ejecuta un script JavaScript en el cliente
        /// </summary>
        private void EjecutarScript(string script)
        {
            ScriptManager.RegisterStartupScript(
                this.UpdatePanel1,
                this.UpdatePanel1.GetType(),
                Guid.NewGuid().ToString(),
                script,
                true
            );
        }

    }
}