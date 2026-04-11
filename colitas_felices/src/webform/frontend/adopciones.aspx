<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="adopciones.aspx.cs" Inherits="colitas_felices.src.webform.frontend.adopciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Adopciones - Colitas Felices
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/frontend/adopciones_styles.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- HEADER DE PÁGINA -->
    <section class="adopciones-header">
        <div class="container text-center">
            <h1>Encuentra a tu <span>compañero ideal</span></h1>
            <p>Descubre nuestra extensa galería de animales rescatados que esperan
               por un hogar amoroso. Usa los filtros y búsqueda para encontrar
               el match perfecto basado en tipo, edad y tamaño.</p>
        </div>
    </section>

    <!-- FILTROS -->
    <section class="adopciones-filtros">
        <div class="container">

            <div class="filtros-top">
                <div class="filtros-tipo" id="filtrosTipo">
                    <button type="button" class="filtro-tab active" data-filtro-tipo="todos">
                        Todos
                    </button>
                    <button type="button" class="filtro-tab" data-filtro-tipo="perro">
                        <iconify-icon icon="mdi:dog"></iconify-icon> Perros
                    </button>
                    <button type="button" class="filtro-tab" data-filtro-tipo="gato">
                        <iconify-icon icon="mdi:cat"></iconify-icon> Gatos
                    </button>
                    <div class="filtros-divider"></div>
                    <button type="button" class="filtro-tab filtro-avanzado-toggle" id="toggleFiltrosAvanzados">
                        <iconify-icon icon="mdi:tune-variant"></iconify-icon>
                    </button>
                </div>

                <div class="filtros-busqueda">
                    <iconify-icon icon="mdi:magnify"></iconify-icon>
                    <input type="text"
                           id="busquedaNombre"
                           class="input-field"
                           placeholder="Buscar por nombre..." />
                </div>
            </div>

            <div class="filtros-avanzados" id="filtrosAvanzados">
                <div class="filtro-grupo">
                    <span class="filtro-grupo-label">Sexo:</span>
                    <button type="button" class="filtro-chip active" data-filtro-sexo="todos">Todos</button>
                    <button type="button" class="filtro-chip" data-filtro-sexo="macho">
                        <iconify-icon icon="mdi:gender-male"></iconify-icon> Macho
                    </button>
                    <button type="button" class="filtro-chip" data-filtro-sexo="hembra">
                        <iconify-icon icon="mdi:gender-female"></iconify-icon> Hembra
                    </button>
                </div>

                <div class="filtro-grupo">
                    <span class="filtro-grupo-label">Tamaño:</span>
                    <button type="button" class="filtro-chip active" data-filtro-tamanio="todos">Todos</button>
                    <button type="button" class="filtro-chip" data-filtro-tamanio="pequeno">Pequeño</button>
                    <button type="button" class="filtro-chip" data-filtro-tamanio="mediano">Mediano</button>
                    <button type="button" class="filtro-chip" data-filtro-tamanio="grande">Grande</button>
                </div>
            </div>

            <div class="filtros-resultado">
                <span id="contadorResultados">Mostrando <strong>6</strong> animales</span>
                <button type="button" class="btn-limpiar-filtros" id="limpiarFiltros">
                    <iconify-icon icon="mdi:close-circle"></iconify-icon> Limpiar filtros
                </button>
            </div>

        </div>
    </section>

    <!-- GALERÍA -->
    <section class="adopciones-galeria">
        <div class="container">
            <div class="galeria-grid" id="galeriaGrid">

                <div class="mascota-card card"
                     data-tipo="perro" data-sexo="hembra"
                     data-tamanio="pequeno" data-nombre="luna">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Luna" />
                        <span class="badge badge-success mascota-estado">Disponible</span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">PERRO 1</h3>
                        <p class="mascota-descripcion">3 años · Pequeño · Cariñoso</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=1") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

                <div class="mascota-card card"
                     data-tipo="gato" data-sexo="macho"
                     data-tamanio="pequeno" data-nombre="michi">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Michi" />
                        <span class="badge badge-success mascota-estado">Disponible</span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">GATO 1</h3>
                        <p class="mascota-descripcion">2 años · Juguetón</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=2") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

                <div class="mascota-card card"
                     data-tipo="perro" data-sexo="macho"
                     data-tamanio="mediano" data-nombre="max">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Max" />
                        <span class="badge badge-success mascota-estado">Disponible</span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">PERRO 2</h3>
                        <p class="mascota-descripcion">1 año · Mediano · Juguetón</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=3") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

                <div class="mascota-card card"
                     data-tipo="perro" data-sexo="macho"
                     data-tamanio="mediano" data-nombre="rocky">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Rocky" />
                        <span class="badge badge-success mascota-estado">Disponible</span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">PERRO 3</h3>
                        <p class="mascota-descripcion">2 años · Mediano · Muy juguetón y cariñoso</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=4") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

                <div class="mascota-card card"
                     data-tipo="perro" data-sexo="macho"
                     data-tamanio="grande" data-nombre="simba">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Simba" />
                        <span class="badge badge-error mascota-estado">
                            <iconify-icon icon="mdi:heart-pulse"></iconify-icon> Urgente
                        </span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">PERRO 4</h3>
                        <p class="mascota-descripcion">12 años · Adulto mayor · Busca hogar tranquilo</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=5") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

                <div class="mascota-card card"
                     data-tipo="gato" data-sexo="hembra"
                     data-tamanio="pequeno" data-nombre="nala">
                    <div class="mascota-imagen">
                        <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>' alt="Nala" />
                        <span class="badge badge-success mascota-estado">Disponible</span>
                    </div>
                    <div class="mascota-info card-body">
                        <h3 class="card-title">GATO 2</h3>
                        <p class="mascota-descripcion">1 año · Calmado</p>
                        <a href='<%=ResolveUrl("~/Mascotas?id=6") %>'
                           class="btn btn-primary btn-block">Conocer más</a>
                    </div>
                </div>

            </div>

            <div class="galeria-vacia d-none" id="galeriaVacia">
                <iconify-icon icon="mdi:paw-off"></iconify-icon>
                <h3>No encontramos mascotas</h3>
                <p>Intenta con otros filtros o limpia la búsqueda.</p>
                <button type="button" class="btn btn-secondary" id="limpiarFiltrosVacio">
                    Limpiar filtros
                </button>
            </div>

        </div>
    </section>

    <!-- PAGINACIÓN -->
    <section class="adopciones-paginacion">
        <div class="container">
            <nav class="paginacion" id="paginacion">
                <button type="button" class="pag-btn" disabled>
                    <iconify-icon icon="mdi:chevron-double-left"></iconify-icon>
                </button>
                <button type="button" class="pag-btn pag-btn--active">1</button>
                <button type="button" class="pag-btn">2</button>
                <button type="button" class="pag-btn">3</button>
                <button type="button" class="pag-btn">
                    <iconify-icon icon="mdi:chevron-double-right"></iconify-icon>
                </button>
            </nav>
        </div>
    </section>


    <!-- ══════════════════════════════════════════
         SECCIÓN: RESPONSABILIDAD Y PROCESO
    ══════════════════════════════════════════ -->

    <!-- BLOQUE 1: Un Nuevo Miembro en la Familia -->
    <section class="adopcion-info-section" id="requisitos"> 
        <div class="container">

            <div class="adopcion-info-header text-center">
                <h2>¿Un Nuevo Miembro en la <span>Familia</span>?</h2>
                <p class="adopcion-info-subtitulo">
                    Recuerda: adoptar un perro o un gato es ante todo
                    <strong>UN ACTO DE RESPONSABILIDAD.</strong>
                </p>
            </div>

            <div class="adopcion-info-grid">
                <div class="adopcion-info-texto">
                    <h4>¿Una "Mascota" para Nuestros Hijos?</h4>
                    <p>Muchos somos los padres y madres que hemos sucumbido a los ruegos de un hijo ilusionado ante los encantos de una bolita de pelos. Gracias a esta decisión, se han contado historias conmovedoras de amistad y lealtad a toda prueba entre un niño y su perro o gato.</p>
                    <p>Tener un animal de familia en casa puede ayudar a nuestros hijos y a nosotros mismos a establecer un vínculo muy profundo con los animales, siempre y cuando comprendamos la responsabilidad que implica el traer un nuevo miembro a la familia.</p>
                    <p>El compromiso de cuidar al perro o gato que adoptemos debe ser entendido con toda claridad desde el primer momento, por lo que es imprescindible que los niños sean parte activa de la decisión.</p>
                </div>
                <div class="adopcion-info-texto">
                    <p>Enseñar y permitirle a un niño que cuide de un ser vivo puede además convertirse en una experiencia que ayudará a formar su carácter motivándolo a asumir responsabilidades dentro del hogar.</p>
                    <p>Para lograr esto, es fundamental que nosotros como adultos nos aseguremos de tener la actitud adecuada hacia los animales teniendo claro el respeto que se merecen, ya que el ejemplo que demos a nuestros hijos será determinante para que la experiencia de convivir con un animal de familia, sea positiva para todos.</p>
                    <p>Una vez tomada la decisión, lo siguiente será asignar a cada miembro de la familia la parte que le corresponde en el cuidado del perro o gato que hayamos escogido.</p>
                </div>
            </div>

        </div>
    </section>

    <!-- BLOQUE 2: Para No Olvidar -->
    <section class="adopcion-recordar-section">
        <div class="container">

            <div class="text-center">
                <h2>¡Para No <span>Olvidar</span>!</h2>
                <p>Recuerda que los perros y gatos son seres vivos con características
                   y necesidades propias de su especie.</p>
            </div>

            <div class="recordar-grid">

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:account-heart"></iconify-icon>
                    </div>
                    <p>Necesitan tu compañía y la de otros de su misma especie. No tiene sentido tener un animal aislado en terrazas o patios traseros.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:shield-heart"></iconify-icon>
                    </div>
                    <p>El maltrato físico o psicológico les afecta como a cualquier ser vivo. No los maltrates ni permitas que otros lo hagan.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:food-apple"></iconify-icon>
                    </div>
                    <p>Requieren alimento adecuado a su edad y especie. No les des sobras, podrían hacerles daño. Sin suficiente agua fresca podrían enfermarse.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:weather-sunny"></iconify-icon>
                    </div>
                    <p>No deben estar expuestos a las inclemencias del tiempo. Es cruel y antinatural mantenerlos aislados, encerrados o encadenados.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:walk"></iconify-icon>
                    </div>
                    <p>Los perros disfrutan mucho los paseos en familia; dos veces al día durante 30 a 60 minutos cada vez sería ideal para ellos.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:needle"></iconify-icon>
                    </div>
                    <p>Deben ser desparasitados regularmente y recibir las dosis completas de las vacunas recomendadas por el médico veterinario.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:stethoscope"></iconify-icon>
                    </div>
                    <p>Si se enferman deben ser atendidos por un médico veterinario acreditado; no permitas que sufran innecesariamente.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:tag-heart"></iconify-icon>
                    </div>
                    <p>No olvides identificarlos mediante tatuaje o microchip, además de colocarles una placa en el collar con su nombre y teléfono.</p>
                </div>

                <div class="recordar-card">
                    <div class="recordar-icon">
                        <iconify-icon icon="mdi:scissors-cutting"></iconify-icon>
                    </div>
                    <p>La única forma de detener la sobrepoblación canina y felina es mediante la CASTRACIÓN; mejor si se realiza antes de que inicie el ciclo reproductivo.</p>
                </div>

            </div>

        </div>
    </section>

    <!-- BLOQUE 3: Cómo Adoptar en Colitas Felices -->
    <section class="adopcion-proceso-section" id="proceso">
        <div class="container">

            <div class="text-center">
                <h2>¿Cómo Adoptar en <span>Colitas Felices</span>?</h2>
                <p>Los perros y gatos rescatados pasan al Programa de Adopciones
                   para ser reubicados con familias responsables.</p>
            </div>

            <div class="proceso-pasos">

                <div class="proceso-paso">
                    <div class="paso-numero">1</div>
                    <div class="paso-contenido">
                        <h4>Explora la Galería</h4>
                        <p>Conoce a los animales disponibles, filtra por tipo, tamaño o sexo y encuentra a tu compañero ideal.</p>
                    </div>
                </div>

                <div class="proceso-conector">
                    <iconify-icon icon="mdi:arrow-right"></iconify-icon>
                </div>

                <div class="proceso-paso">
                    <div class="paso-numero">2</div>
                    <div class="paso-contenido">
                        <h4>Completa la Solicitud</h4>
                        <p>Llena el formulario con tus datos. Nuestro equipo lo revisará y se pondrá en contacto contigo.</p>
                    </div>
                </div>

                <div class="proceso-conector">
                    <iconify-icon icon="mdi:arrow-right"></iconify-icon>
                </div>

                <div class="proceso-paso">
                    <div class="paso-numero">3</div>
                    <div class="paso-contenido">
                        <h4>Visita el Refugio</h4>
                        <p>Ven a conocer al animal en persona. Aquí se concreta la adopción con el contrato y la entrega oficial.</p>
                    </div>
                </div>

                <div class="proceso-conector">
                    <iconify-icon icon="mdi:arrow-right"></iconify-icon>
                </div>

                <div class="proceso-paso">
                    <div class="paso-numero">4</div>
                    <div class="paso-contenido">
                        <h4>¡Nuevo Hogar!</h4>
                        <p>Tu nuevo compañero llega a casa vacunado, desparasitado, esterilizado e identificado con microchip.</p>
                    </div>
                </div>

            </div>

            <%-- Nota importante sobre reservas --%>
            <div class="proceso-nota">
                <iconify-icon icon="mdi:information"></iconify-icon>
                <p>Completar la solicitud <strong>no reserva ni aparta ningún animal</strong>. Los animales publicados pueden ser visitados pero no reservados. La adopción se concreta únicamente en el refugio.</p>
            </div>

            <div class="text-center mt-4">
                <a href='<%=ResolveUrl("~/Adopta") %>'
                   class="btn btn-primary btn-lg">
                    <iconify-icon icon="mdi:paw"></iconify-icon>
                    Ver animales disponibles
                </a>
            </div>

        </div>
    </section>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
    <script>
    var cards = document.querySelectorAll('.mascota-card');
    var contador = document.getElementById('contadorResultados');
    var galeriaVacia = document.getElementById('galeriaVacia');
    var paginacion = document.getElementById('paginacion');

    var filtroTipo = 'todos';
    var filtroSexo = 'todos';
    var filtroTamanio = 'todos';
    var filtroBusqueda = '';

    function aplicarFiltros() {
        var visibles = 0;
        cards.forEach(function (card) {
            var tipo = card.dataset.tipo;
            var sexo = card.dataset.sexo;
            var tamanio = card.dataset.tamanio;
            var nombre = card.dataset.nombre;

            var pasaTipo = filtroTipo === 'todos' || tipo === filtroTipo;
            var pasaSexo = filtroSexo === 'todos' || sexo === filtroSexo;
            var pasaTamanio = filtroTamanio === 'todos' || tamanio === filtroTamanio;
            var pasaBusqueda = nombre.indexOf(filtroBusqueda.toLowerCase().trim()) !== -1;

            if (pasaTipo && pasaSexo && pasaTamanio && pasaBusqueda) {
                card.classList.remove('d-none');
                visibles++;
            } else {
                card.classList.add('d-none');
            }
        });

        contador.innerHTML = 'Mostrando <strong>' + visibles + '</strong> animales';

        if (visibles === 0) {
            galeriaVacia.classList.remove('d-none');
            paginacion.classList.add('d-none');
        } else {
            galeriaVacia.classList.add('d-none');
            paginacion.classList.remove('d-none');
        }
    }

    document.querySelectorAll('[data-filtro-tipo]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-filtro-tipo]').forEach(function (b) { b.classList.remove('active'); });
            this.classList.add('active');
            filtroTipo = this.dataset.filtroTipo;
            aplicarFiltros();
        });
    });

    document.querySelectorAll('[data-filtro-sexo]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-filtro-sexo]').forEach(function (b) { b.classList.remove('active'); });
            this.classList.add('active');
            filtroSexo = this.dataset.filtroSexo;
            aplicarFiltros();
        });
    });

    document.querySelectorAll('[data-filtro-tamanio]').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.querySelectorAll('[data-filtro-tamanio]').forEach(function (b) { b.classList.remove('active'); });
            this.classList.add('active');
            filtroTamanio = this.dataset.filtroTamanio;
            aplicarFiltros();
        });
    });

    document.getElementById('busquedaNombre').addEventListener('input', function () {
        filtroBusqueda = this.value;
        aplicarFiltros();
    });

    document.getElementById('toggleFiltrosAvanzados').addEventListener('click', function () {
        document.getElementById('filtrosAvanzados').classList.toggle('filtros-avanzados--visible');
        this.classList.toggle('active');
    });

    function limpiarTodo() {
        filtroTipo = 'todos'; filtroSexo = 'todos';
        filtroTamanio = 'todos'; filtroBusqueda = '';
        document.getElementById('busquedaNombre').value = '';
        document.querySelectorAll('[data-filtro-tipo]').forEach(function (b) { b.classList.remove('active'); });
        document.querySelector('[data-filtro-tipo="todos"]').classList.add('active');
        document.querySelectorAll('[data-filtro-sexo]').forEach(function (b) { b.classList.remove('active'); });
        document.querySelector('[data-filtro-sexo="todos"]').classList.add('active');
        document.querySelectorAll('[data-filtro-tamanio]').forEach(function (b) { b.classList.remove('active'); });
        document.querySelector('[data-filtro-tamanio="todos"]').classList.add('active');
        aplicarFiltros();
    }

    document.getElementById('limpiarFiltros').addEventListener('click', limpiarTodo);
    document.getElementById('limpiarFiltrosVacio').addEventListener('click', limpiarTodo);
</script>
</asp:Content>