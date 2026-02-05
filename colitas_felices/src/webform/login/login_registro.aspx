<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master"
    AutoEventWireup="true" CodeBehind="login_registro.aspx.cs"
    Inherits="colitas_felices.src.login_registro" Async="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Registro - Colitas Felices</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />
    <link rel="stylesheet" href='<%=ResolveUrl("~/src/css/login/login_registro_style.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="page-container">
        <div class="card">
            <div class="card-bg login" id="cardBg"></div>

            <!-- ==================== HERO REGISTER ==================== -->
            <div class="hero register" id="heroRegister">
                <h2>¿Ya tienes cuenta?</h2>
                <p>Inicia sesión para continuar ayudando a nuestras mascotas.</p>
                <button type="button" class="btn-hero" onclick="toggleView()">INICIAR SESIÓN</button>
            </div>

            <!-- ==================== FORM REGISTER ==================== -->
            <div class="form-section register" id="formRegister">
                <h2>Crear Cuenta</h2>

                <div class="sso">
                    <asp:LinkButton ID="btnGoogle" runat="server" CssClass="btn-google"
                        OnClick="btnGoogle_Click" CausesValidation="false">
                        <i class="fa-brands fa-google"></i>
    </asp:LinkButton>

                </div>

                <p class="text-muted">O usa tu correo electrónico</p>

                <div class="form-inner">
                    <!-- PASO 1: Datos Personales -->
                    <asp:Panel ID="pnlPaso1" runat="server" CssClass="panel active">
                        <span class="step-indicator">Paso 1 de 2 - Datos Personales</span>

                        <asp:TextBox ID="txtNombre" runat="server" placeholder="Nombre *" MaxLength="50" />
                        <asp:TextBox ID="txtApellido" runat="server" placeholder="Apellido *" MaxLength="50" />
                        <asp:TextBox ID="txtCedula" runat="server" placeholder="Cédula (opcional)" MaxLength="20" />
                        <asp:TextBox ID="txtTelefono" runat="server" placeholder="Teléfono (opcional)" MaxLength="20" />

                        <asp:Button ID="btnSiguiente" runat="server" Text="SIGUIENTE"
                            CssClass="btn-next" OnClick="btnSiguiente_Click" />
                    </asp:Panel>

                    <!-- PASO 2: Datos de Cuenta -->
                    <asp:Panel ID="pnlPaso2" runat="server" CssClass="panel">
                        <span class="step-indicator">Paso 2 de 2 - Datos de Cuenta</span>

                        <asp:TextBox ID="txtEmail" runat="server" placeholder="Correo electrónico *"
                            TextMode="Email" MaxLength="150" />
                        <asp:TextBox ID="txtPassword" runat="server" placeholder="Contraseña *"
                            TextMode="Password" MaxLength="50" />
                        <asp:TextBox ID="txtConfirmar" runat="server" placeholder="Confirmar contraseña *"
                            TextMode="Password" MaxLength="50" />

                        <div class="check-group">
                            <asp:CheckBox ID="chkTerminos" runat="server" />
                            <span>Acepto los <a href="#">términos y condiciones</a></span>
                        </div>

                        <div class="btn-group">
                            <asp:Button ID="btnAtras" runat="server" Text="ATRÁS"
                                CssClass="btn-back" OnClick="btnAtras_Click" CausesValidation="false" />
                            <asp:Button ID="btnRegistrar" runat="server" Text="REGISTRAR"
                                CssClass="btn-submit" OnClick="btnRegistrar_Click" />
                        </div>
                    </asp:Panel>
                </div>
            </div>

            <!-- ==================== HERO LOGIN ==================== -->
            <div class="hero login active" id="heroLogin">
                <h2>¡Hola de nuevo!</h2>
                <p>Únete a nuestra comunidad y ayuda a encontrar hogares para mascotas.</p>
                <button type="button" class="btn-hero" onclick="toggleView()">REGISTRARSE</button>
            </div>

            <!-- ==================== FORM LOGIN ==================== -->
            <div class="form-section login active" id="formLogin">
                <h2>Iniciar Sesión</h2>

                <div class="sso">
                     <asp:LinkButton ID="btnGoogleLogin" runat="server" CssClass="btn-google" 
                        OnClick="btnGoogle_Click" CausesValidation="false">
                        <i class="fa-brands fa-google"></i>
                    </asp:LinkButton>
                </div>

                <p class="text-muted">O usa tu correo electrónico</p>

                <div class="form-inner">
                    <asp:TextBox ID="txtEmailLogin" runat="server" placeholder="Correo electrónico"
                        TextMode="Email" MaxLength="150" />
                    <asp:TextBox ID="txtPasswordLogin" runat="server" placeholder="Contraseña"
                        TextMode="Password" MaxLength="50" />

                    <a href="recuperar.aspx" class="link-forgot">¿Olvidaste tu contraseña?</a>

                    <asp:Button ID="btnLogin" runat="server" Text="INGRESAR"
                        CssClass="btn-submit" OnClick="btnLogin_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        const heroLogin = document.getElementById('heroLogin');
        const heroRegister = document.getElementById('heroRegister');
        const formLogin = document.getElementById('formLogin');
        const formRegister = document.getElementById('formRegister');
        const cardBg = document.getElementById('cardBg');

        function toggleView() {
            const isLoginActive = heroLogin.classList.contains('active');

            cardBg.classList.toggle('login', !isLoginActive);

            heroLogin.classList.toggle('active');
            heroRegister.classList.toggle('active');
            formLogin.classList.toggle('active');
            formRegister.classList.toggle('active');
        }
    </script>
</asp:Content>
