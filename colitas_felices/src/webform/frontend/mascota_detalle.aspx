<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="mascota_detalle.aspx.cs" Inherits="colitas_felices.src.webform.frontend.mascota_detalle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Detalle de Mascota - Colitas Felices</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/frontend/mascota_detalle_styles.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- BREADCRUMB / VOLVER -->
    <div class="detalle-breadcrumb">
        <div class="container">
            <a href='<%=ResolveUrl("~/src/webform/frontend/adopciones.aspx") %>' class="btn-volver">
                <iconify-icon icon="mdi:arrow-left"></iconify-icon> Volver a adopciones
            </a>
        </div>
    </div>

    <!-- SECCIÓN PRINCIPAL -->
    <section class="detalle-hero">
        <div class="container">
            <div class="detalle-layout">

                <!-- COLUMNA IZQUIERDA: Carrusel de imágenes -->
                <div class="detalle-galeria">

                    <!-- Imagen principal -->
                    <div class="galeria-principal" id="galeriaPrincipal">
                        <%-- PATH vendrá de BD. Por ahora placeholder --%>
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>'
                             alt="Foto principal de la mascota"
                             id="imgPrincipal" />
                        <%-- Badge urgente: mostrar solo si aplica --%>
                        <span class="badge badge-error detalle-urgente">
                            <iconify-icon icon="mdi:heart-pulse"></iconify-icon> Urgente
                        </span>
                    </div>

                    <!-- Miniaturas del carrusel -->
                    <div class="galeria-thumbs" id="galeriaThumbs">
                        <%-- Las miniaturas vendrán de BD. Por ahora placeholders --%>
                        <div class="thumb thumb--active" onclick="cambiarFoto(this, '<%=ResolveUrl("~/src/images/perro_ayudar.png") %>')">
                            <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Foto 1" />
                        </div>
                        <div class="thumb" onclick="cambiarFoto(this, '<%=ResolveUrl("~/src/images/perro_ayudar.png") %>')">
                            <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Foto 2" />
                        </div>
                        <div class="thumb" onclick="cambiarFoto(this, '<%=ResolveUrl("~/src/images/perro_ayudar.png") %>')">
                            <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Foto 3" />
                        </div>
                        <div class="thumb" onclick="cambiarFoto(this, '<%=ResolveUrl("~/src/images/perro_ayudar.png") %>')">
                            <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Foto 4" />
                        </div>
                        <div class="thumb" onclick="cambiarFoto(this, '<%=ResolveUrl("~/src/images/perro_ayudar.png") %>')">
                            <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Foto 5" />
                        </div>
                    </div>

                </div>

                <!-- COLUMNA DERECHA: Info y ficha -->
                <div class="detalle-info">

                    <!-- Nombre y estado -->
                    <div class="detalle-encabezado">
                        <h1 class="detalle-nombre">PERRO 3</h1>
                        <span class="badge badge-success detalle-disponible">Disponible</span>
                    </div>

                    <!-- Chips de características -->
                    <div class="detalle-chips">
                        <div class="detalle-chip">
                            <iconify-icon icon="mdi:cake-variant"></iconify-icon>
                            <span>5 años</span>
                        </div>
                        <div class="detalle-chip">
                            <iconify-icon icon="mdi:gender-male"></iconify-icon>
                            <span>Macho</span>
                        </div>
                        <div class="detalle-chip">
                            <iconify-icon icon="mdi:resize"></iconify-icon>
                            <span>Mediano</span>
                        </div>
                        <div class="detalle-chip detalle-chip--highlight">
                            <iconify-icon icon="mdi:heart"></iconify-icon>
                            <span>Muy cariñoso</span>
                        </div>
                    </div>

                    <!-- Descripción breve -->
                    <p class="detalle-descripcion-breve">
                        5 años · Mediano · Rescatado de la calle, ahora busca familia.
                    </p>

                    <!-- Tarjetas de información -->
                    <div class="detalle-cards-info">

                        <div class="info-card">
                            <h4 class="info-card-titulo">
                                <iconify-icon icon="mdi:heart-broken"></iconify-icon>
                                Historia de Rescate
                            </h4>
                            <p>Fue encontrado en la calle en condiciones difíciles. Lo rescatamos, lo curamos, y ahora está lleno de energía y listo para un hogar lleno de amor.</p>
                        </div>

                        <div class="info-card">
                            <h4 class="info-card-titulo">
                                <iconify-icon icon="mdi:dog-side"></iconify-icon>
                                Personalidad y Características
                            </h4>
                            <p>Es juguetón, sociable con niños y otros perros. Le encanta comer y recibir caricias. ¡Un compañero ideal!</p>
                        </div>

                        <div class="info-card">
                            <h4 class="info-card-titulo">
                                <iconify-icon icon="mdi:medical-bag"></iconify-icon>
                                Necesidades Especiales
                            </h4>
                            <p>Ninguna conocida, pero necesita paseos diarios y mucho cariño.</p>
                        </div>

                    </div>

                    <!-- Botón principal de adopción -->
                    <%--
                        Por ahora redirige a formulario_adopcion.aspx.
                        Mañana definimos si requiere login primero.
                    --%>
                    <div class="detalle-acciones">
                        <a href='<%=ResolveUrl("~/iniciar_sesion") %>'
                           class="btn btn-primary btn-lg btn-block">
                            <iconify-icon icon="mdi:paw-heart"></iconify-icon>
                            Solicitar Adopción
                        </a>
                        <p class="detalle-aviso">
                            <iconify-icon icon="mdi:information"></iconify-icon>
                            Completar la solicitud no reserva al animal. El proceso final se realiza en el refugio.
                        </p>
                    </div>

                </div>

            </div><%-- /detalle-layout --%>
        </div>
    </section>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
    // Cambiar foto principal al hacer click en miniatura
    function cambiarFoto(thumb, src) {
        document.getElementById('imgPrincipal').src = src;
        document.querySelectorAll('.thumb').forEach(t => t.classList.remove('thumb--active'));
        thumb.classList.add('thumb--active');
    }
</script>
</asp:Content>