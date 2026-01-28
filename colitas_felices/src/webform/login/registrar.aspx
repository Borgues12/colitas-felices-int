<%@ Page Title="" Language="C#" 
    Async="true"
    MasterPageFile="~/src/masterPage/index.Master" 
    AutoEventWireup="true" 
    CodeBehind="registrar.aspx.cs" 
    Inherits="colitas_felices.src.registrar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Crear Cuenta - Colitas Felices
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Estilos -->
    <link href='<%=ResolveUrl("~/src/css/registro_style.css") %>' rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">
    <div class="registro-page">

        <!-- ══════════ LADO IZQUIERDO ══════════ -->
        <div class="registro-left">
            <div class="paw-prints">
                <iconify-icon icon="mdi:paw" class="paw paw-1"></iconify-icon>
                <iconify-icon icon="mdi:paw" class="paw paw-2"></iconify-icon>
                <iconify-icon icon="mdi:paw" class="paw paw-3"></iconify-icon>
                <iconify-icon icon="mdi:paw" class="paw paw-4"></iconify-icon>
                <iconify-icon icon="mdi:paw" class="paw paw-5"></iconify-icon>
            </div>

            <div class="registro-left-content">
                <h1>Únete a nuestra <span>familia</span></h1>
                <p>Crea tu cuenta y ayúdanos a darle un hogar a más peluditos</p>

                <div class="benefits">
                    <div class="benefit-item">
                        <iconify-icon icon="mdi:heart"></iconify-icon>
                        <span>Adopta una mascota que te espera</span>
                    </div>
                    <div class="benefit-item">
                        <iconify-icon icon="mdi:hand-heart"></iconify-icon>
                        <span>Apadrina y cambia una vida</span>
                    </div>
                    <div class="benefit-item">
                        <iconify-icon icon="mdi:account-group"></iconify-icon>
                        <span>Sé voluntario en el refugio</span>
                    </div>
                    <div class="benefit-item">
                        <iconify-icon icon="mdi:gift"></iconify-icon>
                        <span>Dona para alimentar a 90+ peludos</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ══════════ LADO DERECHO ══════════ -->
        <div class="registro-right">
            <div class="registro-box">

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>

                        <!-- Header -->
                        <div class="registro-header">
                            <div class="registro-icon">
                                <iconify-icon icon="mdi:account-plus"></iconify-icon>
                            </div>
                            <h2>Crear Cuenta</h2>
                            <p class="registro-subtitle">Completa tus datos para registrarte</p>
                        </div>

                        <!-- Mensaje de resultado -->
                        <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                            <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                        </asp:Panel>

                        <!-- Formulario -->
                        <asp:Panel ID="pnlFormulario" runat="server">

                            <!-- Nombre y Apellido en una fila -->
                            <div class="form-row">
                                <div class="input-group">
                                    <label>
                                        <iconify-icon icon="mdi:account"></iconify-icon>
                                        Nombre
                                       
                                    </label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="input-field"
                                        placeholder="Tu nombre" MaxLength="50"></asp:TextBox>
                                </div>

                                <div class="input-group">
                                    <label>
                                        <iconify-icon icon="mdi:account-outline"></iconify-icon>
                                        Apellido
                                       
                                    </label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="input-field"
                                        placeholder="Tu apellido" MaxLength="50"></asp:TextBox>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="input-group">
                                <label>
                                    <iconify-icon icon="mdi:email"></iconify-icon>
                                    Correo electrónico
                                   
                                </label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="input-field"
                                    TextMode="Email" placeholder="correo@ejemplo.com" MaxLength="100"></asp:TextBox>
                            </div>

                            <!-- Contraseña -->
                            <div class="input-group">
                                <label>
                                    <iconify-icon icon="mdi:lock"></iconify-icon>
                                    Contraseña
                                   
                                </label>
                                <div class="password-container">
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="input-field"
                                        TextMode="Password" placeholder="Mínimo 6 caracteres" MaxLength="50"></asp:TextBox>
                                    <button type="button" class="toggle-password" onclick="togglePassword('txtPassword', this)">
                                        <iconify-icon icon="mdi:eye-off"></iconify-icon>
                                    </button>
                                </div>
                            </div>

                            <!-- Confirmar Contraseña -->
                            <div class="input-group">
                                <label>
                                    <iconify-icon icon="mdi:lock-check"></iconify-icon>
                                    Confirmar contraseña
                                   
                                </label>
                                <div class="password-container">
                                    <asp:TextBox ID="txtConfirmar" runat="server" CssClass="input-field"
                                        TextMode="Password" placeholder="Repite tu contraseña" MaxLength="50"></asp:TextBox>
                                    <button type="button" class="toggle-password" onclick="togglePassword('txtConfirmar', this)">
                                        <iconify-icon icon="mdi:eye-off"></iconify-icon>
                                    </button>
                                </div>
                            </div>

                            <!-- Términos y condiciones -->
                            <div class="terms-check">
                                <asp:CheckBox ID="chkTerminos" runat="server" />
                                <span>Acepto los <a href="#">Términos y Condiciones</a> y la 
                                       
                                    <a href="#">Política de Privacidad</a>
                                </span>
                            </div>

                            <!-- Botón Registrar -->
                            <asp:Button ID="btnRegistrar" runat="server" Text="Crear mi cuenta"
                                CssClass="btn-registro" OnClick="btnRegistrar_Click" />

                            <!-- Divider -->
                            <div class="divider">
                                <span>o regístrate con</span>
                            </div>

                            <!-- Botón Google -->
                            <asp:Button ID="btnGoogle" runat="server" Text="Continuar con Google"
                                CssClass="btn-google" OnClick="btnGoogle_Click" CausesValidation="false" />

                        </asp:Panel>

                        <!-- Footer -->
                        <div class="registro-footer">
                            <p>¿Ya tienes cuenta? <a href="login.aspx">Inicia sesión</a></p>
                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>

                <!-- Loading overlay -->
                <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                    <ProgressTemplate>
                        <div class="loading-overlay show">
                            <div class="spinner"></div>
                            <span class="loading-text">Creando tu cuenta...</span>
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>

            </div>
        </div>

    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
    // Toggle password visibility
        function togglePassword(inputId, btn) {
            var input = document.getElementById('<%= txtPassword.ClientID %>');
            if (inputId === 'txtConfirmar') {
                input = document.getElementById('<%= txtConfirmar.ClientID %>');
            }
            
            var icon = btn.querySelector('iconify-icon');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.setAttribute('icon', 'mdi:eye');
            } else {
                input.type = 'password';
                icon.setAttribute('icon', 'mdi:eye-off');
            }
        }
        
        // Validación en tiempo real (opcional)
        document.addEventListener('DOMContentLoaded', function() {
            var password = document.getElementById('<%= txtPassword.ClientID %>');
            var confirmar = document.getElementById('<%= txtConfirmar.ClientID %>');
            
            if (confirmar) {
                confirmar.addEventListener('input', function() {
                    if (this.value !== password.value && this.value.length > 0) {
                        this.classList.add('error');
                    } else {
                        this.classList.remove('error');
                    }
                });
            }
        });
        </script>
</asp:Content>
