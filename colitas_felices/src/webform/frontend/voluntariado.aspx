<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="voluntariado.aspx.cs" Inherits="colitas_felices.src.webform.frontend.voluntariado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <title>Cómo Ayudar - Colitas Felices</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&family=Playfair+Display:wght@700;800;900&display=swap" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href='<%=ResolveUrl("~/src/css/frontend/ayudar_styles.css") %>' rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- ═══ HERO BANNER ═══ -->
    <section class="hero-ayudar">
        <div class="hero-ayudar__overlay"></div>
        <img src="<%=ResolveUrl("~/src/images/como_ayudar_foto.jpg") %>" alt="Animales del refugio Colitas Felices" class="hero-ayudar__img">
        <div class="hero-ayudar__content">
            <div class="hero-ayudar__badge">
                <span class="hero-ayudar__badge-number">100+</span>
                <span class="hero-ayudar__badge-text">Donaciones<br>
                    para nuestros<br>
                    animalitos</span>
            </div>
            <h1 class="hero-ayudar__title">Con tu donación<br>
                <span>podemos seguir ayudando</span></h1>
            <p class="hero-ayudar__subtitle">"Cada donación es un motor de esperanza que nos permite rescatar a más animales en situación de calle y brindarles la oportunidad de encontrar una familia que los ame."</p>
            <a href="#donar" class="btn-hero"><i class="fas fa-heart"></i>Conoce como puedes ayudar</a>
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
                <div class="forma-card__icon"><i class="fas fa-home"></i></div>
                <h3 class="forma-card__title">Adopta</h3>
                <p class="forma-card__desc">Abre tu corazón y tu hogar. Nuestro proceso busca el match perfecto entre tú y tu futuro mejor amigo.</p>
                <a href="#" class="forma-card__btn">Ver animales disponibles</a>
            </div>
            <div class="forma-card forma-card--featured">
                <div class="forma-card__icon"><i class="fas fa-hand-holding-heart"></i></div>
                <h3 class="forma-card__title">Apadrina</h3>
                <p class="forma-card__desc">¿No puedes adoptar? Ayuda mensualmente a un animal específico para cubrir sus gastos de salud y comida.</p>
                <a href="#apadrinar" class="forma-card__btn">Quiero apadrinar</a>
            </div>
            <div class="forma-card">
                <div class="forma-card__icon"><i class="fas fa-users"></i></div>
                <h3 class="forma-card__title">Voluntariado</h3>
                <p class="forma-card__desc">Ser voluntario es formar parte del proceso que cambia la vida de una mascota para siempre.</p>
                <a href="#voluntariado" class="forma-card__btn">Quiero ser voluntario</a>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════════════════════════════════════
         SECCIÓN: DONAR  →  Ayúdanos > Donar
         ═══════════════════════════════════════════════════════════════ -->
    <section class="seccion-anchor" id="donar">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag"><i class="fas fa-donate"></i>Donaciones</span>
                <h2>Puedes dar donaciones como:</h2>
                <p>Tu generosidad se transforma directamente en alimento, medicina y refugio para nuestros rescatados</p>
            </div>


            <!-- HTML: pega esto donde estaban tus ítems + motivacional -->

            <div class="donacion-orbital-wrapper">

                <!-- Centro: perro libre, sin círculo -->
                <div class="orbital-center">
                    <img src="<%=ResolveUrl("~/src/images/perro_ayudar.png") %>" alt="Perrito del refugio" class="orbital-center__img">
                    <div class="orbital-center__textos">
                        <p class="orbital-text--pink">Adopta · Apadrina · Sé voluntario</p>
                        <p class="orbital-text--dark">Dona · Construye · Comparte</p>
                    </div>
                </div>

                <div class="orbital-item orbital-item--top-center">
                    <div class="orbital-item__icon"><i class="fas fa-money-bill-wave"></i></div>
                    <span>Donaciones Económicas</span>
                </div>

                <div class="orbital-item orbital-item--top-right">
                    <div class="orbital-item__icon"><i class="fas fa-pills"></i></div>
                    <span>Medicamentos</span>
                </div>

                <div class="orbital-item orbital-item--mid-right">
                    <div class="orbital-item__icon"><i class="fas fa-couch"></i></div>
                    <span>Muebles</span>
                </div>

                <div class="orbital-item orbital-item--bot-right">
                    <div class="orbital-item__icon"><i class="fas fa-hard-hat"></i></div>
                    <span>Material de construcción</span>
                </div>

                <div class="orbital-item orbital-item--bot-center">
                    <div class="orbital-item__icon"><i class="fas fa-share-alt"></i></div>
                    <span>Difusión en Redes</span>
                </div>

                <div class="orbital-item orbital-item--bot-left">
                    <div class="orbital-item__icon"><i class="fas fa-tshirt"></i></div>
                    <span>Ropa</span>
                </div>

                <div class="orbital-item orbital-item--mid-left">
                    <div class="orbital-item__icon"><i class="fas fa-blanket"></i></div>
                    <span>Cobijas</span>
                </div>

                <div class="orbital-item orbital-item--top-left">
                    <div class="orbital-item__icon"><i class="fas fa-bone"></i></div>
                    <span>Comida</span>
                </div>

            </div>

            <p class="donacion-orbital-footer">Tu apoyo nos permite seguir rescatando.</p>



            <!-- Métodos de pago -->
            <div class="metodos-pago">
                <div class="metodo-card">
                    <div class="metodo-card__logo">
                        <div class="metodo-card__logo-placeholder">
                            <i class="fas fa-university"></i><span>BANCO<br>
                                PICHINCHA</span>
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
                        <div class="metodo-card__logo-placeholder metodo-card__logo-placeholder--deuna"><i class="fas fa-qrcode"></i><span>deuna!</span></div>
                    </div>
                </div>
                <div class="metodo-card">
                    <div class="metodo-card__logo">
                        <div class="metodo-card__logo-placeholder metodo-card__logo-placeholder--paypal"><i class="fab fa-paypal"></i><span>PayPal</span></div>
                    </div>
                    <div class="metodo-card__info">
                        <p>colitasfelices@gmail.com</p>
                        <a href="#" class="metodo-card__btn">Donar ahora</a>
                    </div>
                </div>
            </div>

            <!-- Rifa -->
            <div class="rifa-card">
                <div class="rifa-card__info">
                    <h3 class="rifa-card__title"><i class="fas fa-ticket-alt"></i>Rifa de Moto Eléctrica</h3>
                    <p class="rifa-card__desc">Precio del número: <strong>$5.00</strong> | Participa y ayúdanos a recaudar fondos.</p>
                </div>
                <a href="#" class="rifa-card__btn">Quiero un número</a>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════════════════════════════════════
         SECCIÓN: APADRINAR  →  Ayúdanos > Apadrinar
         ═══════════════════════════════════════════════════════════════ -->
    <section class="seccion-anchor seccion-anchor--alt" id="apadrinar">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--purple"><i class="fas fa-hand-holding-heart"></i>Apadrinamiento</span>
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
                    <img src="" alt="Animales esperando padrinos" class="seccion-visual__img">
                    <div class="seccion-visual__placeholder"><i class="fas fa-paw"></i><span>Imagen de animales del refugio</span></div>
                </div>
            </div>

            <div class="seccion-cta">
                <a href="#" class="btn-seccion btn-seccion--purple"><i class="fas fa-heart"></i>Quiero apadrinar</a>
                <p class="seccion-cta__note">Te contactaremos por correo con los detalles del apadrinamiento</p>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════════════════════════════════════
         SECCIÓN: VOLUNTARIADO  →  Ayúdanos > Voluntariado
         ═══════════════════════════════════════════════════════════════ -->
    <section class="seccion-anchor" id="voluntariado">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--green"><i class="fas fa-users"></i>Voluntariado</span>
                <h2>Sé parte del cambio, <span>sé voluntario</span></h2>
                <p>Dona tu tiempo y habilidades. Ya sea que tengas unas horas libres al mes o necesites cumplir horas comunitarias, hay un lugar para ti en Colitas Felices.</p>
            </div>

            <div class="voluntariado-cards">
                <div class="vol-card">
                    <div class="vol-card__icon"><i class="fas fa-broom"></i></div>
                    <h4>Limpieza y cuidado</h4>
                    <p>Ayuda con la limpieza de las áreas, baño de mascotas y mantenimiento general del refugio.</p>
                </div>
                <div class="vol-card">
                    <div class="vol-card__icon"><i class="fas fa-dog"></i></div>
                    <h4>Paseo y socialización</h4>
                    <p>Saca a pasear a los perritos, juega con ellos y ayúdalos a socializar para facilitar su adopción.</p>
                </div>
                <div class="vol-card">
                    <div class="vol-card__icon"><i class="fas fa-camera"></i></div>
                    <h4>Fotografía y difusión</h4>
                    <p>Toma fotos y videos de los animales para ayudarnos a publicarlos en redes sociales.</p>
                </div>
                <div class="vol-card">
                    <div class="vol-card__icon"><i class="fas fa-graduation-cap"></i></div>
                    <h4>Horas comunitarias</h4>
                    <p>¿Eres estudiante y necesitas cumplir horas? Regístrate y valida tus horas de servicio comunitario con nosotros.</p>
                </div>
            </div>

            <div class="seccion-visual">
                <div class="seccion-visual__img-wrapper">
                    <img src="" alt="Voluntarios en Colitas Felices" class="seccion-visual__img">
                    <div class="seccion-visual__placeholder"><i class="fas fa-camera"></i><span>Imagen de voluntarios</span></div>
                </div>
            </div>

            <div class="seccion-cta">
                <a href="#" class="btn-seccion btn-seccion--green"><i class="fas fa-hand-paper"></i>Quiero ser voluntario</a>
                <p class="seccion-cta__note">Completa el formulario y te contactaremos para coordinar tu primera visita</p>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════════════════════════════════════
         SECCIÓN: TIENDA SOLIDARIA  →  Ayúdanos > Tienda Solidaria
         ═══════════════════════════════════════════════════════════════ -->
    <section class="seccion-anchor seccion-anchor--alt" id="tienda">
        <div class="seccion-anchor__container">
            <div class="seccion__encabezado">
                <span class="seccion__tag seccion__tag--orange"><i class="fas fa-store"></i>Tienda Solidaria</span>
                <h2>Tienda con <span>Causa</span></h2>
                <p>Cada compra ayuda directamente al refugio. Todos los productos son hechos con amor y sus ganancias van al cuidado de nuestros animalitos.</p>
            </div>

            <div class="tienda-productos">
                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <img src="" alt="Collar Huellitas" class="producto-card__img">
                        <div class="producto-card__img-placeholder"><i class="fas fa-shopping-bag"></i><span>Imagen producto</span></div>
                    </div>
                    <h4 class="producto-card__nombre">Collar Huellitas</h4>
                    <p class="producto-card__precio">$15.00</p>
                </div>
                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <img src="" alt="Camiseta Rescate" class="producto-card__img">
                        <div class="producto-card__img-placeholder"><i class="fas fa-shopping-bag"></i><span>Imagen producto</span></div>
                    </div>
                    <h4 class="producto-card__nombre">Camiseta Rescate</h4>
                    <p class="producto-card__precio">$10.00</p>
                </div>
                <div class="producto-card">
                    <div class="producto-card__img-wrapper">
                        <img src="" alt="Comedero Perritos" class="producto-card__img">
                        <div class="producto-card__img-placeholder"><i class="fas fa-shopping-bag"></i><span>Imagen producto</span></div>
                    </div>
                    <h4 class="producto-card__nombre">Comedero Perritos</h4>
                    <p class="producto-card__precio">$10.00</p>
                </div>
            </div>

            <div class="seccion-cta">
                <a href="#" class="btn-seccion btn-seccion--orange">Ver tienda completa</a>
            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
