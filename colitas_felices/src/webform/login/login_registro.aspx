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
                <div class="hero-content">
                    <h2>¿Ya tienes cuenta?</h2>
                    <p>Inicia sesión para continuar ayudando a nuestras mascotas.</p>
                    <button type="button" class="btn-hero" onclick="toggleView()">
                        <i class="fas fa-sign-in-alt"></i> INICIAR SESIÓN
                    </button>
                </div>
            </div>

            <!-- ==================== FORM REGISTER ==================== -->
            <div class="form-section register" id="formRegister">
                <div class="form-inner">
                    <div class="form-header">
                        <h2>Crear Cuenta</h2>
                        <p class="form-subtitle">Únete a nuestra comunidad</p>
                    </div>

                    <!-- Google SSO -->
                    <div class="sso">
                        <asp:LinkButton ID="btnGoogle" runat="server" CssClass="btn-google"
                            OnClick="btnGoogle_Click" CausesValidation="false">
                            <i class="fa-brands fa-google"></i>
                            <span>Continuar con Google</span>
                        </asp:LinkButton>
                    </div>

                    <div class="divider">
                        <span>o completa el formulario</span>
                    </div>

                    <asp:HiddenField ID="hdnVistaActual" runat="server" Value="login" />
                    <!-- FORMULARIO DE REGISTRO -->
                    <asp:Panel ID="pnlRegistro" runat="server" CssClass="panel active">
                        
                        <!-- ═══════════════════════════════════════ -->
                        <!-- SECCIÓN 1: DATOS PERSONALES -->
                        <!-- ═══════════════════════════════════════ -->
                        <div class="form-section-group">
                            <div class="section-header">
                                <i class="fas fa-user"></i>
                                <span>Datos Personales</span>
                            </div>

                            <!-- Fila: Primer y Segundo Nombre -->
                            <div class="input-row">
                                <div class="input-group">
                                    <asp:TextBox ID="txtPrimerNombre" runat="server"
                                        placeholder=" "
                                        MaxLength="40"
                                        CssClass="input-field" />
                                    <label class="input-label">Primer Nombre *</label>
                                </div>

                                <div class="input-group">
                                    <asp:TextBox ID="txtSegundoNombre" runat="server"
                                        placeholder=" "
                                        MaxLength="40"
                                        CssClass="input-field" />
                                    <label class="input-label">Segundo Nombre</label>
                                </div>
                            </div>

                            <!-- Fila: Primer y Segundo Apellido -->
                            <div class="input-row">
                                <div class="input-group">
                                    <asp:TextBox ID="txtPrimerApellido" runat="server"
                                        placeholder=" "
                                        MaxLength="40"
                                        CssClass="input-field" />
                                    <label class="input-label">Primer Apellido *</label>
                                </div>

                                <div class="input-group">
                                    <asp:TextBox ID="txtSegundoApellido" runat="server"
                                        placeholder=" "
                                        MaxLength="40"
                                        CssClass="input-field" />
                                    <label class="input-label">Segundo Apellido</label>
                                </div>
                            </div>

                            <!-- Teléfono (ancho completo) -->
                            <div class="input-group full-width">
                                <i class="fas fa-phone input-icon"></i>
                                <asp:TextBox ID="txtTelefono" runat="server"
                                    placeholder=" "
                                    MaxLength="15"
                                    CssClass="input-field with-icon" />
                                <label class="input-label with-icon">Teléfono (opcional)</label>
                            </div>
                        </div>

                        <!-- ═══════════════════════════════════════ -->
                        <!-- SECCIÓN 2: DATOS DE CUENTA -->
                        <!-- ═══════════════════════════════════════ -->
                        <div class="form-section-group">
                            <div class="section-header">
                                <i class="fas fa-lock"></i>
                                <span>Datos de Cuenta</span>
                            </div>

                            <!-- Email -->
                            <div class="input-group full-width">
                                <i class="fas fa-envelope input-icon"></i>
                                <asp:TextBox ID="txtEmail" runat="server"
                                    placeholder=" "
                                    TextMode="Email"
                                    MaxLength="150"
                                    CssClass="input-field with-icon" />
                                <label class="input-label with-icon">Correo electrónico *</label>
                            </div>

                            <!-- Fila: Contraseña y Confirmar -->
                            <div class="input-row">
                                <div class="input-group">
                                    <i class="fas fa-key input-icon"></i>
                                    <asp:TextBox ID="txtPassword" runat="server"
                                        placeholder=" "
                                        TextMode="Password"
                                        MaxLength="50"
                                        CssClass="input-field with-icon" />
                                    <label class="input-label with-icon">Contraseña *</label>
                                </div>

                                <div class="input-group">
                                    <i class="fas fa-check-double input-icon"></i>
                                    <asp:TextBox ID="txtConfirmar" runat="server"
                                        placeholder=" "
                                        TextMode="Password"
                                        MaxLength="50"
                                        CssClass="input-field with-icon" />
                                    <label class="input-label with-icon">Confirmar *</label>
                                </div>
                            </div>

                            <!-- Requisitos de contraseña -->
                            <div class="password-hints">
                                <div class="hint" id="hintLength">
                                    <i class="fas fa-circle"></i> Mínimo 8 caracteres
                                </div>
                                <div class="hint" id="hintUpper">
                                    <i class="fas fa-circle"></i> Una mayúscula
                                </div>
                                <div class="hint" id="hintLower">
                                    <i class="fas fa-circle"></i> Una minúscula
                                </div>
                                <div class="hint" id="hintNumber">
                                    <i class="fas fa-circle"></i> Un número
                                </div>
                            </div>
                        </div>

                        <!-- ═══════════════════════════════════════ -->
                        <!-- TÉRMINOS Y BOTÓN -->
                        <!-- ═══════════════════════════════════════ -->
                        <div class="form-footer">
                            <div class="check-group">
                                <asp:CheckBox ID="chkTerminos" runat="server" />
                                <label for="<%= chkTerminos.ClientID %>">
                                    Acepto los <a href="#" target="_blank">términos y condiciones</a> 
                                    y la <a href="#" target="_blank">política de privacidad</a>
                                </label>
                            </div>

                            <asp:Button ID="btnRegistrar" runat="server"
                                Text="CREAR MI CUENTA"
                                CssClass="btn-submit"
                                OnClick="btnRegistrar_Click" />

                            <p class="switch-form mobile-only">
                                ¿Ya tienes cuenta? 
                                <a href="javascript:void(0)" class="toggle-link" onclick="toggleView()">Inicia sesión</a>
                            </p>
                        </div>

                    </asp:Panel>
                </div>
            </div>

            <!-- ==================== HERO LOGIN ==================== -->
            <div class="hero login active" id="heroLogin">
                <div class="hero-content">
                    <div class="hero-icon">🏠</div>
                    <h2>¡Hola de nuevo!</h2>
                    <p>Únete a nuestra comunidad y ayuda a encontrar hogares para mascotas.</p>
                    <button type="button" class="btn-hero" onclick="toggleView()">
                        <i class="fas fa-user-plus"></i> REGISTRARSE
                    </button>
                </div>
            </div>

            <!-- ==================== FORM LOGIN ==================== -->
            <div class="form-section login active" id="formLogin">
                <div class="form-inner">
                    <div class="form-header">
                        <h2>Iniciar Sesión</h2>
                        <p class="form-subtitle">Bienvenido de vuelta</p>
                    </div>

                    <!-- Google SSO -->
                    <div class="sso">
                        <asp:LinkButton ID="btnGoogleLogin" runat="server" CssClass="btn-google"
                            OnClick="btnGoogle_Click" CausesValidation="false">
                            <i class="fa-brands fa-google"></i>
                            <span>Continuar con Google</span>
                        </asp:LinkButton>
                    </div>

                    <div class="divider">
                        <span>o usa tu correo</span>
                    </div>

                    <!-- FORMULARIO LOGIN -->
                    <div class="login-form">
                        <div class="input-group full-width">
                            <i class="fas fa-envelope input-icon"></i>
                            <asp:TextBox ID="txtEmailLogin" runat="server"
                                placeholder=" "
                                TextMode="Email"
                                MaxLength="150"
                                CssClass="input-field with-icon" />
                            <label class="input-label with-icon">Correo electrónico</label>
                        </div>

                        <div class="input-group full-width">
                            <i class="fas fa-lock input-icon"></i>
                            <asp:TextBox ID="txtPasswordLogin" runat="server"
                                placeholder=" "
                                TextMode="Password"
                                MaxLength="50"
                                CssClass="input-field with-icon" />
                            <label class="input-label with-icon">Contraseña</label>
                            <button type="button" class="toggle-password" onclick="togglePassword(this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>

                        <div class="login-options">
                            <div class="remember-me">
                                <input type="checkbox" id="chkRecordar" />
                                <label for="chkRecordar">Recordarme</label>
                            </div>
                            <a href="recuperar.aspx" class="link-forgot">¿Olvidaste tu contraseña?</a>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" 
                            Text="INGRESAR"
                            CssClass="btn-submit" 
                            OnClick="btnLogin_Click" />

                        <p class="switch-form mobile-only">
                            ¿No tienes cuenta? 
                            <a href="javascript:void(0)" class="toggle-link" onclick="toggleView()">Regístrate</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // ═══════════════════════════════════════════════════════════
        // ELEMENTOS DEL DOM
        // ═══════════════════════════════════════════════════════════
        const heroLogin = document.getElementById('heroLogin');
        const heroRegister = document.getElementById('heroRegister');
        const formLogin = document.getElementById('formLogin');
        const formRegister = document.getElementById('formRegister');
        const cardBg = document.getElementById('cardBg');
        const hdnVistaActual = document.getElementById('<%= hdnVistaActual.ClientID %>');

        // ═══════════════════════════════════════════════════════════
        // RESTAURAR VISTA AL CARGAR (después de PostBack)
        // ═══════════════════════════════════════════════════════════
        document.addEventListener('DOMContentLoaded', function () {
            const vistaGuardada = hdnVistaActual.value;

            if (vistaGuardada === 'registro') {
                mostrarRegistro();
            } else {
                mostrarLogin();
            }
        });

        // ═══════════════════════════════════════════════════════════
        // FUNCIONES PARA CAMBIAR VISTA
        // ═══════════════════════════════════════════════════════════
        function mostrarRegistro() {
            cardBg.classList.remove('login');
            heroLogin.classList.remove('active');
            heroRegister.classList.add('active');
            formLogin.classList.remove('active');
            formRegister.classList.add('active');
            hdnVistaActual.value = 'registro';
        }

        function mostrarLogin() {
            cardBg.classList.add('login');
            heroLogin.classList.add('active');
            heroRegister.classList.remove('active');
            formLogin.classList.add('active');
            formRegister.classList.remove('active');
            hdnVistaActual.value = 'login';
        }

        function toggleView() {
            const isLoginActive = heroLogin.classList.contains('active');

            if (isLoginActive) {
                mostrarRegistro();
            } else {
                mostrarLogin();
            }

            // Guardar estado en HiddenField
            if (hdnVistaActual) {
                hdnVistaActual.value = isLoginActive ? 'registro' : 'login';
            }

            // Scroll al inicio del formulario de registro
            if (!isLoginActive) {
                formRegister.scrollTop = 0;
            }
        }

        // ═══════════════════════════════════════════════════════════
        // VALIDACIÓN DE CONTRASEÑA EN TIEMPO REAL
        // ═══════════════════════════════════════════════════════════
        const passwordField = document.getElementById('<%= txtPassword.ClientID %>');

        if (passwordField) {
            passwordField.addEventListener('input', function () {
                const password = this.value;

                toggleHint('hintLength', password.length >= 8);
                toggleHint('hintUpper', /[A-Z]/.test(password));
                toggleHint('hintLower', /[a-z]/.test(password));
                toggleHint('hintNumber', /[0-9]/.test(password));
            });

            // Validar también al cargar si ya tiene valor
            if (passwordField.value) {
                passwordField.dispatchEvent(new Event('input'));
            }
        }

        function toggleHint(hintId, isValid) {
            const hint = document.getElementById(hintId);
            if (hint) {
                hint.classList.toggle('valid', isValid);
                hint.querySelector('i').className = isValid ? 'fas fa-check-circle' : 'fas fa-circle';
            }
        }

        // ═══════════════════════════════════════════════════════════
        // MOSTRAR/OCULTAR CONTRASEÑA
        // ═══════════════════════════════════════════════════════════
        function togglePassword(button) {
            const container = button.closest('.input-group');
            const input = container.querySelector('input[type="password"], input[type="text"]');
            const icon = button.querySelector('i');

            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }

        // ═══════════════════════════════════════════════════════════
        // ANIMACIÓN DE LABELS FLOTANTES
        // ═══════════════════════════════════════════════════════════
        function initFloatingLabels() {
            document.querySelectorAll('.input-field').forEach(input => {
                // Verificar si ya tiene valor al cargar
                if (input.value) {
                    input.classList.add('has-value');
                }

                input.addEventListener('focus', function () {
                    this.classList.add('has-value');
                });

                input.addEventListener('blur', function () {
                    if (!this.value) {
                        this.classList.remove('has-value');
                    }
                });

                input.addEventListener('input', function () {
                    if (this.value) {
                        this.classList.add('has-value');
                    }
                });
            });
        }

        // Inicializar labels flotantes
        initFloatingLabels();

        // ═══════════════════════════════════════════════════════════
        // PREVENIR SUBMIT CON ENTER EN CAMPOS INCORRECTOS (opcional)
        // ═══════════════════════════════════════════════════════════
        document.querySelectorAll('.input-field').forEach(input => {
            input.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    // Si estamos en el formulario de registro
                    if (this.closest('#formRegister')) {
                        const btnRegistrar = document.getElementById('<%= btnRegistrar.ClientID %>');
                        if (btnRegistrar) {
                            e.preventDefault();
                            btnRegistrar.click();
                        }
                    }
                    // Si estamos en el formulario de login
                    if (this.closest('#formLogin')) {
                        const btnLogin = document.getElementById('<%= btnLogin.ClientID %>');
                        if (btnLogin) {
                            e.preventDefault();
                            btnLogin.click();
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
