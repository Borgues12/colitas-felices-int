<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PruebaBlob.aspx.cs" Inherits="colitas_felices.src.PruebaBlob" Async="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Prueba de Azure Blob Storage - Colitas Felices</h2>

        <%-- SUBIR FOTO --%>
        <div>
            <h3>Subir foto de mascota</h3>
            <asp:FileUpload ID="fileUploadFoto" runat="server" accept=".jpg,.jpeg,.png,.webp" />
            <br />
            <br />
            <asp:Button ID="btnSubir" runat="server" Text="Subir Foto" OnClick="btnSubir_Click" />
            <br />
            <br />
            <asp:Label ID="lblMensaje" runat="server" />
            <br />
            <asp:Image ID="imgPreview" runat="server" Visible="false" Width="300" />
        </div>

        <hr />

        <%-- LISTAR FOTOS --%>
        <div>
            <h3>Fotos almacenadas</h3>
            <asp:Button ID="btnListar" runat="server" Text="Ver Fotos" OnClick="btnListar_Click" />
            <br />
            <br />
            <asp:Repeater ID="rptFotos" runat="server">
                <ItemTemplate>
                    <div style="display: inline-block; margin: 10px; text-align: center;">
                        <asp:Image ID="imgFoto" runat="server"
                            ImageUrl='<%# Eval("Url") %>' Width="200" />
                        <br />
                        <small><%# Eval("Nombre") %></small>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>
