<%@ Page Title="" Language="C#" MasterPageFile="~/src/webform/panel.Master" AutoEventWireup="true" CodeBehind="vol_main.aspx.cs" Inherits="colitas_felices.src.webform.volutario.vol_main" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="Label1" runat="server" Text="Label">VOLUNTARIO</asp:Label>
    <asp:Button ID="Logout" runat="server" Text="Button" OnClick="Logout_Click" />
</asp:Content>
