<%@ Page Title="Cuentas" Language="C#" MasterPageFile="~/src/masterPage/panel.Master"
    AutoEventWireup="true" CodeBehind="view_cuentas.aspx.cs"
    Inherits="colitas_felices.src.webform.admin.Cuentas.view_cuentas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href='<%= ResolveUrl("~/src/css/cuentas/cuentas_style.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- ============================================================
         HEADER
         ============================================================ --%>
    <div class="cuentas-header">
        <h2 class="cuentas-title">Administración de Cuentas</h2>
    </div>

    <%-- ============================================================
         FILTROS
         ============================================================ --%>
    <div class="cuentas-filtros">
        <div class="filtro-grupo filtro-busqueda">
            <label class="filtro-label">Buscar</label>
            <asp:TextBox ID="txtBusqueda" runat="server"
                placeholder="Nombre, email o cédula..."
                CssClass="filtro-input" />
        </div>

        <div class="filtro-grupo">
            <label class="filtro-label">Rol</label>
            <asp:DropDownList ID="ddlRol" runat="server" CssClass="filtro-select">
                <asp:ListItem Value="" Text="Todos los roles" />
                <asp:ListItem Value="1" Text="Usuario" />
                <asp:ListItem Value="2" Text="Administrador" />
            </asp:DropDownList>
        </div>

        <div class="filtro-grupo">
            <label class="filtro-label">Estado</label>
            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="filtro-select">
                <asp:ListItem Value="" Text="Todos" />
                <asp:ListItem Value="activo" Text="Activo" />
                <asp:ListItem Value="bloqueado" Text="Bloqueado" />
                <asp:ListItem Value="inactivo" Text="Inactivo" />
            </asp:DropDownList>
        </div>

        <div class="filtro-grupo filtro-acciones">
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar"
                OnClick="btnBuscar_Click" CssClass="btn-filtro btn-filtro--buscar" />
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"
                OnClick="btnLimpiar_Click" CssClass="btn-filtro btn-filtro--limpiar" />
        </div>
    </div>

    <%-- ============================================================
         TABLA DE CUENTAS
         ============================================================ --%>
    <div class="cuentas-tabla-wrapper">
        <asp:Repeater ID="rptCuentas" runat="server" OnItemCommand="rptCuentas_ItemCommand">
            <HeaderTemplate>
                <table class="cuentas-tabla">
                    <thead>
                        <tr>
                            <th>Nombre</th>
                            <th>Email</th>
                            <th>Cédula</th>
                            <th>Teléfono</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th>Último acceso</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td><%# Eval("NombreCompleto") %></td>
                    <td><%# Eval("Email") %></td>
                    <td><%# Eval("NumeroIdentificacion") %></td>
                    <td><%# Eval("TelefonoPrincipal") %></td>
                    <td>
                        <span class='rol-badge <%# Convert.ToByte(Eval("RolID")) == 2 ? "rol-badge--admin" : "rol-badge--user" %>'>
                            <%# Eval("RolNombre") %>
                        </span>
                    </td>
                    <td>
                        <span class='estado-badge <%# GetEstadoCssClass(Eval("Estado").ToString()) %>'>
                            <%# Eval("EstadoTexto") %>
                        </span>
                    </td>
                    <td><%# Eval("UltimoAcceso") != null ? Eval("UltimoAcceso", "{0:dd/MM/yyyy HH:mm}") : "Nunca" %></td>
                    <td>
                        <asp:LinkButton ID="btnCambiarRol" runat="server"
                            CommandName="CambiarRol"
                            CommandArgument='<%# Eval("CuentaID") %>'
                            CssClass='<%# Convert.ToByte(Eval("RolID")) == 2 ? "btn-rol btn-rol--quitar" : "btn-rol btn-rol--dar" %>'
                            OnClientClick="return confirm('¿Cambiar el rol de este usuario?');">
                            <%# Convert.ToByte(Eval("RolID")) == 2 ? "▼ Quitar Admin" : "▲ Hacer Admin" %>
                        </asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <%-- Mensaje vacío --%>
    <asp:Panel ID="pnlSinResultados" runat="server" Visible="false" CssClass="cuentas-empty">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24"
            fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
        </svg>
        <p>No se encontraron cuentas.</p>
    </asp:Panel>

</asp:Content>
