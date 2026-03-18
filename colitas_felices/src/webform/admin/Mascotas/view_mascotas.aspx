<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/panel.Master" AutoEventWireup="true" CodeBehind="view_mascotas.aspx.cs" Inherits="colitas_felices.src.webform.admin.Mascotas.view_mascotas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Mascotas</h2>

    <%-- FILTROS --%>
    <div>
        <asp:DropDownList ID="ddlEspecie" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged">
            <asp:ListItem Value="">Todas las especies</asp:ListItem>
        </asp:DropDownList>

        <asp:DropDownList ID="ddlEstado" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
            <asp:ListItem Value="">Todos los estados</asp:ListItem>
        </asp:DropDownList>

        <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Buscar por nombre..." />
        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" OnClick="btnLimpiar_Click" />
    </div>

    <br />

    <%-- MENSAJE DE RESULTADO --%>
    <asp:Label ID="lblMensaje" runat="server" Visible="false" />

    <%-- TABLA --%>
    <asp:GridView ID="gvMascotas" runat="server"
        AutoGenerateColumns="false"
        DataKeyNames="MascotaID"
        OnRowCommand="gvMascotas_RowCommand"
        EmptyDataText="No se encontraron mascotas.">
        <Columns>

            <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
            <asp:BoundField DataField="EspecieNombre" HeaderText="Especie" />
            <asp:BoundField DataField="RazaNombre" HeaderText="Raza" />
            <asp:BoundField DataField="SexoTexto" HeaderText="Sexo" />
            <asp:BoundField DataField="TamanioTexto" HeaderText="Tamaño" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <select class="estado-select"
                        data-mascota-id='<%# Eval("MascotaID") %>'
                        data-estado-actual='<%# Eval("EstadoMascotaID") %>'
                        onchange="cambiarEstado(this)"
                        style="font-size: 13px; padding: 4px 8px; border: 1px solid #ced4da; border-radius: 6px; cursor: pointer;">
                    </select>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="EdadAproximada" HeaderText="Edad" />

            <asp:TemplateField HeaderText="Foto">
                <ItemTemplate>
                    <asp:Image ID="imgFoto" runat="server"
                        ImageUrl='<%# string.IsNullOrEmpty(Eval("FotoPrincipalUrl") as string) ? "~/img/sin-foto.png" : Eval("FotoPrincipalUrl") %>'
                        Width="60px" Height="60px" />
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Acciones">
                <ItemTemplate>
                    <asp:LinkButton runat="server" CommandName="Editar"
                        CommandArgument='<%# Eval("MascotaID") %>'
                        Title="Editar mascota">
            <%-- Ícono lápiz --%>
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" 
                 viewBox="0 0 24 24" fill="none" stroke="currentColor" 
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
            </svg>
                    </asp:LinkButton>

                    &nbsp;

        <%-- Botón fotos — abre modal, NO hace postback --%>
                    <button type="button"
                        onclick="abrirModalFotos(<%# Eval("MascotaID") %>, '<%# Eval("Nombre") %>')"
                        title="Gestionar fotos"
                        style="background: none; border: none; cursor: pointer; padding: 0; color: #6c757d;">
                        <%-- Ícono imagen --%>
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2" />
                            <circle cx="8.5" cy="8.5" r="1.5" />
                            <polyline points="21 15 16 10 5 21" />
                        </svg>
                    </button>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>

    <br />

    <%-- PAGINACIÓN --%>
    <asp:Button ID="btnAnterior" runat="server" Text="&lt; Anterior" OnClick="btnAnterior_Click" />
    <asp:Label ID="lblPagina" runat="server" />
    <asp:Button ID="btnSiguiente" runat="server" Text="Siguiente &gt;" OnClick="btnSiguiente_Click" />

    <br />
    <br />

    <asp:Button ID="btnNueva" runat="server" Text="+ Nueva mascota" OnClick="btnNueva_Click" />

    <%-- ============================================================
     MODAL GESTIÓN DE FOTOS
     ============================================================ --%>
    <div id="modalFotos" style="display: none; position: fixed; inset: 0; z-index: 1050; background: rgba(0,0,0,.45); align-items: center; justify-content: center;">

        <div style="background: #fff; border-radius: 12px; width: 100%; max-width: 640px; margin: auto; box-shadow: 0 8px 32px rgba(0,0,0,.18); display: flex; flex-direction: column; max-height: 90vh;">

            <%-- Header --%>
            <div style="display: flex; align-items: center; justify-content: space-between; padding: 16px 20px; border-bottom: 1px solid #dee2e6;">
                <span style="font-weight: 500; font-size: 15px;">Fotos de <span id="modalNombreMascota"></span>
                </span>
                <button onclick="cerrarModalFotos()"
                    style="background: none; border: none; cursor: pointer; font-size: 20px; color: #6c757d; line-height: 1;"
                    title="Cerrar">
                    &times;</button>
            </div>

            <%-- Cuerpo scrolleable --%>
            <div style="padding: 20px; overflow-y: auto; flex: 1;">

                <%-- Grid de fotos existentes --%>
                <p style="font-size: 12px; color: #6c757d; margin: 0 0 10px;">
                    Fotos actuales — <span id="modalContadorFotos">0</span>/5
                </p>
                <div id="modalGridFotos"
                    style="display: grid; grid-template-columns: repeat(5,1fr); gap: 10px; margin-bottom: 20px;">
                    <%-- Se llena dinámicamente con JS --%>
                </div>

                <%-- Dropzone para nuevas fotos (se oculta si ya hay 5) --%>
                <div id="modalDropZone"
                    style="border: 1.5px dashed #adb5bd; border-radius: 8px; padding: 20px; text-align: center; cursor: pointer; background: #fafafa;">
                    <p style="margin: 0 0 4px; font-size: 14px; color: #6c757d;">
                        Arrastra imágenes aquí
                    </p>
                    <p style="margin: 0 0 12px; font-size: 12px; color: #9ca3af;">
                        o haz clic para seleccionar
                    </p>
                    <button type="button"
                        onclick="document.getElementById('modalFileInput').click()"
                        style="font-size: 13px; padding: 5px 14px; border: 1px solid #ced4da; border-radius: 6px; background: #fff; cursor: pointer;">
                        Seleccionar archivos
                    </button>
                    <input type="file" id="modalFileInput" multiple
                        accept=".jpg,.jpeg,.png,.webp" style="display: none;" />
                </div>

                <%-- Preview de fotos NUEVAS a subir --%>
                <div id="modalPreviewNuevas"
                    style="display: none; margin-top: 12px; display: grid; grid-template-columns: repeat(5,1fr); gap: 10px;">
                </div>

                <%-- Mensaje de estado --%>
                <p id="modalMensaje"
                    style="display: none; margin-top: 12px; font-size: 13px; padding: 8px 12px; border-radius: 6px;">
                </p>
            </div>

            <%-- Footer --%>
            <div style="padding: 14px 20px; border-top: 1px solid #dee2e6; display: flex; justify-content: flex-end; gap: 10px;">
                <button onclick="cerrarModalFotos()"
                    style="padding: 7px 16px; border: 1px solid #ced4da; border-radius: 6px; background: #fff; cursor: pointer; font-size: 14px;">
                    Cerrar
                </button>
                <button id="modalBtnSubir" onclick="subirFotosNuevas()"
                    style="padding: 7px 16px; border: none; border-radius: 6px; background: #0d6efd; color: #fff; cursor: pointer; font-size: 14px; display: none;">
                    Subir fotos
                </button>
            </div>
        </div>
    </div>


</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // ── Estado del modal ─────────────────────────────────────
        var _mascotaID = 0;
        var _fotosNuevas = [];   // archivos pendientes de subir
        var HANDLER_URL = '<%= ResolveUrl("~/Handlers/FotosMascotaHandler.ashx") %>';

        // ── Llenar todos los dropdowns de estado al cargar ───────
        window.onload = function () {
            llenarDropdownsEstado();
        };

        function llenarDropdownsEstado() {
            if (typeof ESTADOS === 'undefined') return;
            //DEBUG TEMPORAL
            // Traza quién llamó esta función
            console.log('=== llenarDropdownsEstado llamado desde:', new Error().stack);

            var selects = document.querySelectorAll('.estado-select');

            selects.forEach(function (select) {
                //DEBUG TEMPORAL
                console.log('  select mascotaID:', select.dataset.mascotaId,
                    '| estadoActual:', select.dataset.estadoActual,
                    '| value actual:', select.value);

                // Si ya tiene opciones, solo actualizar el color
                if (select.options.length > 0) {
                    colorearEstado(select);
                    return;
                }
                // Lee el valor actual — puede haber cambiado desde el fetch
                var estadoActual = parseInt(select.dataset.estadoActual)

                // Llenar opciones desde la variable ESTADOS inyectada por C#
                ESTADOS.forEach(function (e) {
                    var option = document.createElement('option');
                    option.value = e.id;
                    option.textContent = e.nombre;
                    if (e.id === estadoActual) option.selected = true;
                    select.appendChild(option);
                });

                // Color inicial
                colorearEstado(select);
            });
        }

        // ── Cambiar estado via fetch ──────────────────────────────
        function cambiarEstado(select) {
            var mascotaID = parseInt(select.dataset.mascotaId);
            var estadoID = parseInt(select.value);

            //DEBUG TEMPORAL
            console.log('=== cambiarEstado llamado');
            console.log('mascotaID:', mascotaID);
            console.log('estadoID:', estadoID);

            // Deshabilita mientras procesa
            select.disabled = true;

            fetch('<%= ResolveUrl("~/Handlers/MascotaEstadoHandler.ashx") %>', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'accion=cambiarEstado&mascotaID=' + mascotaID + '&estadoID=' + estadoID
            })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    //DEBUGEAR TEMPORAL
                    console.log('=== Respuesta del handler:', data);
                    console.log('data-estado-actual ANTES:', select.dataset.estadoActual);
                    if (data.ok) {
                        // Actualiza el atributo ANTES de colorear
                        // Así si el observer recarga, toma el valor nuevo
                        select.dataset.estadoActual = estadoID;
                        colorearEstado(select);   // actualiza el color visualmente
                    } else {
                        alert('Error: ' + data.msg);
                        // Revertir al valor anterior
                        select.value = select.dataset.estadoActual;
                        colorearEstado(select);
                    }
                    // Actualiza el estado actual guardado
                    select.dataset.estadoActual = select.value;
                })
                .finally(function () {
                    select.disabled = false;
                });
        }

        // ── Color según estado ────────────────────────────────────
        function colorearEstado(select) {
            var colores = {
                1: { bg: '#d1fae5', color: '#065f46' },  // Disponible — verde
                2: { bg: '#dbeafe', color: '#1e40af' },  // En proceso — azul
                3: { bg: '#f3f4f6', color: '#374151' },  // Adoptado   — gris
                4: { bg: '#fee2e2', color: '#991b1b' },  // Cuarentena — rojo
                5: { bg: '#fef3c7', color: '#92400e' },  // Discapacitado — amarillo
                6: { bg: '#ede9fe', color: '#5b21b6' }   // Reingresado — morado
            };

            var estadoID = parseInt(select.value);
            var c = colores[estadoID] || { bg: '#f9fafb', color: '#374151' };

            select.style.background = c.bg;
            select.style.color = c.color;
            select.style.border = '1px solid ' + c.color + '40';
        }
        // ── Abrir modal ──────────────────────────────────────────
        function abrirModalFotos(mascotaID, nombre) {
            _mascotaID = mascotaID;
            _fotosNuevas = [];

            document.getElementById('modalNombreMascota').textContent = nombre;
            document.getElementById('modalMensaje').style.display = 'none';
            document.getElementById('modalPreviewNuevas').style.display = 'none';
            document.getElementById('modalPreviewNuevas').innerHTML = '';
            document.getElementById('modalBtnSubir').style.display = 'none';

            var modal = document.getElementById('modalFotos');
            modal.style.display = 'flex';

            cargarFotosExistentes();
        }

        // ── Cerrar modal ─────────────────────────────────────────
        function cerrarModalFotos() {
            document.getElementById('modalFotos').style.display = 'none';
            _fotosNuevas = [];
        }

        // ── Cargar fotos actuales desde el handler ───────────────
        function cargarFotosExistentes() {
            var grid = document.getElementById('modalGridFotos');
            grid.innerHTML = '<p style="font-size:13px;color:#9ca3af;">Cargando...</p>';

            fetch(HANDLER_URL + '?accion=obtener&mascotaID=' + _mascotaID)
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    renderFotosExistentes(data.fotos || []);
                })
                .catch(function () {
                    grid.innerHTML = '<p style="color:red;font-size:13px;">Error al cargar fotos.</p>';
                });
        }

        // ── Renderizar fotos existentes ──────────────────────────
        function renderFotosExistentes(fotos) {
            var grid = document.getElementById('modalGridFotos');
            var counter = document.getElementById('modalContadorFotos');
            var dropZone = document.getElementById('modalDropZone');

            grid.innerHTML = '';
            counter.textContent = fotos.length;

            // Ocultar dropzone si ya hay 5 fotos
            dropZone.style.display = fotos.length >= 5 ? 'none' : 'block';

            fotos.forEach(function (f) {
                var div = document.createElement('div');
                div.style.cssText = 'position:relative;border-radius:8px;overflow:hidden;' +
                    'aspect-ratio:1;border:1px solid #dee2e6;background:#f8f9fa;';

                div.innerHTML =
                    '<img src="' + f.BlobUrl + '" style="width:100%;height:100%;object-fit:cover;">' +

                    // Badge principal
                    (f.EsPrincipal
                        ? '<span style="position:absolute;top:5px;left:5px;font-size:10px;' +
                        'background:#dbeafe;color:#1e40af;border-radius:4px;padding:2px 6px;' +
                        'font-weight:500;">Principal</span>'
                        : // Botón para marcar como principal
                        '<button onclick="marcarPrincipal(' + f.FotoID + ')" title="Marcar como principal" ' +
                        'style="position:absolute;top:5px;left:5px;background:rgba(255,255,255,.85);' +
                        'border:1px solid #dee2e6;border-radius:4px;cursor:pointer;' +
                        'font-size:10px;padding:2px 6px;">★ Principal</button>') +

                    // Botón eliminar
                    '<button onclick="eliminarFoto(' + f.FotoID + ')" title="Eliminar foto" ' +
                    'style="position:absolute;top:5px;right:5px;width:22px;height:22px;' +
                    'border-radius:50%;background:rgba(255,255,255,.85);color:#6c757d;' +
                    'border:1px solid #dee2e6;cursor:pointer;font-size:13px;' +
                    'line-height:22px;text-align:center;padding:0;">&times;</button>';

                grid.appendChild(div);
            });
        }

        // ── Eliminar foto ────────────────────────────────────────
        function eliminarFoto(fotoID) {
            if (!confirm('¿Eliminar esta foto?')) return;

            fetch(HANDLER_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'accion=eliminar&fotoID=' + fotoID + '&mascotaID=' + _mascotaID
            })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    mostrarMensajeModal(data.msg, data.ok);
                    if (data.ok) cargarFotosExistentes();   // refresca el grid
                });
        }

        // ── Cambiar foto principal ───────────────────────────────
        function marcarPrincipal(fotoID) {
            fetch(HANDLER_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'accion=principal&fotoID=' + fotoID + '&mascotaID=' + _mascotaID
            })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    mostrarMensajeModal(data.msg, data.ok);
                    if (data.ok) cargarFotosExistentes();
                });
        }

        // ── Drop zone para fotos nuevas ──────────────────────────
        (function () {
            var dropZone = document.getElementById('modalDropZone');
            var fileInput = document.getElementById('modalFileInput');
            var MAX_TOTAL = 5;

            dropZone.addEventListener('dragover', function (e) {
                e.preventDefault();
                dropZone.style.background = '#f1f5ff';
            });
            dropZone.addEventListener('dragleave', function () {
                dropZone.style.background = '#fafafa';
            });
            dropZone.addEventListener('drop', function (e) {
                e.preventDefault();
                dropZone.style.background = '#fafafa';
                agregarArchivos(e.dataTransfer.files);
            });
            fileInput.addEventListener('change', function () {
                agregarArchivos(fileInput.files);
                fileInput.value = '';
            });
        })();

        function agregarArchivos(archivos) {
            var counter = parseInt(document.getElementById('modalContadorFotos').textContent);
            var espacio = 5 - counter - _fotosNuevas.length;
            if (espacio <= 0) {
                mostrarMensajeModal('Ya no hay espacio para más fotos (máx. 5).', false);
                return;
            }

            Array.from(archivos)
                .filter(function (f) { return f.type.startsWith('image/'); })
                .slice(0, espacio)
                .forEach(function (f) { _fotosNuevas.push(f); });

            renderPreviewNuevas();
        }

        function renderPreviewNuevas() {
            var grid = document.getElementById('modalPreviewNuevas');
            var btn = document.getElementById('modalBtnSubir');
            grid.innerHTML = '';

            if (_fotosNuevas.length === 0) {
                grid.style.display = 'none';
                btn.style.display = 'none';
                return;
            }

            grid.style.display = 'grid';
            btn.style.display = 'inline-block';

            _fotosNuevas.forEach(function (f, i) {
                var url = URL.createObjectURL(f);
                var div = document.createElement('div');
                div.style.cssText = 'position:relative;border-radius:8px;overflow:hidden;' +
                    'aspect-ratio:1;border:1px solid #dee2e6;background:#f8f9fa;';
                div.innerHTML =
                    '<img src="' + url + '" style="width:100%;height:100%;object-fit:cover;">' +
                    '<button onclick="quitarNueva(' + i + ')" ' +
                    'style="position:absolute;top:5px;right:5px;width:22px;height:22px;' +
                    'border-radius:50%;background:rgba(255,255,255,.85);border:1px solid #dee2e6;' +
                    'cursor:pointer;font-size:13px;line-height:22px;text-align:center;padding:0;">' +
                    '&times;</button>';
                grid.appendChild(div);
            });
        }

        function quitarNueva(i) {
            _fotosNuevas.splice(i, 1);
            renderPreviewNuevas();
        }

        // ── Subir fotos nuevas ───────────────────────────────────
        function subirFotosNuevas() {
            if (_fotosNuevas.length === 0) return;

            var btn = document.getElementById('modalBtnSubir');
            btn.disabled = true;
            btn.textContent = 'Subiendo...';

            var formData = new FormData();
            formData.append('accion', 'subir');
            formData.append('mascotaID', _mascotaID);
            _fotosNuevas.forEach(function (f) { formData.append('fotos', f); });

            fetch(HANDLER_URL, { method: 'POST', body: formData })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    mostrarMensajeModal(data.msg, data.ok);
                    if (data.ok) {
                        _fotosNuevas = [];
                        renderPreviewNuevas();
                        cargarFotosExistentes();
                    }
                })
                .finally(function () {
                    btn.disabled = false;
                    btn.textContent = 'Subir fotos';
                });
        }

        // ── Mensaje de estado en el modal ────────────────────────
        function mostrarMensajeModal(texto, esOk) {
            var el = document.getElementById('modalMensaje');
            el.textContent = texto;
            el.style.display = 'block';
            el.style.background = esOk ? '#d1fae5' : '#fee2e2';
            el.style.color = esOk ? '#065f46' : '#991b1b';
        }

        // Cerrar modal al hacer clic fuera
        document.getElementById('modalFotos').addEventListener('click', function (e) {
            if (e.target === this) cerrarModalFotos();
        });

        //Siempre volver a lamar al dropdown
        // Observa cambios en el GridView y rellena dropdowns automáticamente
        window.onload = function () {
            llenarDropdownsEstado();
        };
        // Observa la tabla del GridView
        window.addEventListener('pageshow', function () {
            llenarDropdownsEstado();
        });

    </script>
</asp:Content>
