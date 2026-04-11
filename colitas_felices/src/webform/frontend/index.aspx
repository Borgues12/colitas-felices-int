<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master"
    AutoEventWireup="true" CodeBehind="index.aspx.cs"
    Inherits="colitas_felices.src.webform.frontend.index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Colitas Felices - Refugio de Animales en Quito
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/landing_page/index.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">

    <!-- HERO -->
    <section class="hero">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-12 col-lg-6">
                    <span class="cf-badge cf-badge--primario mb-3">Refugio en Calderón, Quito</span>
                    <h1 class="hero__title">
                        Dale un hogar a quien más lo <span>necesita</span>
                    </h1>
                    <p class="hero__text">
                        En Colitas Felices creemos que cada animal merece una segunda oportunidad.
                        Únete a nuestra familia y cambia una vida para siempre.
                    </p>
                    <div class="hero__buttons">
                        <a href="#" class="cf-btn cf-btn--primario cf-btn--lg">
                            <i class="fas fa-heart"></i> Ver Mascotas
                        </a>
                        <a href="#" class="cf-btn cf-btn--outline cf-btn--lg">
                            <i class="fas fa-hand-holding-heart"></i> Donar
                        </a>
                    </div>
                </div>
                <div class="col-12 col-lg-6 hero__image mt-4 mt-lg-0">
                    <%-- Imagen local de prueba --%>
                    <img src='<%=ResolveUrl("~/src/images/principal.jpg") %>' alt="Animales en el refugio" />
                </div>
            </div>
        </div>
    </section>

    <!-- STATS -->
    <section class="stats">
        <div class="container">
            <div class="row text-center g-4">
                <div class="col-6 col-md-3">
                    <span class="stats__number">15+</span>
                    <span class="stats__label">Años de experiencia</span>
                </div>
                <div class="col-6 col-md-3">
                    <span class="stats__number">500+</span>
                    <span class="stats__label">Adopciones exitosas</span>
                </div>
                <div class="col-6 col-md-3">
                    <span class="stats__number">90+</span>
                    <span class="stats__label">Animales en refugio</span>
                </div>
                <div class="col-6 col-md-3">
                    <span class="stats__number">200+</span>
                    <span class="stats__label">Voluntarios activos</span>
                </div>
            </div>
        </div>
    </section>

    <!-- MASCOTAS EN ADOPCIÓN — datos hardcodeados para prueba visual -->
    <section class="cf-section">
        <div class="container">
            <div class="cf-section__header">
                <h2 class="cf-section__title">Mascotas en Adopción</h2>
                <p class="cf-section__subtitle">Conoce a algunos de nuestros peluditos que buscan un hogar</p>
            </div>
            <div class="row g-4">

                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="cf-card">
                        <img class="cf-card__image" src='<%=ResolveUrl("~/src/images/testing/dog_photo1.jpg") %>' alt="Luna" />
                        <div class="cf-card__body">
                            <h3 class="cf-card__title">Luna</h3>
                            <div class="cf-card__meta">
                                <span><i class="fas fa-paw"></i> Perro</span>
                                <span><i class="fas fa-birthday-cake"></i> 2 años</span>
                            </div>
                            <a href="#" class="cf-btn cf-btn--primario w-100 justify-content-center">
                                Conocer más
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="cf-card">
                        <img class="cf-card__image" src='<%=ResolveUrl("~/src/images/testing/dog_photo2.jpg") %>' alt="Max" />
                        <div class="cf-card__body">
                            <h3 class="cf-card__title">Max</h3>
                            <div class="cf-card__meta">
                                <span><i class="fas fa-paw"></i> Perro</span>
                                <span><i class="fas fa-birthday-cake"></i> 3 años</span>
                            </div>
                            <a href="#" class="cf-btn cf-btn--primario w-100 justify-content-center">
                                Conocer más
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="cf-card">
                        <img class="cf-card__image" src='<%=ResolveUrl("~/src/images/testing/dog_photo3.jpg") %>' alt="Michi" />
                        <div class="cf-card__body">
                            <h3 class="cf-card__title">Michi</h3>
                            <div class="cf-card__meta">
                                <span><i class="fas fa-paw"></i> Gato</span>
                                <span><i class="fas fa-birthday-cake"></i> 1 año</span>
                            </div>
                            <a href="#" class="cf-btn cf-btn--primario w-100 justify-content-center">
                                Conocer más
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="cf-card">
                        <img class="cf-card__image" src='<%=ResolveUrl("~/src/images/testing/dog_photo4.jpg") %>' alt="Nala" />
                        <div class="cf-card__body">
                            <h3 class="cf-card__title">Nala</h3>
                            <div class="cf-card__meta">
                                <span><i class="fas fa-paw"></i> Gato</span>
                                <span><i class="fas fa-birthday-cake"></i> 8 meses</span>
                            </div>
                            <a href="#" class="cf-btn cf-btn--primario w-100 justify-content-center">
                                Conocer más
                            </a>
                        </div>
                    </div>
                </div>

            </div>
            <div class="text-center mt-5">
                <a href="#" class="cf-btn cf-btn--outline cf-btn--lg">
                    Ver todas las mascotas <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- SOBRE NOSOTROS -->
    <section class="cf-section cf-section--alt">
        <div class="container">
            <div class="row align-items-center g-5">
                <div class="col-12 col-md-5">
                    <img src='<%=ResolveUrl("~/src/images/logo_pagina_rosa.jpeg") %>'
                         alt="Refugio Colitas Felices"
                         style="border-radius: var(--radio-xl); width: 100%;" />
                </div>
                <div class="col-12 col-md-7">
                    <h2 class="cf-section__title text-start">
                        Sobre <span class="text-primario">Colitas Felices</span>
                    </h2>
                    <p class="mt-3" style="color: var(--color-texto-secundario);">
                        Somos un refugio en Calderón, Quito, dedicado al rescate y adopción
                        responsable de animales. Durante 15 años, Diana Cevallos y su equipo
                        han dado una segunda oportunidad a cientos de animales.
                    </p>
                    <a href="#" class="cf-btn cf-btn--primario mt-4">
                        Conoce nuestra historia <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta">
        <div class="container text-center">
            <h2 class="cta__title">¿Cómo puedes ayudar?</h2>
            <p class="cta__subtitle">Existen muchas formas de colaborar con nuestra misión.</p>
            <div class="d-flex justify-content-center gap-3 flex-wrap mt-4">
                <a href="#" class="cf-btn cf-btn--blanco cf-btn--lg">
                    <i class="fas fa-heart"></i> Donar
                </a>
                <a href="#" class="cf-btn cf-btn--blanco cf-btn--lg">
                    <i class="fas fa-paw"></i> Apadrinar
                </a>
                <a href="#" class="cf-btn cf-btn--blanco cf-btn--lg">
                    <i class="fas fa-hands-helping"></i> Voluntario
                </a>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
