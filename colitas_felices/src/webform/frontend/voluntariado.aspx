<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="voluntariado.aspx.cs" Inherits="colitas_felices.src.webform.frontend.voluntariado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Cómo Ayudar - Colitas Felices</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <%-- Poppins y Font Awesome ya vienen del Master, no duplicar --%>
    <link href='<%=ResolveUrl("~/src/css/frontend/ayudar_styles.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- ═══ HERO BANNER ═══ -->
    <section class="hero-ayudar">
        <div class="hero-ayudar__overlay"></div>
        <img src='<%=ResolveUrl("~/src/images/como_ayudar_foto.jpg") %>'
             alt="Animales del refugio Colitas Felices"
             class="hero-ayudar__img" />
        <div class="hero-ayudar__content">
            <div class="hero-ayudar__badge">
                <span class="hero-ayudar__badge-number">100+</span>
                <span class="hero-ayudar__badge-text">Donaciones<br />para nuestros<br />animalitos</span>
            </div>
            <h1 class="hero-ayudar__title">Con tu donación<br />
                <span>podemos seguir ayudando</span>
            </h1>
            <p class="hero-ayudar__subtitle">
                "Cada donación es un motor de esperanza que nos permite rescatar a más
                animales en situación de calle y brindarles la oportunidad de encontrar
                una familia que los ame."
            </p>
            <a href="#donar" class="btn-hero">
                <iconify-icon icon="mdi:heart"></iconify-icon> Conoce cómo puedes ayudar
            </a>
        </div>
    </section>

    <!-- ═══ RESUMEN: 3 FORMAS ═══ -->
    <section class="formas-ayudar">
        <div class="formas-ayudar__header">
            <h2>Hay muchas formas de ayudar, <span>cada aporte hace la diferencia</span></h2>
            <p>Apoya a los animalitos de las calles y maltratados que fueron rescatados y se encuentran en el refugio</p>
        </div>
        <div class="formas-ayudar__cards">

            <div class="forma-card">
                <div class="forma-card__icon">
                    <iconify-icon icon="mdi:home-heart"></iconify-icon>
                </div>
                <h3 class="forma-card__title">Adopta</h3>
                <p class="forma-card__desc">Abre tu corazón y tu hogar. Nuestro proceso busca el match perfecto entre tú y tu futuro mejor amigo.</p>
                <%-- → Galería de mascotas --%>
                <a href='<%=ResolveUrl("~/src/webform/frontend/adopciones.aspx") %>'
                   class="forma-card__btn">
                    Ver animales disponibles
                </a>
            </div>

            <div class="forma-card forma-card--featured">
                <div class="forma-card__icon">
                    <iconify-icon icon="mdi:paw-heart"></iconify-icon>
                </div>
                <h3 class="forma-card__title">Apadrina</h3>
                <p class="forma-card__desc">¿No puedes adoptar? Ayuda mensualmente a un animal específico para cubrir sus gastos de salud y comida.</p>
                <a href="#apadrinar" class="forma-card__btn">Quiero apadrinar</a>
            </div>

            <div class="forma-card">
                <div class="forma-card__icon">
                    <iconify-icon icon="mdi:account-group"></iconify-icon>
                </div>
                <h3 class="forma-card__title">Voluntariado</h3>
                <p class="forma-card__desc">Ser voluntario es formar parte del proceso que cambia la vida de una mascota para siempre.</p>
                <a href="#voluntariado" class="forma-card__btn">Quiero ser voluntario</a>
            </div>

        </div>
    </section>

    <!-- ═══ DONAR ═══ -->
    <section class="seccion-anchor" id="donar">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag">
                    <iconify-icon icon="mdi:hand-coin"></iconify-icon> Donaciones
                </span>
                <h2>Puedes dar donaciones como:</h2>
                <p>Tu generosidad se transforma directamente en alimento, medicina y refugio para nuestros rescatados</p>
            </div>

            <div class="donacion-orbital-wrapper">

                <div class="orbital-center">
                    <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>'
                         alt="Perrito del refugio"
                         class="orbital-center__img" />
                    <div class="orbital-center__textos">
                        <p class="orbital-text--pink">Adopta · Apadrina · Sé voluntario</p>
                        <p class="orbital-text--dark">Dona · Construye · Comparte</p>
                    </div>
                </div>

                <div class="orbital-item orbital-item--top-center">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:cash-multiple"></iconify-icon>
                    </div>
                    <span>Donaciones Económicas</span>
                </div>

                <div class="orbital-item orbital-item--top-right">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:pill"></iconify-icon>
                    </div>
                    <span>Medicamentos</span>
                </div>

                <div class="orbital-item orbital-item--mid-right">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:sofa"></iconify-icon>
                    </div>
                    <span>Muebles</span>
                </div>

                <div class="orbital-item orbital-item--bot-right">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:hammer-wrench"></iconify-icon>
                    </div>
                    <span>Material de construcción</span>
                </div>

                <div class="orbital-item orbital-item--bot-center">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:share-variant"></iconify-icon>
                    </div>
                    <span>Difusión en Redes</span>
                </div>

                <div class="orbital-item orbital-item--bot-left">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:tshirt-crew"></iconify-icon>
                    </div>
                    <span>Ropa</span>
                </div>

                <div class="orbital-item orbital-item--mid-left">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:bed"></iconify-icon>
                    </div>
                    <span>Cobijas</span>
                </div>

                <div class="orbital-item orbital-item--top-left">
                    <div class="orbital-item__icon">
                        <iconify-icon icon="mdi:food-variant"></iconify-icon>
                    </div>
                    <span>Comida</span>
                </div>

            </div>

            <p class="donacion-orbital-footer">Tu apoyo nos permite seguir rescatando.</p>

            <!-- Métodos de pago -->
            <div class="metodos-pago">

                <div class="metodo-card">
                    <div class="metodo-card__logo">
                        <div class="metodo-card__logo-placeholder">
                            <iconify-icon icon="mdi:bank"></iconify-icon>
                            <span>BANCO<br />PICHINCHA</span>
                        </div>
                    </div>
                    <div class="metodo-card__info">
                        <p><strong>Ahorros:</strong> 4523528600</p>
                        <p><strong>Cédula:</strong> 1718345406</p>
                        <p><strong>Teléfono:</strong> 0983750246</p>
                    </div>
                </div>

                <div class="metodo-card">
                    <div class="metodo-card__logo">
                        <div class="metodo-card__logo-placeholder metodo-card__logo-placeholder--deuna">
                            <iconify-icon icon="mdi:qrcode"></iconify-icon>
                            <span>deuna!</span>
                        </div>
                    </div>
                    <div class="metodo-card__info">
                        <p><strong>Usuario:</strong> @colitasfelices</p>
                        <%-- → WhatsApp para coordinar pago por deuna --%>
                        <a href="https://wa.me/593983750246?text=Hola,%20quiero%20hacer%20una%20donación%20por%20Deuna"
                           target="_blank" class="metodo-card__btn">
                            <iconify-icon icon="mdi:whatsapp"></iconify-icon> Coordinar pago
                        </a>
                    </div>
                </div>

                <div class="metodo-card">
                    <div class="metodo-card__logo">
                        <div class="metodo-card__logo-placeholder metodo-card__logo-placeholder--paypal">
                            <iconify-icon icon="mdi:credit-card"></iconify-icon>
                            <span>PayPal</span>
                        </div>
                    </div>
                    <div class="metodo-card__info">
                        <p>colitasfelices.diana@gmail.com</p>
                        <%-- → PayPal del refugio --%>
                        <a href="https://www.paypal.com/paypalme/colitasfelices"
                           target="_blank" class="metodo-card__btn">
                            <iconify-icon icon="mdi:heart"></iconify-icon> Donar ahora
                        </a>
                    </div>
                </div>

            </div>

            <!-- Rifa -->
            <div class="rifa-card">
                <div class="rifa-card__info">
                    <h3 class="rifa-card__title">
                        <iconify-icon icon="mdi:ticket"></iconify-icon> Rifa de Moto Eléctrica
                    </h3>
                    <p class="rifa-card__desc">
                        Precio del número: <strong>$5.00</strong> | Participa y ayúdanos a recaudar fondos.
                    </p>
                </div>
                <%-- → WhatsApp para comprar número de rifa --%>
                <a href="https://wa.me/593983750246?text=Hola,%20quiero%20participar%20en%20la%20rifa%20de%20la%20moto%20eléctrica"
                   target="_blank" class="rifa-card__btn">
                    <iconify-icon icon="mdi:whatsapp"></iconify-icon> Quiero un número
                </a>
            </div>

        </div>
    </section>

    <!-- ═══ APADRINAR ═══ -->
    <section class="seccion-anchor seccion-anchor--alt" id="apadrinar">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--purple">
                    <iconify-icon icon="mdi:paw-heart"></iconify-icon> Apadrinamiento
                </span>
                <h2>Apadrina a un animalito <span>y cambia su vida</span></h2>
                <p>No puedes adoptar pero quieres ayudar de forma directa. Apadrina a una mascota del refugio y cubre sus gastos mensuales de alimentación, salud y cuidado.</p>
            </div>

            <div class="apadrinar-grid">

                <div class="apadrinar-step">
                    <div class="apadrinar-step__numero">1</div>
                    <div class="apadrinar-step__content">
                        <h4>Elige a tu ahijado</h4>
                        <p>Navega por nuestra galería de animales y elige al que quieras apoyar. Cada uno tiene una historia especial.</p>
                    </div>
                </div>

                <div class="apadrinar-step">
                    <div class="apadrinar-step__numero">2</div>
                    <div class="apadrinar-step__content">
                        <h4>Define tu aporte</h4>
                        <p>Puedes aportar mensualmente la cantidad que desees. Cada dólar ayuda a cubrir comida, vacunas y atención veterinaria.</p>
                    </div>
                </div>

                <div class="apadrinar-step">
                    <div class="apadrinar-step__numero">3</div>
                    <div class="apadrinar-step__content">
                        <h4>Recibe actualizaciones</h4>
                        <p>Te enviaremos fotos y noticias de tu ahijado para que veas cómo tu apoyo transforma su vida.</p>
                    </div>
                </div>

            </div>

            <div class="seccion-visual">
                <div class="seccion-visual__img-wrapper">
                    <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>'
                         alt="Animales esperando padrinos"
                         class="seccion-visual__img" />
                </div>
            </div>

            <div class="seccion-cta">
                <%-- → WhatsApp para iniciar apadrinamiento --%>
                <a href="https://wa.me/593983750246?text=Hola,%20quiero%20apadrinar%20a%20una%20mascota%20de%20Colitas%20Felices"
                   target="_blank"
                   class="btn-seccion btn-seccion--purple">
                    <iconify-icon icon="mdi:whatsapp"></iconify-icon> Quiero apadrinar
                </a>
                <p class="seccion-cta__note">Te contactaremos por WhatsApp con los detalles del apadrinamiento</p>
            </div>

        </div>
    </section>

    <!-- ═══ VOLUNTARIADO ═══ -->
    <section class="seccion-anchor" id="voluntariado">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--green">
                    <iconify-icon icon="mdi:account-group"></iconify-icon> Voluntariado
                </span>
                <h2>Sé parte del cambio, <span>sé voluntario</span></h2>
                <p>Dona tu tiempo y habilidades. Ya sea que tengas unas horas libres al mes o necesites cumplir horas comunitarias, hay un lugar para ti en Colitas Felices.</p>
            </div>

            <div class="voluntariado-cards">

                <div class="vol-card">
                    <div class="vol-card__icon">
                        <iconify-icon icon="mdi:broom"></iconify-icon>
                    </div>
                    <h4>Limpieza y cuidado</h4>
                    <p>Ayuda con la limpieza de las áreas, baño de mascotas y mantenimiento general del refugio.</p>
                </div>

                <div class="vol-card">
                    <div class="vol-card__icon">
                        <iconify-icon icon="mdi:dog"></iconify-icon>
                    </div>
                    <h4>Paseo y socialización</h4>
                    <p>Saca a pasear a los perritos, juega con ellos y ayúdalos a socializar para facilitar su adopción.</p>
                </div>

                <div class="vol-card">
                    <div class="vol-card__icon">
                        <iconify-icon icon="mdi:camera"></iconify-icon>
                    </div>
                    <h4>Fotografía y difusión</h4>
                    <p>Toma fotos y videos de los animales para ayudarnos a publicarlos en redes sociales.</p>
                </div>

                <div class="vol-card">
                    <div class="vol-card__icon">
                        <iconify-icon icon="mdi:school"></iconify-icon>
                    </div>
                    <h4>Horas comunitarias</h4>
                    <p>¿Eres estudiante y necesitas cumplir horas? Regístrate y valida tus horas de servicio comunitario con nosotros.</p>
                </div>

            </div>

            <div class="seccion-visual">
                <div class="seccion-visual__img-wrapper">
                    <img src='<%=ResolveUrl("~/src/images/perro_ayudar.png") %>'
                         alt="Voluntarios en Colitas Felices"
                         class="seccion-visual__img" />
                </div>
            </div>

            <div class="seccion-cta">
                <%-- → WhatsApp para inscribirse como voluntario --%>
                <a href="https://wa.me/593983750246?text=Hola,%20me%20gustaría%20ser%20voluntario%20en%20Colitas%20Felices"
                   target="_blank"
                   class="btn-seccion btn-seccion--green">
                    <iconify-icon icon="mdi:whatsapp"></iconify-icon> Quiero ser voluntario
                </a>
                <p class="seccion-cta__note">Te contactaremos por WhatsApp para coordinar tu primera visita</p>
            </div>

        </div>
    </section>

    <!-- ═══ TIENDA SOLIDARIA ═══ -->
    <section class="seccion-anchor seccion-anchor--alt" id="tienda">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--orange">
                    <iconify-icon icon="mdi:store"></iconify-icon> Tienda Solidaria
                </span>
                <h2>Tienda con <span>Causa</span></h2>
                <p>Cada compra ayuda directamente al refugio. Todos los productos son hechos con amor y sus ganancias van al cuidado de nuestros animalitos.</p>
            </div>

            <div class="tienda-productos">

                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <div class="producto-card__img-placeholder">
                            <iconify-icon icon="mdi:shopping"></iconify-icon>
                            <span>Imagen producto</span>
                        </div>
                    </div>
                    <h4 class="producto-card__nombre">Collar Huellitas</h4>
                    <p class="producto-card__precio">$15.00</p>
                </div>

                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <div class="producto-card__img-placeholder">
                            <iconify-icon icon="mdi:shopping"></iconify-icon>
                            <span>Imagen producto</span>
                        </div>
                    </div>
                    <h4 class="producto-card__nombre">Camiseta Rescate</h4>
                    <p class="producto-card__precio">$10.00</p>
                </div>

                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <div class="producto-card__img-placeholder">
                            <iconify-icon icon="mdi:shopping"></iconify-icon>
                            <span>Imagen producto</span>
                        </div>
                    </div>
                    <h4 class="producto-card__nombre">Comedero Perritos</h4>
                    <p class="producto-card__precio">$10.00</p>
                </div>

            </div>

            <div class="seccion-cta">
                <%-- → WhatsApp para ver la tienda completa --%>
                <a href="https://wa.me/593983750246?text=Hola,%20me%20gustaría%20ver%20los%20productos%20de%20la%20tienda%20solidaria"
                   target="_blank"
                   class="btn-seccion btn-seccion--orange">
                    <iconify-icon icon="mdi:whatsapp"></iconify-icon> Ver tienda completa
                </a>
            </div>

        </div>
    </section>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>