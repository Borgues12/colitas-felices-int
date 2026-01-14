<%@ Page Title="" Language="C#" MasterPageFile="~/src/index.Master" AutoEventWireup="true" CodeBehind="registro.aspx.cs" Inherits="colitas_felices.src.webform.registro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Completar Perfil - Colitas Felices</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 14px;
        }
        .btn {
            width: 100%;
            padding: 12px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        .info-box {
            background-color: #e7f3ff;
            border: 1px solid #b3d7ff;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        .required {
            color: red;
        }
        .mensaje-error {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
        <div class="container">
            <h2>🐾 Completar Perfil</h2>
            <p class="subtitle">Por favor completa tu información para continuar</p>
            
            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mensaje-error">
                <asp:Label ID="lblMensaje" runat="server"></asp:Label>
            </asp:Panel>
            
            <div class="info-box">
                <strong>Email:</strong> <asp:Label ID="lblEmail" runat="server"></asp:Label><br />
            </div>
            
            <div class="form-group">
                <label>Cédula <span class="required">*</span></label>
                <asp:TextBox ID="txtCedula" runat="server" CssClass="form-control" 
                    MaxLength="10" placeholder="Ej: 1712345678"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Nombres <span class="required">*</span></label>
                <asp:TextBox ID="txtNombres" runat="server" CssClass="form-control" 
                    MaxLength="100" placeholder="Tus nombres"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Apellidos <span class="required">*</span></label>
                <asp:TextBox ID="txtApellidos" runat="server" CssClass="form-control" 
                    MaxLength="100" placeholder="Tus apellidos"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Teléfono <span class="required">*</span></label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" 
                    MaxLength="10" placeholder="Ej: 0991234567"></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" 
                    TextMode="MultiLine" Rows="2" placeholder="Tu dirección (opcional)"></asp:TextBox>
            </div>
            
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar y Continuar" 
                CssClass="btn" OnClick="btnGuardar_Click" />
            
            <asp:Button ID="btnOmitir" runat="server" Text="Omitir por ahora" 
                CssClass="btn btn-secondary" OnClick="btnOmitir_Click" />
        </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
