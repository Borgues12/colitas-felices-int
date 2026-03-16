<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/panel.Master" AutoEventWireup="true" CodeBehind="ad_main.aspx.cs" Inherits="colitas_felices.src.webform.admin.ad_main" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div style="display:flex; justify-content:center; align-items:center; height:70vh;">
        <div style="text-align:center; padding:3rem 4rem; border-radius:16px; background:#fff; box-shadow:0 4px 20px rgba(0,0,0,0.08);">
            <i class="mdi mdi-paw" style="font-size:4rem; color:#f59e0b;"></i>
            <h1 style="font-size:1.8rem; margin:1rem 0 0.5rem; color:#1e293b;">Bienvenido al Panel de Administración</h1>
            <p style="color:#64748b; font-size:1rem;">Colitas Felices — Gestiona cuentas, permisos y más desde aquí.</p>
        </div>
    </div>
</asp:Content>