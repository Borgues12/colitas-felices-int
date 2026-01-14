<%@ Page Title="" Language="C#" MasterPageFile="~/src/webform/panel.Master" AutoEventWireup="true" CodeBehind="ad_perfiles.aspx.cs" Inherits="colitas_felices.src.webform.admin.ad_perfiles" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/notyf@3/notyf.min.css">
    <link href='<%= ResolveUrl("~/src/css/ad_admin.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="crud-container">
        <!-- ENCABEZADO DEL MÓDULO -->
        <div class="modulo-header">
            <div class="modulo-info">
                <h1 class="modulo-titulo">Gestión de Perfiles</h1>
                <p class="modulo-descripcion">Administración de datos personales de usuarios</p>
            </div>
        </div>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <!-- BARRA DE ACCIONES -->
                <div class="crud-acciones">
                    <div class="buscador-wrapper">
                        <i class="mdi mdi-magnify icono-buscar"></i>
                        <asp:TextBox ID="txt_Buscar" runat="server"
                            CssClass="input-buscar"
                            placeholder="Buscar por nombre, cédula o email..."
                            onkeyup="reiniciarTimer();">
                        </asp:TextBox>
                        <asp:LinkButton ID="btn_LimpiarBusqueda" runat="server"
                            CssClass="btn-limpiar-busqueda"
                            OnClick="btn_LimpiarBusqueda_Click"
                            Visible="false"
                            ToolTip="Limpiar búsqueda">
                            <i class="mdi mdi-close"></i>
                        </asp:LinkButton>
                        <asp:Button ID="btn_BuscarOculto" runat="server"
                            OnClick="btn_BuscarOculto_Click"
                            Style="display: none;" />
                    </div>
                </div>

                <!-- FILTROS -->
                <div class="crud-filtros">
                    <asp:LinkButton ID="btnTodos" runat="server"
                        CssClass="tab-filtro activo"
                        OnClick="btnFiltro_Click"
                        CommandArgument="todos">
                        Todos
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnCompletos" runat="server"
                        CssClass="tab-filtro"
                        OnClick="btnFiltro_Click"
                        CommandArgument="completos">
                        Completos
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnIncompletos" runat="server"
                        CssClass="tab-filtro"
                        OnClick="btnFiltro_Click"
                        CommandArgument="incompletos">
                        Incompletos
                    </asp:LinkButton>
                </div>

                <!-- TABLA DE PERFILES -->
                <div class="tabla-container">
                    <asp:HiddenField ID="hfFiltroActual" runat="server" Value="todos" />

                    <asp:GridView ID="gv_perfiles" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="grid-usuarios"
                        DataKeyNames="CuentaID"
                        EmptyDataText="No hay perfiles registrados">
                        <Columns>
                            <asp:TemplateField HeaderText="USUARIO">
                                <ItemTemplate>
                                    <div class="celda-usuario">
                                        <div class="avatar">
                                            <%# MostrarAvatar(Eval("FotoPerfil"), Eval("Nombres")) %>
                                        </div>
                                        <div class="usuario-info">
                                            <span class="usuario-nombre">
                                                <%# (Eval("Nombres") ?? "Sin nombre") + " " + (Eval("Apellidos") ?? "") %>
                                            </span>
                                            <span class="usuario-email"><%# Eval("Email") %></span>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="CÉDULA">
                                <ItemTemplate>
                                    <span class="<%# string.IsNullOrEmpty(Eval("Cedula")?.ToString()) ? "texto-vacio" : "" %>">
                                        <%# Eval("Cedula") ?? "No registrada" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="TELÉFONO">
                                <ItemTemplate>
                                    <span class="<%# string.IsNullOrEmpty(Eval("Telefono")?.ToString()) ? "texto-vacio" : "" %>">
                                        <%# Eval("Telefono") ?? "No registrado" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="DIRECCIÓN">
                                <ItemTemplate>
                                    <span
                                        runat="server"
                                        class='<%# string.IsNullOrEmpty(Eval("Direccion") as string) ? "texto-vacio" : "" %>'>
                                        <%# TruncateText(Eval("Direccion") as string, 25) %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ESTADO">
                                <ItemTemplate>
                                    <span class='perfil-badge <%# EvaluarPerfilCompleto(Eval("Cedula"), Eval("Nombres"), Eval("Apellidos"), Eval("Telefono"), Eval("FotoPerfil")) ? "perfil-completo" : "perfil-incompleto" %>'>
                                        <%# EvaluarPerfilCompleto(Eval("Cedula"), Eval("Nombres"), Eval("Apellidos"), Eval("Telefono"), Eval("FotoPerfil")) ? "Completo" : "Incompleto" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="ACCIONES">
                                <ItemTemplate>
                                    <div class="btn-group" role="group">
                                        <asp:LinkButton ID="btnEditar" runat="server"
                                            CssClass="btn btn-outline-secondary btn-accion-grid"
                                            CommandName="Editar"
                                            CommandArgument='<%# Eval("PerfilID") %>'
                                            OnCommand="AccionesGrid_Command"
                                            ToolTip="Editar perfil">
                                            <i class="mdi mdi-pencil d-block mb-1"></i> Editar
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
                            perfiles
                        </div>
                    </div>
                </div>

                <div class="crud-counter-total">
                    <div class="crud-stats">
                        Total Perfiles: <span>
                            <asp:Label ID="lbl_total" runat="server" Text="0"></asp:Label></span>
                    </div>
                </div>

                <!-- MODAL EDITAR PERFIL -->
                <div id="modal-editar" class="modal-overlay">
                    <div class="modal-contenido">
                        <div class="modal-header">
                            <h2 class="modal-titulo">Editar Perfil</h2>
                            <button type="button" class="modal-cerrar" onclick="cerrarModalEditar()">
                                <i class="mdi mdi-close"></i>
                            </button>
                        </div>

                        <div class="modal-body">
                            <asp:HiddenField ID="hf_CuentaID_Editar" runat="server" Value="0" />

                            <!-- Email solo lectura -->
                            <div class="info-usuario-box">
                                <div class="info-item">
                                    <span class="info-label">Email:</span>
                                    <asp:Label ID="lbl_email" runat="server" CssClass="info-valor"></asp:Label>
                                </div>
                            </div>

                            <div class="form-seccion">
                                <div class="form-seccion-titulo">Datos Personales</div>

                                <div class="form-grupo">
                                    <label>Cédula <span class="requerido">*</span></label>
                                    <asp:TextBox ID="txt_cedula" runat="server" placeholder="1234567890" MaxLength="10" />
                                </div>

                                <div class="form-row">
                                    <div class="form-grupo">
                                        <label>Nombres <span class="requerido">*</span></label>
                                        <asp:TextBox ID="txt_nombres" runat="server" placeholder="Nombres" />
                                    </div>
                                    <div class="form-grupo">
                                        <label>Apellidos <span class="requerido">*</span></label>
                                        <asp:TextBox ID="txt_apellidos" runat="server" placeholder="Apellidos" />
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-grupo">
                                        <label>Teléfono <span class="requerido">*</span></label>
                                        <asp:TextBox ID="txt_telefono" runat="server" placeholder="0999999999" MaxLength="10" />
                                    </div>
                                    <div class="form-grupo">
                                        <label>Dirección</label>
                                        <asp:TextBox ID="txt_direccion" runat="server" placeholder="Dirección" />
                                    </div>
                                </div>

                                <div class="form-grupo">
                                    <label>Foto de Perfil</label>
                                    <div class="foto-actual-container">
                                        <asp:Image ID="img_foto_actual" runat="server" CssClass="foto-actual" Visible="false" />
                                    </div>
                                    <asp:FileUpload ID="fu_foto" runat="server" CssClass="input-file"
                                        onchange="validarTamanoArchivo(this)"
                                        accept="image/jpeg,image/jpg,image/png,image/gif" />
                                    <small class="texto-ayuda">Máximo 5MB. Formatos: JPG, PNG, GIF</small>
                                    <div id="info-archivo" class="info-archivo" style="display: none;"></div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-botones">
                            <button type="button" class="btn-cancelar" onclick="cerrarModalEditar()">Cancelar</button>
                            <asp:Button ID="btn_guardar" runat="server" Text="Guardar Cambios"
                                CssClass="btn-guardar" OnClick="btn_guardar_Click" />
                        </div>
                    </div>
                </div>

            </ContentTemplate>
            <Triggers>
                <asp:PostBackTrigger ControlID="btn_guardar" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        var timerBusqueda;

        function reiniciarTimer() {
            clearTimeout(timerBusqueda);
            timerBusqueda = setTimeout(function () {
                document.getElementById('<%= btn_BuscarOculto.ClientID %>').click();
            }, 400);
        }

        // Restaurar foco después del postback
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

            // Re-bindear modal
            var modalEditar = document.getElementById('modal-editar');
            if (modalEditar) {
                modalEditar.onclick = function (e) {
                    if (e.target === this) cerrarModalEditar();
                };
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
                    infoDiv.innerHTML = '<span style="color: #e74c3c;">❌ Tipo de archivo no permitido</span>';
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

        // ============ MODAL EDITAR ============
        function abrirModalEditar() {
            const modal = document.getElementById('modal-editar');
            if (modal) {
                modal.classList.add('activo');
            }
        }

        function cerrarModalEditar() {
            const modal = document.getElementById('modal-editar');
            const hidden = document.getElementById('<%= hf_CuentaID_Editar.ClientID %>');

            if (hidden) {
                hidden.value = 0;
            }

            if (modal) {
                modal.classList.remove('activo');
            }

            const infoDiv = document.getElementById('info-archivo');
            if (infoDiv) {
                infoDiv.style.display = 'none';
                infoDiv.innerHTML = '';
            }
        }

        // Cerrar al click fuera
        window.addEventListener('DOMContentLoaded', function () {
            var modalEditar = document.getElementById('modal-editar');
            if (modalEditar) {
                modalEditar.addEventListener('click', function (e) {
                    if (e.target === this) cerrarModalEditar();
                });
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/notyf@3/notyf.min.js"></script>
    <script>
        var notyf = new Notyf({
            duration: 4000,
            position: { x: 'center', y: 'top' },
            dismissible: true
        });
    </script>

    <style>
        .info-usuario-box {
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .info-item {
            display: flex;
            gap: 10px;
        }

        .info-label {
            font-weight: 600;
            color: #6c757d;
        }

        .info-valor {
            color: #212529;
        }

        .perfil-badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
        }

        .perfil-completo {
            background-color: #d4edda;
            color: #155724;
        }

        .perfil-incompleto {
            background-color: #fff3cd;
            color: #856404;
        }

        .texto-vacio {
            color: #adb5bd;
            font-style: italic;
        }
    </style>
</asp:Content>
