<%@ Page Title="main" Language="C#" MasterPageFile="~/src/index.Master" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="colitas_felices.main" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/login_styles.css") %>' rel="stylesheet" />
    <script src="https://code.iconify.design/iconify-icon/2.1.0/iconify-icon.min.js"></script>
</asp:Content>

<asp:Content ID="contentBody" ContentPlaceHolderID="body" runat="server">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="login-box">
                <h2>Login</h2>

                <asp:TextBox ID="txt_email" runat="server" placeholder="Email"></asp:TextBox>

                <div class="password-container">
                    <asp:TextBox ID="txt_password" runat="server" TextMode="Password" placeholder="Password" ClientIDMode="Static"></asp:TextBox>
                    <button type="button" class="toggle-password" onclick="togglePassword()">
                        <iconify-icon icon="fa6-solid:eye" id="eyeIcon" width="24" height="24"></iconify-icon>
                    </button>
                </div>

                <asp:Button ID="btn_login" runat="server" Text="Entrar" CssClass="btn" OnClick="login_button" />

                <div class="divider">O</div>

                <asp:Button
                    ID="btnGoogle"
                    runat="server"
                    Text="Continuar con Google"
                    CssClass="btn google-btn"
                    OnClick="btnGoogle_Click" />
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnGoogle" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

<asp:Content ID="contentScripts" ContentPlaceHolderID="scripts" runat="server">
    <script src='<%=ResolveUrl("~/src/js/js_login.js") %>'></script>

</asp:Content>
