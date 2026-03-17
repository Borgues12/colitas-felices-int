<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/panel.Master" AutoEventWireup="true" CodeBehind="mascotasForm.aspx.cs" Inherits="colitas_felices.src.webform.admin.Mascotas.mascotasForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-wrapper {
            max-width: 720px;
            margin: 0 auto;
            padding: 24px;
            font-family: inherit;
        }

        .form-title {
            font-size: 20px;
            font-weight: 500;
            margin: 0 0 1.5rem;
        }

        .form-section {
            background: #fff;
            border: 0.5px solid #dee2e6;
            border-radius: 12px;
            padding: 1.25rem;
            margin-bottom: 1rem;
        }

        .section-label {
            font-size: 13px;
            font-weight: 500;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin: 0 0 1rem;
        }

        .field-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

            .field-group label {
                font-size: 12px;
                color: #6c757d;
            }

            .field-group input,
            .field-group select,
            .field-group textarea {
                width: 100%;
                box-sizing: border-box;
                padding: 8px 10px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                font-size: 14px;
                font-family: inherit;
            }

            .field-group textarea {
                resize: vertical;
            }

        .checks-row {
            display: flex;
            gap: 2rem;
            margin-bottom: 1rem;
        }

        .check-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            cursor: pointer;
        }

        .fecha-est {
            display: none;
            margin-bottom: 1rem;
        }

        .condiciones-divider {
            border-top: 0.5px solid #dee2e6;
            padding-top: 1rem;
        }

        .condiciones-sub {
            font-size: 12px;
            color: #6c757d;
            margin: 0 0 10px;
        }

        .condiciones-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 4px 16px;
        }

        #cblCondiciones ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        #cblCondiciones li {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            color: #374151;
            padding: 3px 0;
        }

        #cblCondiciones input[type="checkbox"] {
            width: 14px;
            height: 14px;
            margin: 0;
            flex-shrink: 0;
            accent-color: #0d6efd;
            cursor: pointer;
        }

        #cblCondiciones label {
            margin: 0;
            cursor: pointer;
            font-size: 13px;
            color: #374151;
            line-height: 1.3;
        }

        .count-msg {
            font-size: 12px;
            color: #6c757d;
            margin: 8px 0 0;
            display: none;
        }
        /* Botones */
        .btn-row {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 1.5rem;
        }

        .drop-zone {
            border: 1.5px dashed #adb5bd;
            border-radius: 8px;
            padding: 1.5rem 1rem;
            text-align: center;
            cursor: pointer;
            transition: background .15s;
            background: #fafafa;
        }

            .drop-zone.drag-over {
                background: #f1f5ff;
                border-color: #6ea8fe;
            }

            .drop-zone p {
                margin: 0 0 4px;
                font-size: 14px;
                color: #6c757d;
            }

                .drop-zone p.sub {
                    font-size: 12px;
                    margin: 0 0 12px;
                    color: #9ca3af;
                }

            .drop-zone button {
                font-size: 13px;
                padding: 5px 14px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                background: #fff;
                cursor: pointer;
                color: #374151;
            }

                .drop-zone button:hover {
                    background: #f1f3f5;
                }

        .preview-grid {
            display: none;
            margin-top: 1rem;
            grid-template-columns: repeat(5,minmax(0,1fr));
            gap: 10px;
        }

        .preview-thumb {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            aspect-ratio: 1;
            border: 0.5px solid #dee2e6;
            background: #f8f9fa;
        }

            .preview-thumb img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .preview-thumb .badge {
                position: absolute;
                top: 5px;
                left: 5px;
                font-size: 10px;
                background: #dbeafe;
                color: #1e40af;
                border-radius: 4px;
                padding: 2px 6px;
                font-weight: 500;
            }

            .preview-thumb .remove {
                position: absolute;
                top: 5px;
                right: 5px;
                width: 20px;
                height: 20px;
                border-radius: 50%;
                background: rgba(255,255,255,.85);
                color: #6c757d;
                border: 0.5px solid #dee2e6;
                cursor: pointer;
                font-size: 13px;
                line-height: 20px;
                text-align: center;
                padding: 0;
            }

                .preview-thumb .remove:hover {
                    background: #fee2e2;
                    color: #991b1b;
                }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="form-wrapper">

        <p class="form-title">Nueva mascota</p>

        <%-- SECCION: Datos basicos --%>
        <div class="form-section">
            <p class="section-label">Datos básicos</p>

            <div class="field-grid-2">
                <div class="field-group">
                    <label>Nombre *</label>
                    <asp:TextBox ID="txtNombre" runat="server" placeholder="Nombre de la mascota" />
                </div>
                <div class="field-group">
                    <label>Color *</label>
                    <asp:TextBox ID="txtColor" runat="server" placeholder="Ej: Café con blanco" />
                </div>
                <div class="field-group">
                    <label>Especie *</label>
                    <asp:DropDownList ID="ddlEspecie" runat="server"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="field-group">
                    <label>Raza *</label>
                    <asp:DropDownList ID="ddlRaza" runat="server">
                        <asp:ListItem Value="0">Seleccione especie primero</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="field-group">
                    <label>Sexo *</label>
                    <asp:DropDownList ID="ddlSexo" runat="server">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                        <asp:ListItem Value="1">Macho</asp:ListItem>
                        <asp:ListItem Value="2">Hembra</asp:ListItem>
                        <asp:ListItem Value="3">Desconocido</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="field-group">
                    <label>Tamaño *</label>
                    <asp:DropDownList ID="ddlTamanio" runat="server">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                        <asp:ListItem Value="1">Pequeño</asp:ListItem>
                        <asp:ListItem Value="2">Mediano</asp:ListItem>
                        <asp:ListItem Value="3">Grande</asp:ListItem>
                        <asp:ListItem Value="4">Gigante</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="field-group">
                    <label>Estado *</label>
                    <asp:DropDownList ID="ddlEstado" runat="server">
                        <asp:ListItem Value="0">Seleccione...</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="field-group">
                    <label>Fecha de nacimiento (aprox.)</label>
                    <div class="age-toggle">
                        <label class="toggle-option">
                            <input type="radio" name="tipoEdad" value="fecha" checked
                                onchange="toggleEdad(this.value)" />
                            Conozco la fecha exacta
                        </label>
                        <label class="toggle-option">
                            <input type="radio" name="tipoEdad" value="aproximada"
                                onchange="toggleEdad(this.value)" />
                            No sé la fecha exacta
                        </label>
                    </div>
                    <%-- Panel fecha exacta --%>
                    <asp:Panel ID="pnlFechaExacta" runat="server">
                        <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date" />
                    </asp:Panel>

                    <%-- Panel edad aproximada --%>
                    <asp:Panel ID="pnlEdadAprox" runat="server" Style="display: none;">
                        <div class="edad-aprox-input">
                            <asp:TextBox ID="txtEdadAnios" runat="server"
                                TextMode="Number" placeholder="ej: 2"
                                CssClass="input-anios" />
                            <span>años</span>
                        </div>
                        <small>Se calculará como: hoy menos los años indicados</small>
                    </asp:Panel>

                    <%-- Campo oculto que indica al servidor cuál modo está activo --%>
                    <asp:HiddenField ID="hfTipoEdad" runat="server" Value="fecha" />
                </div>
                <div class="field-group">
                    <label>N° microchip</label>
                    <asp:TextBox ID="txtMicrochip" runat="server" placeholder="Opcional" />
                </div>
            </div>
        </div>

        <%-- SECCION: Características --%>
        <div class="form-section">
            <p class="section-label">Características</p>

            <div class="checks-row">
                <label class="check-label">
                    <asp:CheckBox ID="chkAdoptable" runat="server" Checked="true" />
                    ¿Es adoptable?
           
                </label>
                <label class="check-label">
                    <asp:CheckBox ID="chkEsterilizado" runat="server"
                        onclick="document.getElementById('divFechaEst').style.display=this.checked?'block':'none'" />
                    ¿Esterilizado?
           
                </label>
            </div>

            <div id="divFechaEst" class="fecha-est">
                <div class="field-group" style="max-width: 220px;">
                    <label>Fecha de esterilización *</label>
                    <asp:TextBox ID="txtFechaEsterilizacion" runat="server" TextMode="Date" />
                </div>
            </div>

            <div class="condiciones-divider">
                <p class="condiciones-sub">Condiciones especiales</p>
                <asp:CheckBoxList ID="cblCondiciones" runat="server"
                    ClientIDMode="Static"
                    RepeatLayout="UnorderedList"
                    CssClass="condiciones-grid" />
            </div>
        </div>

        <%-- SECCION: Descripción --%>
        <div class="form-section">
            <p class="section-label">Descripción</p>
            <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine"
                Rows="4" CssClass="field-group"
                placeholder="Historia de la mascota, personalidad, necesidades..."
                Style="width: 100%; box-sizing: border-box; padding: 8px 10px; border: 1px solid #ced4da; border-radius: 6px; font-size: 14px; resize: vertical;" />
        </div>

        <%-- SECCION: Fotos --%>
        <div class="form-section">
            <p class="section-label">Fotos</p>
            <p style="font-size: 12px; color: #6c757d; margin: -8px 0 1rem;">Máx. 5 imágenes — la primera será la principal</p>

            <div id="dropZone" class="drop-zone">
                <p>Arrastra las imágenes aquí</p>
                <p class="sub">o haz clic para seleccionar</p>
                <button type="button" onclick="document.getElementById('fileInputDrop').click()">Seleccionar archivos</button>
                <asp:FileUpload ID="fuFotos" runat="server"
                    accept=".jpg,.jpeg,.png,.webp"
                    multiple="multiple"
                    Style="display: none;" />
            </div>
            <div id="previewGrid" class="preview-grid"></div>
            <p id="countMsg" class="count-msg"></p>
        </div>
        <%-- BOTONES --%>
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
        (function () {
            var dropZone = document.getElementById('dropZone');
            var fileInput = document.getElementById('<%= fuFotos.ClientID %>');
            var grid = document.getElementById('previewGrid');
            var countMsg = document.getElementById('countMsg');
            var MAX = 5;
            var files = [];

            function renderPreviews() {
                grid.innerHTML = '';
                if (files.length === 0) {
                    grid.style.display = 'none';
                    countMsg.style.display = 'none';
                    return;
                }
                grid.style.display = 'grid';
                countMsg.style.display = 'block';
                countMsg.textContent = files.length + ' de ' + MAX + ' imágenes seleccionadas';

                files.forEach(function (f, i) {
                    var url = URL.createObjectURL(f);
                    var div = document.createElement('div');
                    div.className = 'preview-thumb';
                    div.innerHTML =
                        '<img src="' + url + '" alt="Vista previa">' +
                        (i === 0 ? '<span class="badge">Principal</span>' : '') +
                        '<button type="button" class="remove" data-i="' + i + '" title="Quitar">x</button>';
                    grid.appendChild(div);
                });

                grid.querySelectorAll('.remove').forEach(function (btn) {
                    btn.addEventListener('click', function () {
                        files.splice(parseInt(this.dataset.i), 1);
                        renderPreviews();
                    });
                });
            }

            function addFiles(newFiles) {
                var arr = Array.from(newFiles).filter(function (f) { return f.type.startsWith('image/'); });
                var remaining = MAX - files.length;
                files = files.concat(arr.slice(0, remaining));
                renderPreviews();
            }

            dropZone.addEventListener('dragover', function (e) {
                e.preventDefault();
                dropZone.classList.add('drag-over');
            });
            dropZone.addEventListener('dragleave', function () {
                dropZone.classList.remove('drag-over');
            });
            dropZone.addEventListener('drop', function (e) {
                e.preventDefault();
                dropZone.classList.remove('drag-over');
                addFiles(e.dataTransfer.files);
            });
            dropZone.addEventListener('click', function (e) {
                if (e.target.tagName !== 'BUTTON') fileInput.click();
            });
            fileInput.addEventListener('change', function () {
                addFiles(fileInput.files);
                fileInput.value = '';
            });
            // Asignar archivos al input de ASP.NET antes del postback
            document.getElementById('<%= btnGuardar.ClientID %>').addEventListener('click', function (e) {
                if (files.length === 0) return;

                var dt = new DataTransfer();
                files.forEach(function (f) { dt.items.add(f); });
                fileInput.files = dt.files;
            });
        })();

        //Funcion para utilizar la fecha exacta o edad aproximada
        function toggleEdad(valor) {
            // Buscar los paneles por sus IDs parciales con querySelector
            var pnlFecha = document.querySelector('[id$="pnlFechaExacta"]');
            var pnlAprox = document.querySelector('[id$="pnlEdadAprox"]');
            var txtFecha = document.querySelector('[id$="txtFechaNacimiento"]');
            var txtAnios = document.querySelector('[id$="txtEdadAnios"]');
            var hfTipo = document.querySelector('[id$="hfTipoEdad"]');

            pnlFecha.style.display = valor === 'fecha' ? '' : 'none';
            pnlAprox.style.display = valor === 'aproximada' ? '' : 'none';
            hfTipo.value = valor;

            if (valor === 'fecha') txtAnios.value = '';
            else txtFecha.value = '';
        }
    </script>
</asp:Content>
