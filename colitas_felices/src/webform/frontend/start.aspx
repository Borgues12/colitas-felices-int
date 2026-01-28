<%@ Page Title="" Language="C#" MasterPageFile="~/src/masterPage/index.Master" AutoEventWireup="true" CodeBehind="start.aspx.cs" Inherits="colitas_felices.src.webform.frontend.start" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TituloPlaceHolder" runat="server">
    Colitas Felices - Refugio de Animales en Quito
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <link href='<%=ResolveUrl("~/src/css/start_styles.css") %>' rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="body" runat="server">
    
    <!-- HERO SECTION -->
    <section class="hero">
        <div class="hero-background"></div>
        <div class="hero-content">
            <h1>Dale un hogar a quien más lo <span>necesita</span></h1>
            <p>En Colitas Felices creemos que cada animal merece una segunda oportunidad. 
               Únete a nuestra familia y cambia una vida para siempre.</p>
            <div class="hero-buttons">
                <a href="<%=ResolveUrl("~/adopciones") %>" class="btn btn-primary">
                    <i class="fas fa-heart"></i> Ver Mascotas
                </a>
                <a href="<%=ResolveUrl("~/donar") %>" class="btn btn-secondary" style="background: white;">
                    <i class="fas fa-hand-holding-heart"></i> Donar Ahora
                </a>
            </div>
        </div>
    </section>
    
    <!-- STATS SECTION -->
    <section class="stats-section">
        <div class="stats-container">
            <div class="stat-item">
                <span class="stat-number">15+</span>
                <span class="stat-label">Años de experiencia</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">500+</span>
                <span class="stat-label">Adopciones exitosas</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">90+</span>
                <span class="stat-label">Animales en refugio</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">200+</span>
                <span class="stat-label">Voluntarios activos</span>
            </div>
        </div>
    </section>
    
    <!-- ABOUT SECTION -->
    <section class="about-section">
        <div class="about-container">
            <div class="about-image">
                <img src="<%=ResolveUrl("~/src/webform/frontend/images/logo_pagina_rosa.jpeg") %>" alt="Refugio Colitas Felices" />
            </div>
            <div class="about-content">
                <h2>Sobre <span>Colitas Felices</span></h2>
                <p>
                    Somos un refugio ubicado en Calderón, Quito, dedicado al rescate, 
                    rehabilitación y adopción responsable de perros y gatos en situación 
                    de abandono.
                </p>
                <p>
                    Durante 15 años, Diana Cevallos y su equipo han trabajado 
                    incansablemente para darle una segunda oportunidad a cientos de 
                    animales que lo necesitan.
                </p>
                <a href="<%=ResolveUrl("~/quienes_somos") %>" class="btn btn-primary mt-2">
                    Conoce nuestra historia <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>
    
    <!-- PETS SECTION -->
    <section class="pets-section">
        <div class="section-header">
            <h2>Mascotas en Adopción</h2>
            <p>Conoce a algunos de nuestros peluditos que buscan un hogar lleno de amor</p>
        </div>
        <div class="pets-grid">
            <!-- Las tarjetas se cargarían dinámicamente -->
            <div class="pet-card">
                <div class="pet-image">
                    <img src="<%=ResolveUrl("~/Imagenes/mascotas/mascota1.jpg") %>" alt="Luna" />
                </div>
                <div class="pet-info">
                    <h3 class="pet-name">Luna</h3>
                    <div class="pet-details">
                        <span><i class="fas fa-dog"></i> Perro</span>
                        <span><i class="fas fa-venus"></i> Hembra</span>
                        <span><i class="fas fa-birthday-cake"></i> 2 años</span>
                    </div>
                    <a href="<%=ResolveUrl("~/detalle_mascota?id=1") %>" class="btn btn-primary">
                        Conocer más
                    </a>
                </div>
            </div>
            
            <div class="pet-card">
                <div class="pet-image">
                    <img src="<%=ResolveUrl("~/Imagenes/mascotas/mascota2.jpg") %>" alt="Max" />
                </div>
                <div class="pet-info">
                    <h3 class="pet-name">Max</h3>
                    <div class="pet-details">
                        <span><i class="fas fa-dog"></i> Perro</span>
                        <span><i class="fas fa-mars"></i> Macho</span>
                        <span><i class="fas fa-birthday-cake"></i> 3 años</span>
                    </div>
                    <a href="<%=ResolveUrl("~/detalle_mascota?id=2") %>" class="btn btn-primary">
                        Conocer más
                    </a>
                </div>
            </div>
            
            <div class="pet-card">
                <div class="pet-image">
                    <img src="<%=ResolveUrl("~/Imagenes/mascotas/mascota3.jpg") %>" alt="Michi" />
                </div>
                <div class="pet-info">
                    <h3 class="pet-name">Michi</h3>
                    <div class="pet-details">
                        <span><i class="fas fa-cat"></i> Gato</span>
                        <span><i class="fas fa-mars"></i> Macho</span>
                        <span><i class="fas fa-birthday-cake"></i> 1 año</span>
                    </div>
                    <a href="<%=ResolveUrl("~/detalle_mascota?id=3") %>" class="btn btn-primary">
                        Conocer más
                    </a>
                </div>
            </div>
            
            <div class="pet-card">
                <div class="pet-image">
                    <img src="<%=ResolveUrl("~/Imagenes/mascotas/mascota4.jpg") %>" alt="Nala" />
                </div>
                <div class="pet-info">
                    <h3 class="pet-name">Nala</h3>
                    <div class="pet-details">
                        <span><i class="fas fa-cat"></i> Gato</span>
                        <span><i class="fas fa-venus"></i> Hembra</span>
                        <span><i class="fas fa-birthday-cake"></i> 8 meses</span>
                    </div>
                    <a href="<%=ResolveUrl("~/detalle_mascota?id=4") %>" class="btn btn-primary">
                        Conocer más
                    </a>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-3">
            <a href="<%=ResolveUrl("~/adopciones") %>" class="btn btn-secondary">
                Ver todas las mascotas <i class="fas fa-arrow-right"></i>
            </a>
        </div>
    </section>
    
    <!-- CTA SECTION -->
    <section class="cta-section">
        <h2>¿Cómo puedes ayudar?</h2>
        <p>Existen muchas formas de colaborar con nuestra misión. Cada aporte cuenta.</p>
        <div class="cta-buttons">
            <a href="<%=ResolveUrl("~/donar") %>" class="btn btn-primary">
                <i class="fas fa-heart"></i> Donar
            </a>
            <a href="<%=ResolveUrl("~/apadrinar") %>" class="btn" style="background: white; color: #E91E63;">
                <i class="fas fa-paw"></i> Apadrinar
            </a>
            <a href="<%=ResolveUrl("~/voluntariado") %>" class="btn btn-success">
                <i class="fas fa-hands-helping"></i> Ser Voluntario
            </a>
        </div>
    </section>
    
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>