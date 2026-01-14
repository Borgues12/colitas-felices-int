<%@ Page Title="" Language="C#" MasterPageFile="~/src/webform/panelUsuario.Master" AutoEventWireup="true" CodeBehind="pa_main.aspx.cs" Inherits="colitas_felices.src.webform.padrino.pa_main" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <asp:Label ID="Label1" runat="server" Text="Label">USUARIO</asp:Label>
<asp:Button ID="Logout" runat="server" Text="CERRAR SESION" OnClick="Logout_Click" />
</asp:Content>
