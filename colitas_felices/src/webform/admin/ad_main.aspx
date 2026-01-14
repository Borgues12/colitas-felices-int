<%@ Page Title="" Language="C#" MasterPageFile="~/src/webform/panel.Master" AutoEventWireup="true" CodeBehind="ad_main.aspx.cs" Inherits="colitas_felices.src.webform.admin.ad_main" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/notyf@3/notyf.min.css">
    <link href='<%= ResolveUrl("~/src/css/ad_admin.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="crud-container">
        <!-- ENCABEZADO DEL MÓDULO -->
        <div class="modulo-header">
            <div class="modulo-info">
                <h1 class="modulo-titulo">Gestión de Cuentas</h1>
                <p class="modulo-descripcion">Panel de administración - Control de cuentas y permisos</p>
            </div>
        </div>



        <!-- UPDATE PANEL PRINCIPAL -->
        <%--NO COLOCAR COMENTARIOS DENTRO DEL UPDATE PANEL POR ERRORES DE RENDERIZACION--%>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hfFiltroActual" runat="server" Value="todos" />

                <!-- BARRA DE ACCIONES -->
                <div class="crud-acciones">
                    <!-- BUSCADOR -->
                    <div class="buscador-wrapper">
                        <i class="mdi mdi-magnify icono-buscar"></i>
                        <asp:TextBox ID="txt_Buscar" runat="server"
                            CssClass="input-buscar"
                            placeholder="Buscar por nombre, email o rol..."
                            onkeyup="reiniciarTimer();">
                        </asp:TextBox>
                        <asp:LinkButton ID="btn_LimpiarBusqueda" runat="server"
                            CssClass="btn-limpiar-busqueda"
                            OnClick="btn_LimpiarBusqueda_Click"
                            Visible="false"
                            ToolTip="Limpiar búsqueda">
                        <i class="mdi mdi-close"></i>
           
                        </asp:LinkButton>

                        <!-- Botón oculto que dispara la búsqueda -->
                        <asp:Button ID="btn_BuscarOculto" runat="server"
                            OnClick="btn_BuscarOculto_Click"
                            Style="display: none;" />
                    </div>

                    <!-- BOTÓN NUEVO USUARIO -->
                    <button type="button" class="btn-nuevo" onclick="abrirModalCrear()">
                        <i class="mdi mdi-plus"></i>Nuevo usuario
   
                    </button>
                </div>
                <div class="crud-filtros">
                    <asp:LinkButton ID="btnTodos" runat="server"
                        CssClass="tab-filtro activo"
                        OnClick="btnFiltro_Click"
                        CommandArgument="todos">
                         Todos
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnActivos" runat="server"
                        CssClass="tab-filtro"
                        OnClick="btnFiltro_Click"
                        CommandArgument="activos">
                        Activos
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnBloqueados" runat="server"
                        CssClass="tab-filtro"
                        OnClick="btnFiltro_Click"
                        CommandArgument="bloqueados">
                        Bloqueados
                    </asp:LinkButton>
                </div>
                <div class="tabla-container">
                    <asp:HiddenField ID="hf_PuedeBloquearAdmins" runat="server" Value="0" />
                    <asp:GridView ID="gv_usuarios" runat="server"
                        OnRowDataBound="gv_usuarios_RowDataBound"
                        AutoGenerateColumns="False"
                        CssClass="grid-usuarios"
                        DataKeyNames="CuentaID"
                        EmptyDataText="No hay usuarios registrados">
                        <Columns>
                            <asp:TemplateField HeaderText="USUARIO">
                                <ItemTemplate>
                                    <div class="celda-usuario">
                                        <div class="avatar">
                                            <%# MostrarAvatar(Eval("FotoPerfil"), Eval("Nombres")) %>
                                        </div>
                                        <div class="usuario-info">
                                            <span class="usuario-nombre">
                                                <%# (Eval("Nombres") ?? "") + " " + (Eval("Apellidos") ?? "") %>
                                            </span>
                                            <span class="usuario-email"><%# Eval("Email") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ROL">
                                <ItemTemplate>
                                    <span class='rol-badge <%# Eval("Rol").ToString() == "1" ? "rol-admin" : "rol-usuario" %>'>
                                        <%# Eval("Rol").ToString() == "1" ? "Administrador" : "Usuario" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ESTADO">
                                <ItemTemplate>
                                    <div class='<%# "estado-select-wrapper " + ObtenerClaseEstado(Eval("Estado").ToString()) %>'>
                                        <span class="estado-dot"></span>
                                        <asp:DropDownList ID="ddl_Estado" runat="server"
                                            CssClass="estado-select"
                                            SelectedValue='<%# Eval("Estado") %>'
                                            AutoPostBack="true"
                                            OnSelectedIndexChanged="ddl_Estado_Changed">
                                            <asp:ListItem Value="1" Text="Activo" />
                                            <asp:ListItem Value="2" Text="Bloqueado" />
                                        </asp:DropDownList>

                                        <asp:Label ID="lblEstadoAdmin" runat="server" CssClass="estado-texto" />

                                        <asp:HiddenField ID="hf_CuentaID_Row" runat="server" Value='<%# Eval("CuentaID") %>' />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ÚLTIMO ACCESO">
                                <ItemTemplate>
                                    <%# FormatearFecha(Eval("UltimoAcceso")) %>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ACCIONES">
                                <ItemTemplate>
                                    <div class="btn-group" role="group">
                                        <asp:LinkButton ID="btnCambiarRol" runat="server"
                                            CssClass="btn btn-outline-primary btn-accion-grid"
                                            CommandName="CambiarRol"
                                            CommandArgument='<%# Eval("CuentaID") + "," + Eval("Rol") %>'
                                            OnCommand="AccionesGrid_Command"
                                            ToolTip="Cambiar rol">
                                    <i class="mdi mdi-account-switch d-block mb-1"></i> Rol
                                    </asp:LinkButton>

                                        <asp:LinkButton ID="btnResetearPassword" runat="server"
                                            CssClass="btn btn-outline-warning btn-accion-grid"
                                            CommandName="ResetearPassword"
                                            CommandArgument='<%# Eval("CuentaID") %>'
                                            OnCommand="AccionesGrid_Command"
                                            OnClientClick="return confirm('¿Está seguro de resetear la contraseña de este usuario?');"
                                            ToolTip="Resetear contraseña">
                                <i class="mdi mdi-lock-reset d-block mb-1"></i> Reset
                                </asp:LinkButton>

                                        <asp:LinkButton ID="btnEliminar" runat="server"
                                            CssClass="btn btn-outline-danger btn-accion-grid"
                                            CommandName="Eliminar"
                                            CommandArgument='<%# Eval("CuentaID") %>'
                                            OnCommand="AccionesGrid_Command"
                                            OnClientClick="return confirm('¿Está seguro de eliminar este usuario?');"
                                            ToolTip="Eliminar usuario">
                                            <i class="mdi mdi-delete d-block mb-1"></i> Eliminar
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="paginacion-container">
                        <div class="paginacion-info">
                            Mostrando
                            <asp:Label ID="lbl_mostrando" runat="server" Text="0"></asp:Label>
                            usuarios
                       
                        </div>
                    </div>
                </div>
                <div class="crud-counter-total">
                    <div class="crud-stats">
                        Total Usuarios: <span>
                            <asp:Label ID="lbl_total" runat="server" Text="0"></asp:Label></span>
                    </div>
                </div>

                <div id="modal-crear" class="modal-overlay">
                    <div class="modal-contenido">
                        <div class="modal-header">
                            <h2 class="modal-titulo">Nuevo Usuario</h2>
                            <button type="button" class="modal-cerrar" onclick="cerrarModalCrear()">
                                <i class="mdi mdi-close"></i>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="form-seccion">
                                <div class="form-seccion-titulo">Datos de Cuenta</div>

                                <div class="form-grupo">
                                    <label>Email <span class="requerido">*</span></label>
                                    <asp:TextBox ID="txt_email_crear" runat="server" placeholder="correo@ejemplo.com" />
                                </div>

                                <div class="form-grupo">
                                    <label>Contraseña <span class="requerido">*</span></label>
                                    <asp:TextBox ID="txt_password_crear" runat="server" TextMode="Password" placeholder="Mínimo 6 caracteres" />
                                </div>

                                <div class="form-grupo">
                                    <label>Rol</label>
                                    <asp:DropDownList ID="ddl_rol_crear" runat="server" CssClass="form-select">
                                        <asp:ListItem Value="2" Text="Usuario" />
                                        <asp:ListItem Value="1" Text="Administrador" />
                                    </asp:DropDownList>
                                </div>

                                <div class="estado-info">
                                    <i class="mdi mdi-information-outline"></i>
                                    <span>El usuario se creará con estado <strong>Activo</strong> automáticamente</span>
                                </div>
                            </div>

                            <div class="expandir-container">
                                <button type="button" class="btn-expandir" onclick="toggleFormularioDetallado()">
                                    <span id="texto-expandir">Añadir datos de perfil</span>
                                    <i class="mdi mdi-chevron-down" id="icono-expandir"></i>
                                </button>
                            </div>

                            <div id="form-detallado" class="form-detallado" style="display: none;">
                                <div class="form-seccion">
                                    <div class="form-seccion-titulo">Datos Personales (Opcional)</div>

                                    <div class="form-grupo">
                                        <label>Cédula</label>
                                        <asp:TextBox ID="txt_cedula_crear" runat="server" placeholder="1234567890" MaxLength="10" />
                                    </div>

                                    <div class="form-row">
                                        <div class="form-grupo">
                                            <label>Nombres</label>
                                            <asp:TextBox ID="txt_nombres_crear" runat="server" placeholder="Nombres" />
                                        </div>
                                        <div class="form-grupo">
                                            <label>Apellidos</label>
                                            <asp:TextBox ID="txt_apellidos_crear" runat="server" placeholder="Apellidos" />
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-grupo">
                                            <label>Teléfono</label>
                                            <asp:TextBox ID="txt_telefono_crear" runat="server" placeholder="0999999999" MaxLength="10" />
                                        </div>
                                        <div class="form-grupo">
                                            <label>Dirección</label>
                                            <asp:TextBox ID="txt_direccion_crear" runat="server" placeholder="Dirección" />
                                        </div>
                                    </div>

                                    <div class="form-grupo">
                                        <label>Foto de Perfil</label>
                                        <div class="foto-actual-container">
                                            <asp:Image ID="Image1" runat="server" CssClass="foto-actual" Visible="false" />
                                        </div>
                                        <asp:FileUpload ID="FileUpload1" runat="server" CssClass="input-file"
                                            onchange="validarTamanoArchivo(this)"
                                            accept="image/jpeg,image/jpg,image/png,image/gif" />
                                        <small class="texto-ayuda">Máximo 5MB. Formatos: JPG, PNG, GIF</small>
                                        <div id="info-archivo2" class="info-archivo" style="display: none;"></div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-botones">
                            <button type="button" class="btn-cancelar" onclick="cerrarModalCrear()">Cancelar</button>
                            <asp:Button ID="btn_crear" runat="server" Text="Crear Usuario"
                                CssClass="btn-guardar" OnClick="btn_crear_Click" />
                        </div>
                    </div>
                </div>

            </ContentTemplate>

            <Triggers>
                <asp:PostBackTrigger ControlID="btn_crear" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

    <!-- ============= SCRIPTS ============= -->

    <script>
        var timerBusqueda;

        function reiniciarTimer() {
            clearTimeout(timerBusqueda);

            timerBusqueda = setTimeout(function () {
                document.getElementById('<%= btn_BuscarOculto.ClientID %>').click();
            }, 400);
        }

        // Restaurar foco después del postback del UpdatePanel
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var txtBuscar = document.getElementById('<%= txt_Buscar.ClientID %>');
            if (txtBuscar) {
                txtBuscar.focus();
                var len = txtBuscar.value.length;
                if (len > 0) {
                    txtBuscar.setSelectionRange(len, len);
                }
            }
        });
    </script>
    <script>
        // ============ VALIDAR TAMAÑO DE ARCHIVO ============
        function validarTamanoArchivo(input) {
            const maxSizeMB = 5;
            const maxSizeBytes = maxSizeMB * 1024 * 1024;
            const infoDiv = document.getElementById('info-archivo');

            if (input.files && input.files[0]) {
                const file = input.files[0];
                const sizeMB = (file.size / 1024 / 1024).toFixed(2);

                if (file.size > maxSizeBytes) {
                    infoDiv.innerHTML = '<span style="color: #e74c3c;">❌ Archivo muy grande: ' + sizeMB + 'MB (máx ' + maxSizeMB + 'MB)</span>';
                    infoDiv.style.display = 'block';
                    input.value = '';
                    return false;
                }

                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                if (!allowedTypes.includes(file.type)) {
                    infoDiv.innerHTML = '<span style="color: #e74c3c;">❌ Tipo de archivo no permitido. Use JPG, PNG o GIF</span>';
                    infoDiv.style.display = 'block';
                    input.value = '';
                    return false;
                }

                infoDiv.innerHTML = '<span style="color: #27ae60;">✓ ' + file.name + ' (' + sizeMB + 'MB)</span>';
                infoDiv.style.display = 'block';
                return true;
            }

            infoDiv.style.display = 'none';
            return true;
        }

        // ============ MODAL CREAR ============
        function abrirModalCrear() {
            const modal = document.getElementById('modal-crear');
            if (modal) {
                modal.classList.add('activo');

                // Resetear formulario detallado
                const formDetallado = document.getElementById('form-detallado');
                if (formDetallado) {
                    formDetallado.style.display = 'none';
                }

                const btnExpandir = document.querySelector('.btn-expandir');
                if (btnExpandir) {
                    btnExpandir.classList.remove('expandido');
                }

                const textoExpandir = document.getElementById('texto-expandir');
                if (textoExpandir) {
                    textoExpandir.innerText = 'Añadir datos de perfil';
                }
            }
        }

        function cerrarModalCrear() {
            const modal = document.getElementById('modal-crear');
            if (modal) {
                modal.classList.remove('activo');
            }
        }

        function toggleFormularioDetallado() {
            const formDetallado = document.getElementById('form-detallado');
            const btnExpandir = document.querySelector('.btn-expandir');
            const textoExpandir = document.getElementById('texto-expandir');

            if (formDetallado.style.display === 'none') {
                formDetallado.style.display = 'block';
                btnExpandir.classList.add('expandido');
                textoExpandir.innerText = 'Ocultar datos de perfil';
            } else {
                formDetallado.style.display = 'none';
                btnExpandir.classList.remove('expandido');
                textoExpandir.innerText = 'Añadir datos de perfil';
            }
        }


        // ============ CERRAR AL CLICK FUERA ============
        window.addEventListener('DOMContentLoaded', function () {
            const modalCrear = document.getElementById('modal-crear');

            if (modalCrear) {
                modalCrear.addEventListener('click', function (e) {
                    if (e.target === this) {
                        cerrarModalCrear();
                    }
                });
            }

        });

        // ============ RE-BINDEAR EVENTOS DESPUÉS DE UPDATEPANEL ============
        //Toma la instacia que controla las actualizaciones parciales de la pagina
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        //Se ejecuta cada que UpdatePanel actualiza contenido para no perder los javascripts
        //Son las instrucciones que se da para hacer cuando se activa el update panel
        prm.add_endRequest(function () {
            // Revincula los eventos onclick a estas secciones: los modales
            const modalCrear = document.getElementById('modal-crear');
            const modalEditar = document.getElementById('modal-editar');

            //verifica que el clic que se dio fuera del overlay no fue dentro
            //e: es un reporte de lo que se hizo en la seccion que buscamos
            //e.target: es el objeto especifico que dice donde se cliqueo, por ejemplo un boton, un contenedor general en este caso seria la cortina negra fuera del modal, o un cuadro dentro del cotenedor como el modal
            if (modalCrear) {
                modalCrear.onclick = function (e) {
                    if (e.target === this) cerrarModalCrear();
                };
            }

            if (modalEditar) {
                modalEditar.onclick = function (e) {
                    if (e.target === this) cerrarModalEditar();
                };
            }
        });
    </script>


    <%--toma la libreria para las notificaciones--%>
    <script src="https://cdn.jsdelivr.net/npm/notyf@3/notyf.min.js"></script>
    <script>
        var notyf = new Notyf({
            duration: 4000,
            position: { x: 'center', y: 'top' },
            dismissible: true,
            ripple: true,  // Mantener para success/error
            types: [
                {
                    type: 'warning',
                    background: '#f59e0b',
                    className: 'notyf-warning-ancho',
                    ripple: false,  // ← Desactivar ripple para warning
                    icon: {
                        className: 'mdi mdi-alert',
                        tagName: 'i',
                        color: '#fff'
                    }
                }
            ]
        });
    </script>
    <style>
        /* Warning más ancho */
        .notyf-warning-ancho {
            max-width: 450px !important;
            min-width: 350px !important;
            font-size: 0.9em;
        }
    </style>
</asp:Content>
