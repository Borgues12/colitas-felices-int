<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="fr_adopta.aspx.cs" Inherits="colitas_felices.src.webform.admin.fr_mascotas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Mascotas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <h2>Mascotas</h2>

    <%-- FILTROS --%>
    <div>
        <asp:DropDownList ID="ddlEspecie" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
            <asp:ListItem Value="">Todas las especies</asp:ListItem>
        </asp:DropDownList>

        <asp:DropDownList ID="ddlEstado" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
            <asp:ListItem Value="">Todos los estados</asp:ListItem>
        </asp:DropDownList>

        <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Buscar por nombre..." />
        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" OnClick="btnLimpiar_Click" />
    </div>

    <br />

    <%-- MENSAJE DE RESULTADO --%>
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <%-- TABLA --%>
    <asp:GridView ID="gvMascotas" runat="server"
        AutoGenerateColumns="false"
        DataKeyNames="MascotaID"
        OnRowCommand="gvMascotas_RowCommand"
        EmptyDataText="No se encontraron mascotas.">
        <Columns>

            <asp:BoundField DataField="Nombre"        HeaderText="Nombre" />
            <asp:BoundField DataField="EspecieNombre" HeaderText="Especie" />
            <asp:BoundField DataField="RazaNombre"    HeaderText="Raza" />
            <asp:BoundField DataField="SexoTexto"     HeaderText="Sexo" />
            <asp:BoundField DataField="TamanioTexto"  HeaderText="Tamaño" />
            <asp:BoundField DataField="EstadoNombre"  HeaderText="Estado" />
            <asp:BoundField DataField="EdadAproximada" HeaderText="Edad" />

            <asp:TemplateField HeaderText="Foto">
                <ItemTemplate>
                    <asp:Image ID="imgFoto" runat="server"
                        ImageUrl='<%# string.IsNullOrEmpty(Eval("FotoPrincipalUrl") as string) ? "~/img/sin-foto.png" : Eval("FotoPrincipalUrl") %>'
                        Width="60px" Height="60px" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="Editar"
                        CommandArgument='<%# Eval("MascotaID") %>'>Editar</asp:LinkButton>
                    &nbsp;|&nbsp;
                    <asp:LinkButton runat="server" CommandName="Ver"
                        CommandArgument='<%# Eval("MascotaID") %>'>Ver</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>

    <br />

    <%-- PAGINACIÓN --%>
    <asp:Button ID="btnAnterior" runat="server" Text="&lt; Anterior" OnClick="btnAnterior_Click" />
    <asp:Label  ID="lblPagina"   runat="server" />
    <asp:Button ID="btnSiguiente" runat="server" Text="Siguiente &gt;" OnClick="btnSiguiente_Click" />

    <br /><br />

    <asp:Button ID="btnNueva" runat="server" Text="+ Nueva mascota" OnClick="btnNueva_Click" />

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
