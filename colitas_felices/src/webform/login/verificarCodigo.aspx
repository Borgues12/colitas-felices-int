<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="verificarCodigo.aspx.cs" Inherits="colitas_felices.src.webform.login.verificarCodigo" Async="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Verificar Cuenta - Colitas Felices</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />
    <link rel="stylesheet" href='<%=ResolveUrl("~/src/css/login/verificarCodigo_style.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="page-container">
        <i class="fas fa-paw paw-decoration paw-1"></i>
        <i class="fas fa-paw paw-decoration paw-2"></i>
        
        <div class="verify-card">
            <div class="verify-icon">
                <i class="fas fa-envelope-open-text"></i>
            </div>
            
            <h2>Verifica tu cuenta</h2>
            <p class="subtitle">Ingresa el código de 6 dígitos que enviamos a:</p>
            
            <div class="email-display">
                <i class="fas fa-envelope"></i>&nbsp;
                <asp:Label ID="lblEmail" runat="server"></asp:Label>
            </div>
            
            <!-- Inputs visuales del código -->
            <div class="code-inputs">
                <input type="text" maxlength="1" class="code-digit" data-index="0" inputmode="numeric" />
                <input type="text" maxlength="1" class="code-digit" data-index="1" inputmode="numeric" />
                <input type="text" maxlength="1" class="code-digit" data-index="2" inputmode="numeric" />
                <input type="text" maxlength="1" class="code-digit" data-index="3" inputmode="numeric" />
                <input type="text" maxlength="1" class="code-digit" data-index="4" inputmode="numeric" />
                <input type="text" maxlength="1" class="code-digit" data-index="5" inputmode="numeric" />
            </div>
            
            <!-- Campo oculto con el código completo -->
            <asp:TextBox ID="txtCodigo" runat="server" CssClass="hidden-code" MaxLength="6" />
            
            <asp:Button ID="btnVerificar" runat="server" Text="VERIFICAR CUENTA" 
                CssClass="btn-verify" OnClick="btnVerificar_Click" />
            
            <!-- Opciones -->
            <div class="options" id="divOpciones">
                <p>¿No recibiste el código?</p>
                <div class="option-links">
                    <asp:Button ID="btnReenviar" runat="server" Text="📧 Reenviar código" 
                        OnClick="btnReenviar_Click" CausesValidation="false" />
                    <button type="button" id="btnMostrarCambio" onclick="mostrarCambioEmail()">
                        ✏️ Cambiar correo electrónico
                    </button>
                </div>
            </div>
            
            <!-- Panel cambiar email -->
            <asp:Panel ID="pnlCambiarEmail" runat="server" CssClass="change-email-panel" Visible="false">
                <h3>Cambiar correo electrónico</h3>
                <asp:TextBox ID="txtNuevoEmail" runat="server" placeholder="Nuevo correo electrónico" 
                    TextMode="Email" MaxLength="150" />
                <div class="btn-group">
                    <asp:Button ID="btnCancelarCambio" runat="server" Text="Cancelar" 
                        CssClass="btn-secondary" OnClick="btnCancelarCambio_Click" CausesValidation="false" />
                    <asp:Button ID="btnConfirmarCambio" runat="server" Text="Cambiar y enviar" 
                        CssClass="btn-primary" OnClick="btnConfirmarCambio_Click" />
                </div>
            </asp:Panel>
            
            <a href="/registrarse" class="back-link">
                <i class="fas fa-arrow-left"></i> Volver al registro
            </a>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // Manejo de inputs del código
        const codeDigits = document.querySelectorAll('.code-digit');
        const hiddenInput = document.getElementById('<%= txtCodigo.ClientID %>');

        codeDigits.forEach((input, index) => {
            // Al escribir
            input.addEventListener('input', (e) => {
                const value = e.target.value;

                // Solo números
                if (!/^\d*$/.test(value)) {
                    e.target.value = '';
                    return;
                }

                // Mover al siguiente
                if (value && index < 5) {
                    codeDigits[index + 1].focus();
                }

                updateHiddenInput();
            });

            // Al pegar
            input.addEventListener('paste', (e) => {
                e.preventDefault();
                const pasteData = e.clipboardData.getData('text').replace(/\D/g, '').slice(0, 6);

                pasteData.split('').forEach((char, i) => {
                    if (codeDigits[i]) {
                        codeDigits[i].value = char;
                    }
                });

                updateHiddenInput();

                if (pasteData.length > 0) {
                    const focusIndex = Math.min(pasteData.length, 5);
                    codeDigits[focusIndex].focus();
                }
            });

            // Backspace
            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !e.target.value && index > 0) {
                    codeDigits[index - 1].focus();
                }

                // Enter para verificar
                if (e.key === 'Enter') {
                    e.preventDefault();
                    document.getElementById('<%= btnVerificar.ClientID %>').click();
                }
            });

            // Focus - seleccionar todo
            input.addEventListener('focus', () => {
                input.select();
            });
        });

        function updateHiddenInput() {
            let code = '';
            codeDigits.forEach(input => {
                code += input.value;
            });
            hiddenInput.value = code;
        }

        // Mostrar panel cambiar email
        function mostrarCambioEmail() {
            document.getElementById('<%= pnlCambiarEmail.ClientID %>').style.display = 'block';
            document.getElementById('divOpciones').style.display = 'none';
            document.getElementById('<%= txtNuevoEmail.ClientID %>').focus();
        }

        // Focus en primer input al cargar
        window.addEventListener('load', () => {
            codeDigits[0].focus();
        });
    </script>
</asp:Content>