<%@ Page Title="Iniciar Sesión" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="colitas_felices.main" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="head" runat="server">
    <%-- Google Fonts --%>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

    <link href='<%=ResolveUrl("~/src/css/login_styles.css")%>' rel="stylesheet" />
    <%-- Iconos --%>
    <script src="https://code.iconify.design/iconify-icon/2.1.0/iconify-icon.min.js"></script>

</asp:Content>

<asp:Content ID="contentBody" ContentPlaceHolderID="body" runat="server">
    
    <div class="login-page">
        <!-- ===== LADO IZQUIERDO ===== -->
        <div class="login-left">
            <div class="login-left-content">
                <div class="logo-welcome">
                    <img src='<%=ResolveUrl("~/src/images/logo-colitas.png") %>' alt="Colitas Felices" class="logo-img" onerror="this.style.display='none'" />
                </div>
                <h1>¡Bienvenido a<br/><span>Colitas Felices!</span></h1>
                <p>Únete a nuestra comunidad y ayuda a darle un hogar a quienes más lo necesitan.</p>
                
                <div class="features">
                    <div class="feature-item">
                        <iconify-icon icon="fa6-solid:heart" width="20"></iconify-icon>
                        <span>Adopta con amor</span>
                    </div>
                    <div class="feature-item">
                        <iconify-icon icon="fa6-solid:hand-holding-heart" width="20"></iconify-icon>
                        <span>Dona y transforma vidas</span>
                    </div>
                    <div class="feature-item">
                        <iconify-icon icon="fa6-solid:users" width="20"></iconify-icon>
                        <span>Sé parte del cambio</span>
                    </div>
                </div>
            </div>
            
            <div class="paw-prints">
                <iconify-icon icon="fa6-solid:paw" class="paw paw-1"></iconify-icon>
                <iconify-icon icon="fa6-solid:paw" class="paw paw-2"></iconify-icon>
                <iconify-icon icon="fa6-solid:paw" class="paw paw-3"></iconify-icon>
            </div>
        </div>
        
        <!-- ===== LADO DERECHO ===== -->
        <div class="login-right">
            <asp:UpdatePanel runat="server">
                <ContentTemplate>
                    <div class="login-box">
                        <!-- Header -->
                        <div class="login-header">
                            <div class="login-icon">
                                <iconify-icon icon="fa6-solid:paw" width="28"></iconify-icon>
                            </div>
                            <h2>Iniciar Sesión</h2>
                            <p class="login-subtitle">Ingresa tus credenciales para continuar</p>
                        </div>
                        
                        <!-- Email -->
                        <div class="input-group">
                            <label>
                                <iconify-icon icon="fa6-solid:envelope" width="16"></iconify-icon>
                                Correo electrónico
                            </label>
                            <asp:TextBox 
                                ID="txt_email" 
                                runat="server" 
                                placeholder="ejemplo@correo.com"
                                CssClass="input-field">
                            </asp:TextBox>
                        </div>

                        <!-- Password -->
                        <div class="input-group">
                            <label>
                                <iconify-icon icon="fa6-solid:lock" width="16"></iconify-icon>
                                Contraseña
                            </label>
                            <div class="password-container">
                                <asp:TextBox 
                                    ID="txt_password" 
                                    runat="server" 
                                    TextMode="Password" 
                                    placeholder="••••••••" 
                                    ClientIDMode="Static"
                                    CssClass="input-field">
                                </asp:TextBox>
                                <button type="button" class="toggle-password" onclick="togglePassword()">
                                    <iconify-icon icon="fa6-solid:eye" id="eyeIcon" width="20"></iconify-icon>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Opciones -->
                        <div class="login-options">
                            <label class="remember-me">
                                <input type="checkbox" id="chkRecordar" />
                                Recordarme
                            </label>
                            <a href="RecuperarPassword.aspx" class="forgot-link">¿Olvidaste tu contraseña?</a>
                        </div>

                        <!-- Botón Login -->
                        <asp:Button 
                            ID="btn_login" 
                            runat="server" 
                            Text="Iniciar Sesión" 
                            CssClass="btn-primary" 
                            OnClick="login_button" />

                        <!-- Divisor -->
                        <div class="divider">
                            <span>o continúa con</span>
                        </div>

                        <!-- Google -->
                        <asp:Button
                            ID="btnGoogle"
                            runat="server"
                            Text="Google"
                            CssClass="btn-google"
                            OnClick="btnGoogle_Click" />
                        
                        <!-- Footer -->
                        <div class="login-footer">
                            <p>¿No tienes una cuenta? <a href="Registro.aspx">Regístrate aquí</a></p>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:PostBackTrigger ControlID="btnGoogle" />
                </Triggers>
            </asp:UpdatePanel>
        </div>
    </div>
    
</asp:Content>

<asp:Content ID="contentScripts" ContentPlaceHolderID="scripts" runat="server">
    <script>
        function togglePassword() {
            var input = document.getElementById('txt_password');
            var icon = document.getElementById('eyeIcon');
            if (input.type === 'password') {
                input.type = 'text';
                icon.setAttribute('icon', 'fa6-solid:eye-slash');
            } else {
                input.type = 'password';
                icon.setAttribute('icon', 'fa6-solid:eye');
            }
        }
    </script>
</asp:Content>
