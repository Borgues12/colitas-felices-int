<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/panel.Master" AutoEventWireup="true" CodeBehind="view_mascotas.aspx.cs" Inherits="colitas_felices.src.webform.admin.Mascotas.view_mascotas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href='<%= ResolveUrl("~/src/css/mascotas/mascotas_style.css") %>' />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <%-- ============================================================
         HEADER
         ============================================================ --%>
    <div class="mascotas-header">
        <div class="mascotas-header__left">
            <h2 class="mascotas-title">Mascotas</h2>
            <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="mascotas-msg" />
        </div>
        <asp:Button ID="btnNueva" runat="server" Text="+ Nueva mascota"
            OnClick="btnNueva_Click" CssClass="btn-nueva-mascota" />
    </div>

    <%-- ============================================================
         FILTROS
         ============================================================ --%>
    <div class="mascotas-filtros">
        <div class="filtro-grupo">
            <label class="filtro-label">Especie</label>
            <asp:DropDownList ID="ddlEspecie" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlEspecie_SelectedIndexChanged"
                CssClass="filtro-select">
                <asp:ListItem Value="">Todas las especies</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="filtro-grupo">
            <label class="filtro-label">Estado</label>
            <asp:DropDownList ID="ddlEstado" runat="server" AutoPostBack="true"
                OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged"
                CssClass="filtro-select">
                <asp:ListItem Value="">Todos los estados</asp:ListItem>
            </asp:DropDownList>
        </div>

        <div class="filtro-grupo filtro-busqueda">
            <label class="filtro-label">Buscar</label>
            <div class="filtro-busqueda-row">
                <asp:TextBox ID="txtBusqueda" runat="server" placeholder="Nombre..."
                    CssClass="filtro-input" />
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar"
                    OnClick="btnBuscar_Click" CssClass="btn-filtro btn-filtro--buscar" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"
                    OnClick="btnLimpiar_Click" CssClass="btn-filtro btn-filtro--limpiar" />
            </div>
        </div>
    </div>

    <%-- ============================================================
         GRID DE CARDS (GridView oculto como fuente + cards via JS)
         ============================================================ --%>

    <%-- GridView oculto: fuente de datos para el backend --%>
    <div style="display:none;">
        <asp:GridView ID="gvMascotas" runat="server"
            AutoGenerateColumns="false"
            DataKeyNames="MascotaID"
            OnRowCommand="gvMascotas_RowCommand"
            EmptyDataText="No se encontraron mascotas."
            CssClass="gv-hidden-source">
            <Columns>
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <asp:BoundField DataField="EspecieNombre" HeaderText="Especie" />
                <asp:BoundField DataField="RazaNombre" HeaderText="Raza" />
                <asp:BoundField DataField="SexoTexto" HeaderText="Sexo" />
                <asp:BoundField DataField="TamanioTexto" HeaderText="Tamaño" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class="gv-estado-data"
                            data-mascota-id='<%# Eval("MascotaID") %>'
                            data-estado-id='<%# Eval("EstadoMascotaID") %>'>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="EdadAproximada" HeaderText="Edad" />
                <asp:TemplateField HeaderText="Foto">
                    <ItemTemplate>
                        <span class="gv-foto-data"
                            data-foto='<%# string.IsNullOrEmpty(Eval("FotoPrincipalUrl") as string) ? "" : Eval("FotoPrincipalUrl") %>'>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <%-- Acciones: LinkButton para Editar (necesita postback real) --%>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkEditar" runat="server" CommandName="Editar"
                            CommandArgument='<%# Eval("MascotaID") %>'
                            CssClass="gv-btn-editar">
                            Editar
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <%-- Contenedor visual de cards --%>
    <div id="mascotasCardsGrid" class="mascotas-cards-grid">
        <%-- Se llena via JS desde el GridView oculto --%>
    </div>

    <%-- Mensaje vacio --%>
    <div id="mascotasEmpty" class="mascotas-empty" style="display:none;">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24"
            fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
        </svg>
        <p>No se encontraron mascotas.</p>
    </div>

    <%-- ============================================================
         PAGINACION
         ============================================================ --%>
    <div class="mascotas-paginacion">
        <asp:Button ID="btnAnterior" runat="server" Text="Anterior"
            OnClick="btnAnterior_Click" CssClass="btn-pag" />
        <asp:Label ID="lblPagina" runat="server" CssClass="pag-info" />
        <asp:Button ID="btnSiguiente" runat="server" Text="Siguiente"
            OnClick="btnSiguiente_Click" CssClass="btn-pag" />
    </div>

    <%-- ============================================================
         MODAL GESTION DE FOTOS
         ============================================================ --%>
    <div id="modalFotos" class="modal-fotos-overlay">
        <div class="modal-fotos-container">

            <%-- Header --%>
            <div class="modal-fotos-header">
                <span class="modal-fotos-title">
                    Fotos de <span id="modalNombreMascota"></span>
                </span>
                <button onclick="cerrarModalFotos()" class="modal-fotos-close" title="Cerrar">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24"
                        fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                    </svg>
                </button>
            </div>

            <%-- Cuerpo --%>
            <div class="modal-fotos-body">
                <p class="modal-fotos-counter">
                    Fotos actuales: <span id="modalContadorFotos">0</span> / 5
                </p>
                <div id="modalGridFotos" class="modal-fotos-grid"></div>

                <%-- Dropzone --%>
                <div id="modalDropZone" class="modal-dropzone">
                    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24"
                        fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                        <circle cx="8.5" cy="8.5" r="1.5"/>
                        <polyline points="21 15 16 10 5 21"/>
                    </svg>
                    <p class="modal-dropzone-text">Arrastra imagenes aqui</p>
                    <p class="modal-dropzone-sub">o haz clic para seleccionar</p>
                    <button type="button" onclick="document.getElementById('modalFileInput').click()"
                        class="modal-dropzone-btn">
                        Seleccionar archivos
                    </button>
                    <input type="file" id="modalFileInput" multiple accept=".jpg,.jpeg,.png,.webp"
                        style="display:none;" />
                </div>

                <%-- Preview nuevas --%>
                <div id="modalPreviewNuevas" class="modal-fotos-grid modal-preview-nuevas"></div>

                <%-- Mensaje --%>
                <p id="modalMensaje" class="modal-fotos-msg"></p>
            </div>

            <%-- Footer --%>
            <div class="modal-fotos-footer">
                <button onclick="cerrarModalFotos()" class="btn-modal btn-modal--cancel">Cerrar</button>
                <button id="modalBtnSubir" onclick="subirFotosNuevas()"
                    class="btn-modal btn-modal--upload" style="display:none;">
                    Subir fotos
                </button>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
    // ================================================================
    //  ESTADO & CONFIG
    // ================================================================
    var _mascotaID   = 0;
    var _fotosNuevas = [];
    var HANDLER_URL  = '<%= ResolveUrl("~/Handlers/FotosMascotaHandler.ashx") %>';
    var ESTADO_HANDLER = '<%= ResolveUrl("~/Handlers/MascotaEstadoHandler.ashx") %>';
    var SIN_FOTO     = '<%= ResolveUrl("~/img/sin-foto.png") %>';

    var ESTADO_META = {
        1: { nombre: 'Disponible',    clase: 'estado--disponible'    },
        2: { nombre: 'En proceso',    clase: 'estado--en-proceso'    },
        3: { nombre: 'Adoptado',      clase: 'estado--adoptado'      },
        4: { nombre: 'Cuarentena',    clase: 'estado--cuarentena'    },
        5: { nombre: 'Discapacitado', clase: 'estado--discapacitado' },
        6: { nombre: 'Reingresado',   clase: 'estado--reingresado'   }
    };

    // ================================================================
    //  CONSTRUIR CARDS DESDE EL GRIDVIEW OCULTO
    // ================================================================
    function construirCards() {
        var table = document.querySelector('.gv-hidden-source');
        var grid  = document.getElementById('mascotasCardsGrid');
        var empty = document.getElementById('mascotasEmpty');
        grid.innerHTML = '';

        if (!table) { empty.style.display = 'flex'; return; }

        var rows = table.querySelectorAll('tbody tr, tr');
        var dataRows = [];

        rows.forEach(function(row) {
            if (row.querySelector('th')) return; // skip header
            var cells = row.querySelectorAll('td');
            if (cells.length < 9) return;

            var estadoSpan = cells[5].querySelector('.gv-estado-data');
            var fotoSpan   = cells[7].querySelector('.gv-foto-data');
            var editBtn    = cells[8].querySelector('.gv-btn-editar');

            dataRows.push({
                nombre:    cells[0].textContent.trim(),
                especie:   cells[1].textContent.trim(),
                raza:      cells[2].textContent.trim(),
                sexo:      cells[3].textContent.trim(),
                tamanio:   cells[4].textContent.trim(),
                estadoID:  estadoSpan ? parseInt(estadoSpan.dataset.estadoId) : 0,
                mascotaID: estadoSpan ? parseInt(estadoSpan.dataset.mascotaId) : 0,
                edad:      cells[6].textContent.trim(),
                foto:      fotoSpan ? fotoSpan.dataset.foto : '',
                editHref:  editBtn ? editBtn.getAttribute('href') : '#'
            });
        });

        if (dataRows.length === 0) {
            empty.style.display = 'flex';
            return;
        }

        empty.style.display = 'none';

        dataRows.forEach(function(d) {
            var estadoInfo = ESTADO_META[d.estadoID] || { nombre: 'Desconocido', clase: '' };
            var fotoUrl = d.foto || SIN_FOTO;

            var card = document.createElement('div');
            card.className = 'mascota-card';
            card.dataset.mascotaId = d.mascotaID;

            card.innerHTML =
                '<div class="mascota-card__img-wrap">' +
                    '<img src="' + fotoUrl + '" alt="' + d.nombre + '" class="mascota-card__img" ' +
                        'onerror="this.src=\'' + SIN_FOTO + '\'" />' +
                    '<span class="mascota-card__badge ' + estadoInfo.clase + '" ' +
                        'data-estado-id="' + d.estadoID + '">' +
                        estadoInfo.nombre +
                    '</span>' +
                '</div>' +
                '<div class="mascota-card__body">' +
                    '<h3 class="mascota-card__name">' + d.nombre + '</h3>' +
                    '<div class="mascota-card__details">' +
                        '<span class="mascota-card__detail">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>' +
                            d.especie +
                        '</span>' +
                        '<span class="mascota-card__detail">' +
                            '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>' +
                            d.edad +
                        '</span>' +
                    '</div>' +
                    '<div class="mascota-card__meta">' +
                        '<span>' + d.raza + '</span>' +
                        '<span class="mascota-card__sep"></span>' +
                        '<span>' + d.sexo + '</span>' +
                        '<span class="mascota-card__sep"></span>' +
                        '<span>' + d.tamanio + '</span>' +
                    '</div>' +

                    <%-- Dropdown de estado --%>
                '<div class="mascota-card__estado-row">' +
                '<label class="mascota-card__estado-label">Estado:</label>' +
                '<select class="estado-select ' + estadoInfo.clase + '"' +
                ' data-mascota-id="' + d.mascotaID + '"' +
                ' data-estado-actual="' + d.estadoID + '"' +
                ' onchange="cambiarEstado(this)">' +
                '</select>' +
                '</div>' +

                '<div class="mascota-card__actions">' +
                '<a href="' + d.editHref + '" class="card-action card-action--edit" title="Editar">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>' +
                ' Editar' +
                '</a>' +
                '<button type="button" class="card-action card-action--fotos"' +
                ' onclick="abrirModalFotos(' + d.mascotaID + ', \'' + d.nombre.replace(/'/g, "\\'") + '\')"' +
                ' title="Gestionar fotos">' +
                '<svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>' +
                ' Fotos' +
                '</button>' +
                '</div>' +
                '</div>';

            grid.appendChild(card);
        });

        // Llenar dropdowns de estado en las cards
        llenarDropdownsEstado();
    }

    // ================================================================
    //  DROPDOWN ESTADOS
    // ================================================================
    function llenarDropdownsEstado() {
        if (typeof ESTADOS === 'undefined') return;

        var selects = document.querySelectorAll('.estado-select');
        selects.forEach(function (select) {
            if (select.options.length > 0) {
                colorearEstado(select);
                return;
            }

            var estadoActual = parseInt(select.dataset.estadoActual);

            ESTADOS.forEach(function (e) {
                var option = document.createElement('option');
                option.value = e.id;
                option.textContent = e.nombre;
                if (e.id === estadoActual) option.selected = true;
                select.appendChild(option);
            });

            colorearEstado(select);
        });
    }

    // ================================================================
    //  CAMBIAR ESTADO (fetch)
    // ================================================================
    function cambiarEstado(select) {
        var mascotaID = parseInt(select.dataset.mascotaId);
        var estadoID = parseInt(select.value);

        select.disabled = true;

        fetch(ESTADO_HANDLER, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'accion=cambiarEstado&mascotaID=' + mascotaID + '&estadoID=' + estadoID
        })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.ok) {
                    select.dataset.estadoActual = estadoID;
                    colorearEstado(select);

                    // Actualizar badge visual
                    var card = select.closest('.mascota-card');
                    if (card) {
                        var badge = card.querySelector('.mascota-card__badge');
                        var info = ESTADO_META[estadoID] || { nombre: 'Desconocido', clase: '' };
                        if (badge) {
                            badge.textContent = info.nombre;
                            badge.className = 'mascota-card__badge ' + info.clase;
                            badge.dataset.estadoId = estadoID;
                        }
                    }
                } else {
                    alert('Error: ' + data.msg);
                    select.value = select.dataset.estadoActual;
                    colorearEstado(select);
                }
                select.dataset.estadoActual = select.value;
            })
            .finally(function () {
                select.disabled = false;
            });
    }

    // ================================================================
    //  COLOREAR SELECT ESTADO
    // ================================================================
    function colorearEstado(select) {
        var estadoID = parseInt(select.value);
        // Quitar clases previas
        select.className = select.className.replace(/estado--\S+/g, '').trim();
        var info = ESTADO_META[estadoID];
        if (info) {
            select.classList.add(info.clase);
        }
    }

    // ================================================================
    //  MODAL FOTOS
    // ================================================================
    function abrirModalFotos(mascotaID, nombre) {
        _mascotaID = mascotaID;
        _fotosNuevas = [];

        document.getElementById('modalNombreMascota').textContent = nombre;
        document.getElementById('modalMensaje').style.display = 'none';
        document.getElementById('modalPreviewNuevas').innerHTML = '';
        document.getElementById('modalPreviewNuevas').style.display = 'none';
        document.getElementById('modalBtnSubir').style.display = 'none';

        document.getElementById('modalFotos').classList.add('is-open');
        document.body.style.overflow = 'hidden';

        cargarFotosExistentes();
    }

    function cerrarModalFotos() {
        document.getElementById('modalFotos').classList.remove('is-open');
        document.body.style.overflow = '';
        _fotosNuevas = [];
    }

    function cargarFotosExistentes() {
        var grid = document.getElementById('modalGridFotos');
        grid.innerHTML = '<p class="modal-fotos-loading">Cargando...</p>';

        fetch(HANDLER_URL + '?accion=obtener&mascotaID=' + _mascotaID)
            .then(function (r) { return r.json(); })
            .then(function (data) {
                renderFotosExistentes(data.fotos || []);
            })
            .catch(function () {
                grid.innerHTML = '<p class="modal-fotos-error">Error al cargar fotos.</p>';
            });
    }

    function renderFotosExistentes(fotos) {
        var grid = document.getElementById('modalGridFotos');
        var counter = document.getElementById('modalContadorFotos');
        var dropZone = document.getElementById('modalDropZone');

        grid.innerHTML = '';
        counter.textContent = fotos.length;
        dropZone.style.display = fotos.length >= 5 ? 'none' : 'flex';

        fotos.forEach(function (f) {
            var div = document.createElement('div');
            div.className = 'modal-foto-item';

            div.innerHTML =
                '<img src="' + f.BlobUrl + '" class="modal-foto-img" />' +
                (f.EsPrincipal
                    ? '<span class="modal-foto-badge modal-foto-badge--principal">Principal</span>'
                    : '<button onclick="marcarPrincipal(' + f.FotoID + ')" class="modal-foto-badge modal-foto-badge--set">Marcar principal</button>'
                ) +
                '<button onclick="eliminarFoto(' + f.FotoID + ')" class="modal-foto-delete" title="Eliminar">&times;</button>';

            grid.appendChild(div);
        });
    }

    function eliminarFoto(fotoID) {
        if (!confirm('Eliminar esta foto?')) return;

        fetch(HANDLER_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'accion=eliminar&fotoID=' + fotoID + '&mascotaID=' + _mascotaID
        })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                mostrarMensajeModal(data.msg, data.ok);
                if (data.ok) cargarFotosExistentes();
            });
    }

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

    // ================================================================
    //  DROPZONE
    // ================================================================
    (function () {
        var dropZone = document.getElementById('modalDropZone');
        var fileInput = document.getElementById('modalFileInput');

        if (!dropZone || !fileInput) return;

        dropZone.addEventListener('dragover', function (e) {
            e.preventDefault();
            dropZone.classList.add('is-dragover');
        });
        dropZone.addEventListener('dragleave', function () {
            dropZone.classList.remove('is-dragover');
        });
        dropZone.addEventListener('drop', function (e) {
            e.preventDefault();
            dropZone.classList.remove('is-dragover');
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
            mostrarMensajeModal('Ya no hay espacio para mas fotos (max. 5).', false);
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
        btn.style.display = 'inline-flex';

        _fotosNuevas.forEach(function (f, i) {
            var url = URL.createObjectURL(f);
            var div = document.createElement('div');
            div.className = 'modal-foto-item';
            div.innerHTML =
                '<img src="' + url + '" class="modal-foto-img" />' +
                '<button onclick="quitarNueva(' + i + ')" class="modal-foto-delete">&times;</button>';
            grid.appendChild(div);
        });
    }

    function quitarNueva(i) {
        _fotosNuevas.splice(i, 1);
        renderPreviewNuevas();
    }

    // ================================================================
    //  SUBIR FOTOS
    // ================================================================
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

    // ================================================================
    //  UTILIDADES
    // ================================================================
    function mostrarMensajeModal(texto, esOk) {
        var el = document.getElementById('modalMensaje');
        el.textContent = texto;
        el.style.display = 'block';
        el.className = 'modal-fotos-msg ' + (esOk ? 'modal-fotos-msg--ok' : 'modal-fotos-msg--error');
    }

    // Cerrar modal al clic fuera
    document.getElementById('modalFotos').addEventListener('click', function (e) {
        if (e.target === this) cerrarModalFotos();
    });

    // ================================================================
    //  INIT
    // ================================================================
    window.onload = function () {
        construirCards();
    };
    window.addEventListener('pageshow', function () {
        construirCards();
    });
</script>
</asp:Content>
