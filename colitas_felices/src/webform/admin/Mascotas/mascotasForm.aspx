<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/panel.Master" AutoEventWireup="true" CodeBehind="mascotasForm.aspx.cs" Inherits="colitas_felices.src.webform.admin.Mascotas.mascotasForm" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-wrapper       { max-width: 760px; margin: 32px auto; padding: 0 16px; }
        .form-card          { background: #fff; border-radius: 12px; border: 1px solid #e9ecef; padding: 28px 32px; margin-bottom: 20px; }
        .form-card h5       { font-size: 14px; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; color: #868e96; margin-bottom: 18px; }
        .form-row           { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 14px; }
        .form-group         { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 180px; }
        .form-group label   { font-size: 12px; font-weight: 600; color: #495057; }
        .form-group input,
        .form-group select,
        .form-group textarea{ padding: 7px 10px; border: 1px solid #dee2e6; border-radius: 6px; font-size: 13px; color: #212529; background: #f8f9fa; }
        .form-group textarea{ resize: vertical; }
        .check-row          { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #495057; }
        .foto-grid          { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; }
        .foto-item label    { font-size: 11px; color: #868e96; display: block; margin-bottom: 4px; }
        .foto-item input    { width: 100%; font-size: 12px; }
        .btn-row            { display: flex; gap: 10px; justify-content: flex-end; padding-top: 8px; }
        #divFechaEst        { display: none; margin-top: 12px; }
        .condiciones-grid   { display: grid; grid-template-columns: repeat(2,1fr); gap: 6px; font-size: 13px; }
        .page-title         { font-size: 20px; font-weight: 600; color: #212529; margin-bottom: 20px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="form-wrapper">

    <div class="page-title">Nueva mascota</div>

    <%-- Datos básicos --%>
    <div class="form-card">
        <h5>Datos básicos</h5>

        <div class="form-row">
            <div class="form-group">
                <label>Nombre *</label>
                <asp:TextBox ID="txtNombre" runat="server" placeholder="Nombre de la mascota" />
            </div>
            <div class="form-group">
                <label>Color *</label>
                <asp:TextBox ID="txtColor" runat="server" placeholder="Ej: Café con blanco" />
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Especie *</label>
                <asp:DropDownList ID="ddlEspecie" runat="server" onchange="filtrarRazas(this.value)">
                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Raza *</label>
                <asp:DropDownList ID="ddlRaza" runat="server">
                    <asp:ListItem Value="0">Seleccione especie primero</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Sexo *</label>
                <asp:DropDownList ID="ddlSexo" runat="server">
                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    <asp:ListItem Value="1">Macho</asp:ListItem>
                    <asp:ListItem Value="2">Hembra</asp:ListItem>
                    <asp:ListItem Value="3">Desconocido</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Tamaño *</label>
                <asp:DropDownList ID="ddlTamanio" runat="server">
                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    <asp:ListItem Value="1">Pequeño</asp:ListItem>
                    <asp:ListItem Value="2">Mediano</asp:ListItem>
                    <asp:ListItem Value="3">Grande</asp:ListItem>
                    <asp:ListItem Value="4">Gigante</asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="form-group">
                <label>Estado *</label>
                <asp:DropDownList ID="ddlEstado" runat="server">
                    <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label>Fecha de nacimiento (aprox.)</label>
                <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date" />
            </div>
            <div class="form-group">
                <label>N° microchip</label>
                <asp:TextBox ID="txtMicrochip" runat="server" placeholder="Opcional" />
            </div>
        </div>
    </div>

    <%-- Características --%>
    <div class="form-card">
        <h5>Características</h5>

        <div class="form-row" style="gap:24px;">
            <div class="check-row">
                <asp:CheckBox ID="chkAdoptable" runat="server" Checked="true" />
                <label>¿Es adoptable?</label>
            </div>
            <div class="check-row">
                <asp:CheckBox ID="chkEsterilizado" runat="server"
                    onclick="document.getElementById('divFechaEst').style.display=this.checked?'block':'none'" />
                <label>¿Esterilizado?</label>
            </div>
        </div>

        <div id="divFechaEst">
            <div class="form-group" style="max-width:220px;">
                <label>Fecha de esterilización *</label>
                <asp:TextBox ID="txtFechaEsterilizacion" runat="server" TextMode="Date" />
            </div>
        </div>

        <div style="margin-top:16px;">
            <label style="font-size:12px; font-weight:600; color:#495057; display:block; margin-bottom:8px;">Condiciones especiales</label>
            <asp:CheckBoxList ID="cblCondiciones" runat="server"
                RepeatLayout="Flow"
                CssClass="condiciones-grid" />
        </div>
    </div>

    <%-- Descripción --%>
    <div class="form-card">
        <h5>Descripción</h5>
        <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine"
            Rows="4"
            placeholder="Historia, personalidad, necesidades..." />
    </div>

    <%-- Fotos --%>
    <div class="form-card">
        <h5>Fotos <span style="font-weight:400; color:#adb5bd; text-transform:none; letter-spacing:0;">(máx. 5 — la primera será la principal)</span></h5>
        <div class="foto-grid">
            <div class="foto-item"><label>Foto 1 (principal)</label><asp:FileUpload ID="fuFoto1" runat="server" accept=".jpg,.jpeg,.png,.webp" /></div>
            <div class="foto-item"><label>Foto 2</label><asp:FileUpload ID="fuFoto2" runat="server" accept=".jpg,.jpeg,.png,.webp" /></div>
            <div class="foto-item"><label>Foto 3</label><asp:FileUpload ID="fuFoto3" runat="server" accept=".jpg,.jpeg,.png,.webp" /></div>
            <div class="foto-item"><label>Foto 4</label><asp:FileUpload ID="fuFoto4" runat="server" accept=".jpg,.jpeg,.png,.webp" /></div>
            <div class="foto-item"><label>Foto 5</label><asp:FileUpload ID="fuFoto5" runat="server" accept=".jpg,.jpeg,.png,.webp" /></div>
        </div>
    </div>

    <%-- Botones --%>
    <div class="btn-row">
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
            CssClass="btn btn-secondary"
            OnClick="btnCancelar_Click"
            CausesValidation="false" />
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar mascota"
            CssClass="btn btn-primary"
            OnClick="btnGuardar_Click" />
    </div>

</div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        var todasLasRazas = <asp:Literal ID="litRazasJson" runat="server" />;

        function filtrarRazas(especieId) {
            var ddl = document.getElementById('<%= ddlRaza.ClientID %>');
            ddl.innerHTML = '';

            if (!especieId || especieId == '0') {
                ddl.innerHTML = '<option value="0">Seleccione especie primero</option>';
                return;
            }

            var filtradas = todasLasRazas.filter(function (r) {
                return r.EspecieID == especieId;
            });

            ddl.innerHTML = '<option value="0">Seleccione...</option>';
            filtradas.forEach(function (r) {
                var opt = document.createElement('option');
                opt.value = r.RazaID;
                opt.text = r.Nombre;
                ddl.appendChild(opt);
            });

            if (filtradas.length === 0)
                ddl.innerHTML = '<option value="0">Sin razas disponibles</option>';
        }
    </script>
</asp:Content>