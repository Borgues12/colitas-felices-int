<%@ Page Async="true" Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="recuperarPassword.aspx.cs" Inherits="colitas_felices.src.webform.login.recuperarPassword" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Recuperar Contraseña - Colitas Felices
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">
     <div class="page-container">

        <asp:Label ID="lblMensaje" runat="server" Visible="false" />

        <%-- PASO 1: Email --%>
        <asp:Panel ID="pnlEmail" runat="server">
            <h2>Recuperar contraseña</h2>
            <p>Ingresa tu correo y te enviaremos un código.</p>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" />
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="El correo es requerido"
                Display="Dynamic" />
            <asp:Button ID="btnEnviar" runat="server" Text="Enviar código"
                OnClick="btnEnviar_Click" />
        </asp:Panel>

        <%-- PASO 2: Código --%>
        <asp:Panel ID="pnlCodigo" runat="server" Visible="false">
            <h2>Verificar código</h2>
            <p>Ingresa el código de 6 dígitos enviado a tu correo.</p>
            <asp:TextBox ID="txtCodigo" runat="server" MaxLength="6" />
            <asp:RequiredFieldValidator ID="rfvCodigo" runat="server"
                ControlToValidate="txtCodigo"
                ErrorMessage="El código es requerido"
                Display="Dynamic" />
            <asp:Button ID="btnVerificar" runat="server" Text="Verificar"
                OnClick="btnVerificar_Click" />
        </asp:Panel>

        <%-- PASO 3: Nueva contraseña --%>
        <asp:Panel ID="pnlPassword" runat="server" Visible="false">
            <h2>Nueva contraseña</h2>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                ControlToValidate="txtPassword"
                ErrorMessage="La contraseña es requerida"
                Display="Dynamic" />
            <asp:TextBox ID="txtConfirm" runat="server" TextMode="Password" />
            <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                ControlToValidate="txtConfirm"
                ErrorMessage="Confirma tu contraseña"
                Display="Dynamic" />
            <asp:CompareValidator ID="cvPassword" runat="server"
                ControlToValidate="txtConfirm"
                ControlToCompare="txtPassword"
                ErrorMessage="Las contraseñas no coinciden"
                Display="Dynamic" />
            <asp:Button ID="btnCambiar" runat="server" Text="Cambiar contraseña"
                OnClick="btnCambiar_Click" />
        </asp:Panel>

        <br />
        <a href="/iniciar_sesion">Volver al inicio de sesión</a>

    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
