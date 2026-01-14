<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="test_session.aspx.cs" Inherits="colitas_felices.src.webform.test_session" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Sesión</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Prueba de Sesión</h2>
        
        <asp:Label ID="lblEstado" runat="server" />
        <br /><br />
        
        <asp:Button ID="btnCrearSesion" runat="server" 
                    Text="Crear Sesión de Prueba" 
                    OnClick="btnCrearSesion_Click" />
        
        <asp:Button ID="btnVerSesion" runat="server" 
                    Text="Ver Sesión" 
                    OnClick="btnVerSesion_Click" />
        
        <asp:Button ID="btnEliminarSesion" runat="server" 
                    Text="Eliminar Sesión" 
                    OnClick="btnEliminarSesion_Click" />
    </form>
</body>
</html>