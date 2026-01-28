<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="verificarCodigo.aspx.cs" Inherits="colitas_felices.src.webform.login.verificarCodigo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Verificar Correo - Colitas Felices
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/verificar_style.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">
    <div class="verificar-page">
        <div class="verificar-box">
            
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <!-- PANEL DE VERIFICACIÓN -->
                    <asp:Panel ID="pnlVerificar" runat="server">
                        
                        <div class="verificar-icon">
                            <iconify-icon icon="mdi:email-check"></iconify-icon>
                        </div>
                        <h2>Verifica tu correo</h2>
                        <p class="verificar-subtitle">Ingresa el código de 6 dígitos enviado a:</p>
                        <p class="verificar-email">
                            <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                        </p>

                        <asp:Panel ID="pnlMensaje" runat="server" Visible="false">
                            <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="codigo-container">
                            <input type="text" class="codigo-input" maxlength="1" data-index="0" inputmode="numeric" pattern="[0-9]*" />
                            <input type="text" class="codigo-input" maxlength="1" data-index="1" inputmode="numeric" pattern="[0-9]*" />
                            <input type="text" class="codigo-input" maxlength="1" data-index="2" inputmode="numeric" pattern="[0-9]*" />
                            <input type="text" class="codigo-input" maxlength="1" data-index="3" inputmode="numeric" pattern="[0-9]*" />
                            <input type="text" class="codigo-input" maxlength="1" data-index="4" inputmode="numeric" pattern="[0-9]*" />
                            <input type="text" class="codigo-input" maxlength="1" data-index="5" inputmode="numeric" pattern="[0-9]*" />
                        </div>

                        <asp:HiddenField ID="hfCodigo" runat="server" />

                        <asp:Button ID="btnVerificar" runat="server" Text="Verificar código"
                            CssClass="btn-verificar" OnClick="btnVerificar_Click" />

                        <div class="reenviar-section">
                            <p class="reenviar-text">¿No recibiste el código?</p>
                            <asp:Button ID="btnReenviar" runat="server" Text="Reenviar código"
                                CssClass="btn-reenviar" OnClick="btnReenviar_Click" CausesValidation="false" />
                            <p class="countdown" id="countdown"></p>
                        </div>

                    </asp:Panel>

                    <!-- PANEL DE ÉXITO -->
                    <asp:Panel ID="pnlExito" runat="server" Visible="false">
                        <div class="exito-container">
                            <div class="exito-icon">
                                <iconify-icon icon="mdi:check-bold"></iconify-icon>
                            </div>
                            <h2>¡Cuenta verificada!</h2>
                            <p class="verificar-subtitle">Tu correo ha sido verificado correctamente.<br/>Ya puedes iniciar sesión.</p>
                            <a href="login.aspx" class="btn-continuar">
                                <iconify-icon icon="mdi:login" style="vertical-align: middle; margin-right: 8px;"></iconify-icon>
                                Iniciar sesión
                            </a>
                        </div>
                    </asp:Panel>

                    <!-- PANEL SIN EMAIL -->
                    <asp:Panel ID="pnlSinEmail" runat="server" Visible="false">
                        <div class="verificar-icon" style="background: linear-gradient(135deg, var(--color-warning), #F57C00);">
                            <iconify-icon icon="mdi:alert"></iconify-icon>
                        </div>
                        <h2>Enlace inválido</h2>
                        <p class="verificar-subtitle">No se especificó un correo electrónico para verificar.</p>
                        <a href="registrar.aspx" class="btn-continuar" style="background: linear-gradient(135deg, var(--color-secondary), var(--color-secondary-dark));">
                            Ir a Registro
                        </a>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- Loading (usa clases de global.css) -->
            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                <ProgressTemplate>
                    <div class="loading-overlay show">
                        <div class="spinner"></div>
                        <span class="loading-text">Verificando...</span>
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>

            <a href="registrar.aspx" class="volver-link">
                <iconify-icon icon="mdi:arrow-left"></iconify-icon>
                Volver al registro
            </a>

        </div>
    </div>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            initCodigoInputs();
            initCountdown();
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            initCodigoInputs();
        });

        function initCodigoInputs() {
            const inputs = document.querySelectorAll('.codigo-input');
            const hiddenField = document.getElementById('<%= hfCodigo.ClientID %>');

            if (!inputs.length) return;

            inputs.forEach((input, index) => {
                input.addEventListener('input', function(e) {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    
                    if (this.value.length === 1) {
                        this.classList.add('filled');
                        if (index < inputs.length - 1) {
                            inputs[index + 1].focus();
                        }
                    } else {
                        this.classList.remove('filled');
                    }

                    updateHiddenField();
                    this.classList.remove('error');
                });

                input.addEventListener('keydown', function(e) {
                    if (e.key === 'Backspace' && this.value === '' && index > 0) {
                        inputs[index - 1].focus();
                    }
                });

                input.addEventListener('paste', function(e) {
                    e.preventDefault();
                    const pasteData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
                    
                    for (let i = 0; i < Math.min(pasteData.length, inputs.length); i++) {
                        inputs[i].value = pasteData[i];
                        inputs[i].classList.add('filled');
                    }
                    
                    const lastIndex = Math.min(pasteData.length, inputs.length) - 1;
                    if (lastIndex < inputs.length - 1) {
                        inputs[lastIndex + 1].focus();
                    } else {
                        inputs[lastIndex].focus();
                    }
                    
                    updateHiddenField();
                });
            });

            function updateHiddenField() {
                let codigo = '';
                inputs.forEach(input => { codigo += input.value; });
                hiddenField.value = codigo;
            }

            inputs[0].focus();
        }

        function initCountdown() {
            const btnReenviar = document.getElementById('<%= btnReenviar.ClientID %>');
            const countdownEl = document.getElementById('countdown');
            
            if (!btnReenviar || !countdownEl) return;

            const savedTime = sessionStorage.getItem('reenviarCountdown');
            if (savedTime) {
                const remaining = Math.floor((parseInt(savedTime) - Date.now()) / 1000);
                if (remaining > 0) startCountdown(remaining);
            }
        }

        function startCountdown(seconds) {
            const btnReenviar = document.getElementById('<%= btnReenviar.ClientID %>');
            const countdownEl = document.getElementById('countdown');

            btnReenviar.disabled = true;
            sessionStorage.setItem('reenviarCountdown', Date.now() + (seconds * 1000));

            const interval = setInterval(function () {
                countdownEl.textContent = 'Puedes reenviar en ' + seconds + ' segundos';
                seconds--;

                if (seconds < 0) {
                    clearInterval(interval);
                    btnReenviar.disabled = false;
                    countdownEl.textContent = '';
                    sessionStorage.removeItem('reenviarCountdown');
                }
            }, 1000);
        }

        function marcarError() {
            document.querySelectorAll('.codigo-input').forEach(input => {
                input.classList.add('error');
            });
        }
    </script>
</asp:Content>
