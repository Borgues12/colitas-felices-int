<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="nosotros.aspx.cs" Inherits="colitas_felices.src.webform.frontend.nosotros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Nosotros - Colitas Felices
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/frontend/nosotros_styles.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- HERO -->
    <section class="nosotros-hero">
        <div class="nosotros-hero__overlay"></div>
        <div class="nosotros-hero__content">
            <span class="nosotros-hero__tag">
                <iconify-icon icon="mdi:paw"></iconify-icon> Conoce nuestra historia
            </span>
            <h1 class="nosotros-hero__title">Colitas <span>Felices</span></h1>
            <p class="nosotros-hero__subtitle">15 años dedicados al rescate y amor animal en Calderón</p>
            <div class="nosotros-hero__nav">
                <a href="#quienes-somos" class="nosotros-hero__pill">¿Quiénes Somos?</a>
                <a href="#nuestra-historia" class="nosotros-hero__pill">Nuestra Historia</a>
                <a href="#nuestro-equipo" class="nosotros-hero__pill">Nuestro Equipo</a>
                <a href="#contacto" class="nosotros-hero__pill">Contacto</a>
            </div>
        </div>
        <div class="nosotros-hero__paws">
            <iconify-icon icon="mdi:paw"></iconify-icon>
            <iconify-icon icon="mdi:paw"></iconify-icon>
            <iconify-icon icon="mdi:paw"></iconify-icon>
            <iconify-icon icon="mdi:paw"></iconify-icon>
            <iconify-icon icon="mdi:paw"></iconify-icon>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECCIÓN 1: QUIÉNES SOMOS
    ══════════════════════════════════════════════════ -->
    <section id="quienes-somos" class="qs-section">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">
                    <iconify-icon icon="mdi:heart"></iconify-icon> Sobre nosotros
                </span>
                <h2 class="section-title">¿Quiénes Somos?</h2>
                <p class="section-subtitle">Una familia unida por el amor a los animales</p>
            </div>

            <div class="qs-grid">

                <div class="qs-main-card">
                    <div class="qs-main-card__icon">
                        <iconify-icon icon="mdi:home-heart"></iconify-icon>
                    </div>
                    <h3>Somos un refugio con corazón</h3>
                    <p>Colitas Felices es una fundación legal dedicada al rescate, rehabilitación y adopción responsable de animales en situación de calle. Nacimos del amor puro y hoy somos una organización formal comprometida con cada vida animal.</p>
                    <p>Vivimos en el refugio, somos 4 personas dedicadas 24/7 al cuidado de nuestros peludos, porque para nosotros esto no es un trabajo, <strong>es una misión de vida.</strong></p>
                    <div class="qs-main-card__stats">
                        <div class="qs-stat">
                            <span class="qs-stat__number">15+</span>
                            <span class="qs-stat__label">Años de trabajo</span>
                        </div>
                        <div class="qs-stat">
                            <span class="qs-stat__number">4</span>
                            <span class="qs-stat__label">Cuidadores 24/7</span>
                        </div>
                        <div class="qs-stat">
                            <span class="qs-stat__number">100s</span>
                            <span class="qs-stat__label">Animales rescatados</span>
                        </div>
                    </div>
                </div>

                <div class="qs-mv-stack">
                    <div class="qs-mv-card qs-mv-card--mision">
                        <div class="qs-mv-card__header">
                            <iconify-icon icon="mdi:hand-heart" class="qs-mv-card__icon"></iconify-icon>
                            <h3>Nuestra Misión</h3>
                        </div>
                        <p>"Rescatar, recuperar y encontrar hogares llenos de amor para cada animal que llega a nosotros."</p>
                        <ul class="qs-mv-list">
                            <li><iconify-icon icon="mdi:check-circle"></iconify-icon> Rescate de animales en peligro</li>
                            <li><iconify-icon icon="mdi:check-circle"></iconify-icon> Rehabilitación física y emocional</li>
                            <li><iconify-icon icon="mdi:check-circle"></iconify-icon> Adopciones responsables</li>
                            <li><iconify-icon icon="mdi:check-circle"></iconify-icon> Esterilizaciones masivas gratuitas</li>
                        </ul>
                    </div>

                    <div class="qs-mv-card qs-mv-card--vision">
                        <div class="qs-mv-card__header">
                            <iconify-icon icon="mdi:earth" class="qs-mv-card__icon"></iconify-icon>
                            <h3>Nuestra Visión</h3>
                        </div>
                        <p>"Un mundo sin animales abandonados, donde cada ser vivo tenga un hogar seguro y una familia que lo ame."</p>
                        <div class="qs-mv-card__quote">
                            <em>Cada rescate es una promesa de amor cumplida</em>
                        </div>
                    </div>
                </div>

            </div>

            <div class="qs-valores">
                <div class="qs-valor-card">
                    <iconify-icon icon="mdi:heart" class="qs-valor-icon"></iconify-icon>
                    <h4>Amor</h4>
                    <p>Cada animal recibe el mismo amor que daríamos a nuestra familia</p>
                </div>
                <div class="qs-valor-card">
                    <iconify-icon icon="mdi:shield-heart" class="qs-valor-icon"></iconify-icon>
                    <h4>Compromiso</h4>
                    <p>Vivimos en el refugio para nunca abandonar a quien nos necesita</p>
                </div>
                <div class="qs-valor-card">
                    <iconify-icon icon="mdi:account-group" class="qs-valor-icon"></iconify-icon>
                    <h4>Comunidad</h4>
                    <p>Trabajamos con voluntarios y donantes que comparten nuestra causa</p>
                </div>
                <div class="qs-valor-card">
                    <iconify-icon icon="mdi:scale-balance" class="qs-valor-icon"></iconify-icon>
                    <h4>Responsabilidad</h4>
                    <p>Operamos como fundación legal con transparencia total</p>
                </div>
            </div>

        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECCIÓN 2: NUESTRA HISTORIA
    ══════════════════════════════════════════════════ -->
    <section id="nuestra-historia" class="historia-section">
        <div class="container">
            <div class="section-header section-header--light">
                <span class="section-badge section-badge--white">
                    <iconify-icon icon="mdi:book-open-variant"></iconify-icon> Nuestro camino
                </span>
                <h2 class="section-title section-title--white">Nuestra Historia</h2>
                <p class="section-subtitle section-subtitle--white">De un sueño informal a una fundación que cambia vidas</p>
            </div>

            <div class="historia-timeline">

                <div class="timeline-item timeline-item--left">
                    <div class="timeline-dot">
                        <iconify-icon icon="mdi:dog"></iconify-icon>
                    </div>
                    <div class="timeline-card">
                        <span class="timeline-year">2009</span>
                        <h3>El primer rescate</h3>
                        <p>Todo comenzó con un acto de amor: rescatar a un perrito de la calle. Ese día cambió todo. Comenzamos a trabajar de manera informal, movidos por la pasión y el corazón.</p>
                        <div class="timeline-card__tag">Inicio del sueño</div>
                    </div>
                </div>

                <div class="timeline-item timeline-item--right">
                    <div class="timeline-dot">
                        <iconify-icon icon="mdi:scissors-cutting"></iconify-icon>
                    </div>
                    <div class="timeline-card">
                        <span class="timeline-year">2012 - 2020</span>
                        <h3>Esterilizaciones masivas</h3>
                        <p>Impulsamos campañas de esterilización gratuita en Calderón, ayudando a controlar la población de animales en situación de calle y concientizando a la comunidad.</p>
                        <div class="timeline-card__tag">Impacto comunitario</div>
                    </div>
                </div>

                <div class="timeline-item timeline-item--left">
                    <div class="timeline-dot">
                        <iconify-icon icon="mdi:trophy"></iconify-icon>
                    </div>
                    <div class="timeline-card">
                        <span class="timeline-year">2018</span>
                        <h3>Campeones de Frisbee</h3>
                        <p>Uno de nuestros rescatados, un Pastor Belga, se convirtió en <strong>Campeón de Frisbee</strong>. Un orgullo enorme que demostró el potencial de los animales rescatados.</p>
                        <div class="timeline-card__tag">
                            <iconify-icon icon="mdi:medal"></iconify-icon> Logro deportivo
                        </div>
                    </div>
                </div>

                <div class="timeline-item timeline-item--right">
                    <div class="timeline-dot">
                        <iconify-icon icon="mdi:file-document"></iconify-icon>
                    </div>
                    <div class="timeline-card">
                        <span class="timeline-year">2022</span>
                        <h3>Fundación legal</h3>
                        <p>Después de 13 años de trabajo informal, dimos el gran paso: constituirnos como <strong>fundación legal</strong>. Un hito que nos permitió crecer, organizarnos y ayudar más.</p>
                        <div class="timeline-card__tag">Hito institucional</div>
                    </div>
                </div>

                <div class="timeline-item timeline-item--left">
                    <div class="timeline-dot">
                        <iconify-icon icon="mdi:star"></iconify-icon>
                    </div>
                    <div class="timeline-card timeline-card--highlight">
                        <span class="timeline-year">Hoy</span>
                        <h3>Colitas Felices continúa</h3>
                        <p>Con más de 15 años de trayectoria, seguimos rescatando, rehabilitando y encontrando hogares. Cada día es una nueva oportunidad de hacer la diferencia.</p>
                        <div class="timeline-card__tag">Presente y futuro</div>
                    </div>
                </div>

            </div>

            <div class="historia-logros">
                <h3 class="historia-logros__title">
                    <iconify-icon icon="mdi:medal"></iconify-icon> Logros Destacados
                </h3>
                <div class="historia-logros__grid">
                    <div class="logro-card">
                        <iconify-icon icon="mdi:trophy" class="logro-card__icon"></iconify-icon>
                        <h4>Campeón de Frisbee</h4>
                        <p>Pastor Belga rescatado que llegó a ser campeón nacional</p>
                    </div>
                    <div class="logro-card">
                        <iconify-icon icon="mdi:paw" class="logro-card__icon"></iconify-icon>
                        <h4>Cientos de rescates</h4>
                        <p>Animales salvados de las calles que encontraron un hogar</p>
                    </div>
                    <div class="logro-card">
                        <iconify-icon icon="mdi:scissors-cutting" class="logro-card__icon"></iconify-icon>
                        <h4>Esterilizaciones masivas</h4>
                        <p>Campañas gratuitas para controlar la sobrepoblación</p>
                    </div>
                    <div class="logro-card">
                        <iconify-icon icon="mdi:scale-balance" class="logro-card__icon"></iconify-icon>
                        <h4>Fundación legal</h4>
                        <p>2 años operando formalmente con total transparencia</p>
                    </div>
                </div>
            </div>

        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECCIÓN 3: NUESTRO EQUIPO
    ══════════════════════════════════════════════════ -->
    <section id="nuestro-equipo" class="equipo-section">
        <div class="container">
            <div class="section-header">
                <span class="section-badge">
                    <iconify-icon icon="mdi:account-group"></iconify-icon> Las personas detrás
                </span>
                <h2 class="section-title">Nuestro Equipo</h2>
                <p class="section-subtitle">4 personas que lo dieron todo por los animales</p>
            </div>

            <div class="equipo-banner">
                <div class="equipo-banner__text">
                    <h3>"Vivimos en el refugio"</h3>
                    <p>No somos solo voluntarios que vienen y van. Somos 4 personas dedicadas <strong>24 horas, 7 días a la semana</strong> al cuidado de los animales. El refugio es nuestro hogar.</p>
                    <div class="equipo-banner__badges">
                        <span><iconify-icon icon="mdi:weather-night"></iconify-icon> Noches en el refugio</span>
                        <span><iconify-icon icon="mdi:food"></iconify-icon> Alimentamos a diario</span>
                        <span><iconify-icon icon="mdi:medical-bag"></iconify-icon> Cuidado veterinario</span>
                        <span><iconify-icon icon="mdi:heart"></iconify-icon> Amor incondicional</span>
                    </div>
                </div>
                <div class="equipo-banner__visual">
                    <div class="equipo-counter">
                        <div class="equipo-counter__item">
                            <strong>4</strong>
                            <span>Cuidadores</span>
                        </div>
                        <div class="equipo-counter__item">
                            <strong>24/7</strong>
                            <span>Dedicación</span>
                        </div>
                        <div class="equipo-counter__item">
                            <strong>365</strong>
                            <span>Días al año</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="equipo-grid">

                <div class="equipo-card">
                    <div class="equipo-card__avatar equipo-card__avatar--1">
                        <iconify-icon icon="mdi:account"></iconify-icon>
                    </div>
                    <div class="equipo-card__body">
                        <h4>Fundador & Rescatista</h4>
                        <p class="equipo-card__role">Coordinación general · Rescates</p>
                        <p>El corazón detrás de Colitas Felices. Lleva 15 años dedicando su vida a los animales en situación de calle.</p>
                    </div>
                    <div class="equipo-card__footer">
                        <iconify-icon icon="mdi:home-heart"></iconify-icon> Vive en el refugio
                    </div>
                </div>

                <div class="equipo-card equipo-card--featured">
                    <div class="equipo-card__badge">
                        <iconify-icon icon="mdi:star"></iconify-icon> Equipo
                    </div>
                    <div class="equipo-card__avatar equipo-card__avatar--2">
                        <iconify-icon icon="mdi:account"></iconify-icon>
                    </div>
                    <div class="equipo-card__body">
                        <h4>Cuidadora Principal</h4>
                        <p class="equipo-card__role">Alimentación · Salud animal</p>
                        <p>Responsable del bienestar diario de cada animal. Nadie mejor que ella conoce las necesidades de nuestros peludos.</p>
                    </div>
                    <div class="equipo-card__footer">
                        <iconify-icon icon="mdi:home-heart"></iconify-icon> Vive en el refugio
                    </div>
                </div>

                <div class="equipo-card">
                    <div class="equipo-card__avatar equipo-card__avatar--3">
                        <iconify-icon icon="mdi:account"></iconify-icon>
                    </div>
                    <div class="equipo-card__body">
                        <h4>Entrenador & Rehabilitador</h4>
                        <p class="equipo-card__role">Entrenamiento · Adopciones</p>
                        <p>Especialista en rehabilitación conductual. Gracias a su trabajo, nuestros animales están listos para sus nuevos hogares.</p>
                    </div>
                    <div class="equipo-card__footer">
                        <iconify-icon icon="mdi:home-heart"></iconify-icon> Vive en el refugio
                    </div>
                </div>

                <div class="equipo-card">
                    <div class="equipo-card__avatar equipo-card__avatar--4">
                        <iconify-icon icon="mdi:account"></iconify-icon>
                    </div>
                    <div class="equipo-card__body">
                        <h4>Coordinadora de Adopciones</h4>
                        <p class="equipo-card__role">Adopciones · Comunicación</p>
                        <p>Conecta a las familias con su animal ideal. Asegura que cada adopción sea responsable y duradera.</p>
                    </div>
                    <div class="equipo-card__footer">
                        <iconify-icon icon="mdi:home-heart"></iconify-icon> Vive en el refugio
                    </div>
                </div>

            </div>

            <!-- Únete como voluntario -->
            <div class="equipo-voluntario">
                <div class="equipo-voluntario__content">
                    <iconify-icon icon="mdi:hand-heart" class="equipo-voluntario__icon"></iconify-icon>
                    <div>
                        <h3>¿Quieres ser parte de nuestra familia?</h3>
                        <p>Siempre buscamos voluntarios comprometidos que amen a los animales y quieran hacer la diferencia.</p>
                    </div>
                    <%-- → Sección voluntariado en ayúdanos --%>
                    <a href='<%=ResolveUrl("~/src/webform/frontend/voluntariado.aspx#voluntariado") %>'
                       class="btn btn-primary">
                        <iconify-icon icon="mdi:account-plus"></iconify-icon> Ser Voluntario
                    </a>
                </div>
            </div>

        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECCIÓN 4: CONTACTO / UBICACIÓN
         id="contacto" para que el nav funcione
    ══════════════════════════════════════════════════ -->
    <section id="contacto" class="nosotros-ubicacion">
        <div class="container">
            <div class="ubicacion-inner">

                <div class="ubicacion-info">
                    <span class="section-badge">
                        <iconify-icon icon="mdi:map-marker"></iconify-icon> Visítanos
                    </span>
                    <h2>Encuéntranos en Calderón</h2>
                    <p>Estamos ubicados en el sector de Calderón, Quito. ¡Ven a conocer el refugio y a nuestros peludos!</p>

                    <div class="ubicacion-details">

                        <div class="ubicacion-detail">
                            <div class="ubicacion-detail__icon">
                                <iconify-icon icon="mdi:map-marker"></iconify-icon>
                            </div>
                            <div>
                                <strong>Dirección</strong>
                                <p>Calderón, Quito, Ecuador</p>
                                <p>Detrás del Estadio de Calderón,<br />bajo el puente, puerta negra</p>
                            </div>
                        </div>

                        <div class="ubicacion-detail">
                            <div class="ubicacion-detail__icon">
                                <iconify-icon icon="mdi:clock-outline"></iconify-icon>
                            </div>
                            <div>
                                <strong>Horario de visitas</strong>
                                <p>Lunes a Viernes: 9:00 - 17:00</p>
                                <p>Sábados: 9:00 - 14:00</p>
                                <p>Domingos: Cerrado</p>
                            </div>
                        </div>

                        <div class="ubicacion-detail">
                            <div class="ubicacion-detail__icon">
                                <iconify-icon icon="mdi:phone"></iconify-icon>
                            </div>
                            <div>
                                <strong>Teléfono / WhatsApp</strong>
                                <p>+593 98 375 0246</p>
                            </div>
                        </div>

                        <div class="ubicacion-detail">
                            <div class="ubicacion-detail__icon">
                                <iconify-icon icon="mdi:email"></iconify-icon>
                            </div>
                            <div>
                                <strong>Correo</strong>
                                <p>colitasfelices.diana@gmail.com</p>
                            </div>
                        </div>

                    </div>

                    <%-- Botones de contacto --%>
                    <div class="ubicacion-btns">
                        <%-- WhatsApp directo con mensaje predefinido --%>
                        <a href="https://wa.me/593983750246?text=Hola,%20me%20gustaría%20obtener%20más%20información%20sobre%20Colitas%20Felices"
                           target="_blank" class="btn btn-primary">
                            <iconify-icon icon="mdi:whatsapp"></iconify-icon> Contactar por WhatsApp
                        </a>
                        <%-- Redes sociales --%>
                        <div class="ubicacion-sociales">
                            <a href="https://www.facebook.com/colitasfelicesecuador/"
                               target="_blank" class="contacto-social-btn" title="Facebook">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a href="https://www.instagram.com/colitasfelicesecuador"
                               target="_blank" class="contacto-social-btn" title="Instagram">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a href="https://www.tiktok.com/@colitasfelicesdiana"
                               target="_blank" class="contacto-social-btn" title="TikTok">
                                <i class="fab fa-tiktok"></i>
                            </a>
                        </div>
                    </div>

                </div>

                <div class="ubicacion-mapa">
                    <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d15957.12!2d-78.4419!3d-0.0958!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x91d59a7e8b12c34d%3A0x0!2sCalderon%2C+Quito%2C+Ecuador!5e0!3m2!1ses!2sec!4v1700000000000"
                        width="100%" height="380"
                        style="border:0; border-radius: 16px;"
                        allowfullscreen="" loading="lazy"
                        referrerpolicy="no-referrer-when-downgrade">
                    </iframe>
                </div>

            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>