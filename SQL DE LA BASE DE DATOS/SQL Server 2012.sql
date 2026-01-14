/* ============================================== */
/*  BASE DE DATOS: Colitas Felices               */
/*  Sistema de Gestión para Refugio de Animales  */
/*  Versión Simplificada - MVP                   */
/*  DBMS: SQL Server 2012+                       */
/*  Fecha: 30-dic-2025                           */
/* ============================================== */

-- Crear base de datos (opcional, descomentar si es necesario)
-- CREATE DATABASE ColitasFelices;
-- GO
-- USE ColitasFelices;
-- GO

/* ============================================== */
/*  ELIMINAR FOREIGN KEYS EXISTENTES             */
/* ============================================== */

IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Sesion_Usuario')
    ALTER TABLE Sesion DROP CONSTRAINT FK_Sesion_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_FotoMascota_Mascota')
    ALTER TABLE FotoMascota DROP CONSTRAINT FK_FotoMascota_Mascota;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_HistorialMascota_Mascota')
    ALTER TABLE HistorialMascota DROP CONSTRAINT FK_HistorialMascota_Mascota;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_HistorialMascota_Usuario')
    ALTER TABLE HistorialMascota DROP CONSTRAINT FK_HistorialMascota_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SolicitudAdopcion_Usuario')
    ALTER TABLE SolicitudAdopcion DROP CONSTRAINT FK_SolicitudAdopcion_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SolicitudAdopcion_Mascota')
    ALTER TABLE SolicitudAdopcion DROP CONSTRAINT FK_SolicitudAdopcion_Mascota;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Adopcion_Solicitud')
    ALTER TABLE Adopcion DROP CONSTRAINT FK_Adopcion_Solicitud;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SeguimientoAdopcion_Adopcion')
    ALTER TABLE SeguimientoAdopcion DROP CONSTRAINT FK_SeguimientoAdopcion_Adopcion;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Reingreso_Adopcion')
    ALTER TABLE Reingreso DROP CONSTRAINT FK_Reingreso_Adopcion;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Certificado_Adopcion')
    ALTER TABLE Certificado DROP CONSTRAINT FK_Certificado_Adopcion;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Voluntario_Usuario')
    ALTER TABLE Voluntario DROP CONSTRAINT FK_Voluntario_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_ActividadVoluntario_Voluntario')
    ALTER TABLE ActividadVoluntario DROP CONSTRAINT FK_ActividadVoluntario_Voluntario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Pedido_Usuario')
    ALTER TABLE Pedido DROP CONSTRAINT FK_Pedido_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DetallePedido_Pedido')
    ALTER TABLE DetallePedido DROP CONSTRAINT FK_DetallePedido_Pedido;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DetallePedido_Producto')
    ALTER TABLE DetallePedido DROP CONSTRAINT FK_DetallePedido_Producto;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BoletoRifa_Rifa')
    ALTER TABLE BoletoRifa DROP CONSTRAINT FK_BoletoRifa_Rifa;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_BoletoRifa_Usuario')
    ALTER TABLE BoletoRifa DROP CONSTRAINT FK_BoletoRifa_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Donacion_Usuario')
    ALTER TABLE Donacion DROP CONSTRAINT FK_Donacion_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Padrino_Usuario')
    ALTER TABLE Padrino DROP CONSTRAINT FK_Padrino_Usuario;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Padrino_Mascota')
    ALTER TABLE Padrino DROP CONSTRAINT FK_Padrino_Mascota;
IF EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Notificacion_Usuario')
    ALTER TABLE Notificacion DROP CONSTRAINT FK_Notificacion_Usuario;
GO

/* ============================================== */
/*  ELIMINAR TABLAS EXISTENTES                   */
/* ============================================== */

IF OBJECT_ID('Notificacion', 'U') IS NOT NULL DROP TABLE Notificacion;
IF OBJECT_ID('Padrino', 'U') IS NOT NULL DROP TABLE Padrino;
IF OBJECT_ID('Donacion', 'U') IS NOT NULL DROP TABLE Donacion;
IF OBJECT_ID('BoletoRifa', 'U') IS NOT NULL DROP TABLE BoletoRifa;
IF OBJECT_ID('Rifa', 'U') IS NOT NULL DROP TABLE Rifa;
IF OBJECT_ID('DetallePedido', 'U') IS NOT NULL DROP TABLE DetallePedido;
IF OBJECT_ID('Pedido', 'U') IS NOT NULL DROP TABLE Pedido;
IF OBJECT_ID('Producto', 'U') IS NOT NULL DROP TABLE Producto;
IF OBJECT_ID('ActividadVoluntario', 'U') IS NOT NULL DROP TABLE ActividadVoluntario;
IF OBJECT_ID('Voluntario', 'U') IS NOT NULL DROP TABLE Voluntario;
IF OBJECT_ID('Certificado', 'U') IS NOT NULL DROP TABLE Certificado;
IF OBJECT_ID('Reingreso', 'U') IS NOT NULL DROP TABLE Reingreso;
IF OBJECT_ID('SeguimientoAdopcion', 'U') IS NOT NULL DROP TABLE SeguimientoAdopcion;
IF OBJECT_ID('Adopcion', 'U') IS NOT NULL DROP TABLE Adopcion;
IF OBJECT_ID('SolicitudAdopcion', 'U') IS NOT NULL DROP TABLE SolicitudAdopcion;
IF OBJECT_ID('HistorialMascota', 'U') IS NOT NULL DROP TABLE HistorialMascota;
IF OBJECT_ID('FotoMascota', 'U') IS NOT NULL DROP TABLE FotoMascota;
IF OBJECT_ID('Mascota', 'U') IS NOT NULL DROP TABLE Mascota;
IF OBJECT_ID('Sesion', 'U') IS NOT NULL DROP TABLE Sesion;
IF OBJECT_ID('Usuario', 'U') IS NOT NULL DROP TABLE Usuario;
GO

/* ============================================== */
/*  MÓDULO DE SEGURIDAD                          */
/* ============================================== */

-- Tabla: Usuario
-- Gestiona usuarios del sistema (adoptantes, admins, voluntarios)
CREATE TABLE Usuario (
    UsuarioID           INT IDENTITY(1,1) PRIMARY KEY,
    Cedula              VARCHAR(15) NOT NULL UNIQUE,
    Nombres             VARCHAR(100) NOT NULL,
    Apellidos           VARCHAR(100) NOT NULL,
    Email               VARCHAR(150) NOT NULL UNIQUE,
    Password            VARCHAR(255) NOT NULL,  -- Hash BCrypt
    Telefono            VARCHAR(15) NULL,
    Direccion           VARCHAR(255) NULL,
    FotoPerfil          VARCHAR(500) NULL,      -- URL de imagen
    Rol                 VARCHAR(20) NOT NULL DEFAULT 'Usuario',  -- Admin, Encargado, Usuario
    FechaRegistro       DATETIME NOT NULL DEFAULT GETDATE(),
    UltimoAcceso        DATETIME NULL,
    IntentosFallidos    INT NOT NULL DEFAULT 0,
    BloqueadoHasta      DATETIME NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activo'  -- Activo, Inactivo, Bloqueado
);
GO

-- Tabla: Sesion
-- Control de sesiones activas con JWT
CREATE TABLE Sesion (
    SesionID            INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NOT NULL,
    Token               VARCHAR(500) NOT NULL,
    FechaCreacion       DATETIME NOT NULL DEFAULT GETDATE(),
    FechaExpiracion     DATETIME NOT NULL,
    IpAcceso            VARCHAR(45) NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activa'  -- Activa, Expirada, Cerrada
);
GO

/* ============================================== */
/*  MÓDULO DE GESTIÓN DE MASCOTAS                */
/* ============================================== */

-- Tabla: Mascota
-- Información principal de animales del refugio
CREATE TABLE Mascota (
    MascotaID           INT IDENTITY(1,1) PRIMARY KEY,
    Codigo              VARCHAR(20) NOT NULL UNIQUE,  -- Ej: PER-001, GAT-015
    Nombre              VARCHAR(100) NOT NULL,
    Especie             VARCHAR(20) NOT NULL,         -- Perro, Gato, Otro
    Raza                VARCHAR(50) NULL,
    Edad                INT NULL,
    UnidadEdad          VARCHAR(10) NULL,             -- Meses, Años
    Sexo                VARCHAR(10) NOT NULL,         -- Macho, Hembra
    Tamanio             VARCHAR(20) NULL,             -- Pequeño, Mediano, Grande
    Color               VARCHAR(50) NULL,
    Descripcion         VARCHAR(500) NULL,
    NecesidadesEspeciales VARCHAR(300) NULL,
    EsUrgente           BIT NOT NULL DEFAULT 0,
    FechaIngreso        DATE NOT NULL DEFAULT GETDATE(),
    LugarRescate        VARCHAR(200) NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Disponible',  -- Disponible, EnProceso, Adoptado, Cuarentena
    Activo              BIT NOT NULL DEFAULT 1        -- Para borrado lógico
);
GO

-- Tabla: FotoMascota
-- Galería de fotos por mascota
CREATE TABLE FotoMascota (
    FotoID              INT IDENTITY(1,1) PRIMARY KEY,
    MascotaID           INT NOT NULL,
    UrlFoto             VARCHAR(500) NOT NULL,
    Descripcion         VARCHAR(200) NULL,
    EsPrincipal         BIT NOT NULL DEFAULT 0,
    FechaSubida         DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Tabla: HistorialMascota
-- Registro de eventos médicos y seguimiento
CREATE TABLE HistorialMascota (
    HistorialID         INT IDENTITY(1,1) PRIMARY KEY,
    MascotaID           INT NOT NULL,
    UsuarioID           INT NULL,                     -- Quien registró el evento
    FechaEvento         DATE NOT NULL,
    TipoEvento          VARCHAR(50) NOT NULL,         -- Vacuna, Tratamiento, Esterilizacion, Rescate, Observacion
    Descripcion         VARCHAR(500) NOT NULL,
    Observaciones       VARCHAR(500) NULL
);
GO

/* ============================================== */
/*  MÓDULO DE ADOPCIONES                         */
/* ============================================== */

-- Tabla: SolicitudAdopcion
-- Solicitudes de adopción de usuarios
CREATE TABLE SolicitudAdopcion (
    SolicitudID         INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NOT NULL,
    MascotaID           INT NOT NULL,
    FechaSolicitud      DATETIME NOT NULL DEFAULT GETDATE(),
    MotivoAdopcion      VARCHAR(500) NOT NULL,
    TipoVivienda        VARCHAR(50) NOT NULL,         -- Casa, Departamento, Finca
    TienePatio          BIT NOT NULL DEFAULT 0,
    TieneOtrasMascotas  BIT NOT NULL DEFAULT 0,
    DescripcionOtrasMascotas VARCHAR(300) NULL,
    ExperienciaPrevia   VARCHAR(300) NULL,
    FotoVivienda        VARCHAR(500) NULL,            -- URL
    FotoCedula          VARCHAR(500) NULL,            -- URL
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Pendiente',  -- Pendiente, Aprobada, Rechazada, Cancelada
    MotivoRechazo       VARCHAR(300) NULL,
    FechaEvaluacion     DATETIME NULL
);
GO

-- Tabla: Adopcion
-- Adopciones confirmadas
CREATE TABLE Adopcion (
    AdopcionID          INT IDENTITY(1,1) PRIMARY KEY,
    SolicitudID         INT NOT NULL UNIQUE,
    FechaEntrega        DATE NOT NULL,
    ObservacionesEntrega VARCHAR(500) NULL,
    CompromisoFirmado   BIT NOT NULL DEFAULT 0,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activa'  -- Activa, Devuelta, Completada
);
GO

-- Tabla: SeguimientoAdopcion
-- Control post-adopción
CREATE TABLE SeguimientoAdopcion (
    SeguimientoID       INT IDENTITY(1,1) PRIMARY KEY,
    AdopcionID          INT NOT NULL,
    FechaProgramada     DATE NOT NULL,
    FechaRealizada      DATE NULL,
    TipoSeguimiento     VARCHAR(50) NOT NULL,         -- Llamada, VisitaDomicilio, Foto
    Observaciones       VARCHAR(500) NULL,
    EstadoMascota       VARCHAR(100) NULL,
    EvidenciaFoto       VARCHAR(500) NULL,            -- URL
    Completado          BIT NOT NULL DEFAULT 0
);
GO

-- Tabla: Reingreso
-- Mascotas devueltas al refugio
CREATE TABLE Reingreso (
    ReingresoID         INT IDENTITY(1,1) PRIMARY KEY,
    AdopcionID          INT NOT NULL,
    FechaReingreso      DATE NOT NULL,
    Motivo              VARCHAR(300) NOT NULL,
    EstadoMascotaReingreso VARCHAR(200) NULL,
    Observaciones       VARCHAR(500) NULL
);
GO

-- Tabla: Certificado
-- Certificados de adopción generados
CREATE TABLE Certificado (
    CertificadoID       INT IDENTITY(1,1) PRIMARY KEY,
    AdopcionID          INT NOT NULL UNIQUE,
    CodigoCertificado   VARCHAR(50) NOT NULL UNIQUE,  -- Código único verificable
    FechaEmision        DATETIME NOT NULL DEFAULT GETDATE(),
    UrlDocumento        VARCHAR(500) NULL             -- URL del PDF generado
);
GO

/* ============================================== */
/*  MÓDULO DE VOLUNTARIADO                       */
/* ============================================== */

-- Tabla: Voluntario
-- Registro de voluntarios (extiende Usuario)
CREATE TABLE Voluntario (
    VoluntarioID        INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NOT NULL UNIQUE,
    InstitucionEducativa VARCHAR(200) NULL,
    RequiereHorasComunitarias BIT NOT NULL DEFAULT 0,
    HorasRequeridas     INT NULL,
    HorasCumplidas      DECIMAL(6,2) NOT NULL DEFAULT 0,
    Disponibilidad      VARCHAR(200) NULL,            -- Ej: "Lunes AM, Miércoles PM"
    Habilidades         VARCHAR(300) NULL,
    FechaInscripcion    DATE NOT NULL DEFAULT GETDATE(),
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activo'  -- Activo, Inactivo, Completado
);
GO

-- Tabla: ActividadVoluntario
-- Registro de actividades realizadas
CREATE TABLE ActividadVoluntario (
    ActividadID         INT IDENTITY(1,1) PRIMARY KEY,
    VoluntarioID        INT NOT NULL,
    FechaActividad      DATE NOT NULL,
    HoraInicio          TIME NOT NULL,
    HoraFin             TIME NOT NULL,
    TipoActividad       VARCHAR(100) NOT NULL,        -- Limpieza, Paseo, Alimentacion, Evento
    Descripcion         VARCHAR(300) NULL,
    HorasRegistradas    DECIMAL(4,2) NOT NULL,
    Validado            BIT NOT NULL DEFAULT 0
);
GO

/* ============================================== */
/*  MÓDULO DE AUTOGESTIÓN - TIENDA               */
/* ============================================== */

-- Tabla: Producto
-- Catálogo de productos solidarios
CREATE TABLE Producto (
    ProductoID          INT IDENTITY(1,1) PRIMARY KEY,
    Nombre              VARCHAR(150) NOT NULL,
    Descripcion         VARCHAR(500) NULL,
    Precio              DECIMAL(10,2) NOT NULL,
    Stock               INT NOT NULL DEFAULT 0,
    ImagenUrl           VARCHAR(500) NULL,
    Categoria           VARCHAR(50) NULL,             -- Accesorios, Ropa, Alimentos
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activo'  -- Activo, Agotado, Inactivo
);
GO

-- Tabla: Pedido
-- Pedidos realizados (genera mensaje WhatsApp)
CREATE TABLE Pedido (
    PedidoID            INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NULL,                     -- Puede ser NULL si es visitante
    NombreCliente       VARCHAR(200) NOT NULL,
    TelefonoCliente     VARCHAR(20) NOT NULL,
    FechaPedido         DATETIME NOT NULL DEFAULT GETDATE(),
    Total               DECIMAL(10,2) NOT NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Pendiente',  -- Pendiente, Confirmado, Entregado, Cancelado
    Observaciones       VARCHAR(300) NULL
);
GO

-- Tabla: DetallePedido
-- Líneas de cada pedido
CREATE TABLE DetallePedido (
    DetalleID           INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID            INT NOT NULL,
    ProductoID          INT NOT NULL,
    Cantidad            INT NOT NULL,
    PrecioUnitario      DECIMAL(10,2) NOT NULL,
    Subtotal            DECIMAL(10,2) NOT NULL
);
GO

/* ============================================== */
/*  MÓDULO DE AUTOGESTIÓN - RIFAS                */
/* ============================================== */

-- Tabla: Rifa
-- Rifas del refugio
CREATE TABLE Rifa (
    RifaID              INT IDENTITY(1,1) PRIMARY KEY,
    Nombre              VARCHAR(150) NOT NULL,
    Descripcion         VARCHAR(500) NULL,
    Premio              VARCHAR(200) NOT NULL,
    ImagenPremio        VARCHAR(500) NULL,
    PrecioBoleto        DECIMAL(10,2) NOT NULL,
    TotalBoletos        INT NOT NULL,
    FechaInicio         DATE NOT NULL,
    FechaSorteo         DATE NOT NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activa'  -- Activa, Finalizada, Cancelada
);
GO

-- Tabla: BoletoRifa
-- Boletos vendidos
CREATE TABLE BoletoRifa (
    BoletoID            INT IDENTITY(1,1) PRIMARY KEY,
    RifaID              INT NOT NULL,
    UsuarioID           INT NULL,
    NombreComprador     VARCHAR(200) NOT NULL,
    TelefonoComprador   VARCHAR(20) NOT NULL,
    NumeroBoleto        VARCHAR(10) NOT NULL,
    FechaCompra         DATETIME NOT NULL DEFAULT GETDATE(),
    EsGanador           BIT NOT NULL DEFAULT 0
);
GO

/* ============================================== */
/*  MÓDULO DE AUTOGESTIÓN - DONACIONES           */
/* ============================================== */

-- Tabla: Donacion
-- Registro de donaciones recibidas
CREATE TABLE Donacion (
    DonacionID          INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NULL,
    NombreDonante       VARCHAR(200) NOT NULL,
    Monto               DECIMAL(10,2) NOT NULL,
    TipoDonacion        VARCHAR(50) NOT NULL,         -- Unica, Mensual
    MetodoPago          VARCHAR(50) NULL,             -- Transferencia, Efectivo, PayPal
    FechaDonacion       DATE NOT NULL DEFAULT GETDATE(),
    Comprobante         VARCHAR(500) NULL,            -- URL del comprobante
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Confirmada'  -- Pendiente, Confirmada, Cancelada
);
GO

-- Tabla: Padrino
-- Apadrinamiento de mascotas
CREATE TABLE Padrino (
    PadrinoID           INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NOT NULL,
    MascotaID           INT NOT NULL,
    MontoMensual        DECIMAL(10,2) NOT NULL,
    FechaInicio         DATE NOT NULL DEFAULT GETDATE(),
    FechaFin            DATE NULL,
    Estado              VARCHAR(20) NOT NULL DEFAULT 'Activo'  -- Activo, Pausado, Finalizado
);
GO

/* ============================================== */
/*  MÓDULO DE NOTIFICACIONES                     */
/* ============================================== */

-- Tabla: Notificacion
-- Notificaciones del sistema
CREATE TABLE Notificacion (
    NotificacionID      INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID           INT NOT NULL,
    Titulo              VARCHAR(150) NOT NULL,
    Mensaje             VARCHAR(500) NOT NULL,
    TipoNotificacion    VARCHAR(50) NOT NULL,         -- Adopcion, Seguimiento, Rifa, Sistema
    UrlReferencia       VARCHAR(500) NULL,
    FechaCreacion       DATETIME NOT NULL DEFAULT GETDATE(),
    FechaLectura        DATETIME NULL,
    Leida               BIT NOT NULL DEFAULT 0
);
GO

/* ============================================== */
/*  CREAR FOREIGN KEYS                           */
/* ============================================== */

-- Módulo Seguridad
ALTER TABLE Sesion 
    ADD CONSTRAINT FK_Sesion_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

-- Módulo Mascotas
ALTER TABLE FotoMascota 
    ADD CONSTRAINT FK_FotoMascota_Mascota 
    FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID);
GO

ALTER TABLE HistorialMascota 
    ADD CONSTRAINT FK_HistorialMascota_Mascota 
    FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID);
GO

ALTER TABLE HistorialMascota 
    ADD CONSTRAINT FK_HistorialMascota_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

-- Módulo Adopciones
ALTER TABLE SolicitudAdopcion 
    ADD CONSTRAINT FK_SolicitudAdopcion_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

ALTER TABLE SolicitudAdopcion 
    ADD CONSTRAINT FK_SolicitudAdopcion_Mascota 
    FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID);
GO

ALTER TABLE Adopcion 
    ADD CONSTRAINT FK_Adopcion_Solicitud 
    FOREIGN KEY (SolicitudID) REFERENCES SolicitudAdopcion(SolicitudID);
GO

ALTER TABLE SeguimientoAdopcion 
    ADD CONSTRAINT FK_SeguimientoAdopcion_Adopcion 
    FOREIGN KEY (AdopcionID) REFERENCES Adopcion(AdopcionID);
GO

ALTER TABLE Reingreso 
    ADD CONSTRAINT FK_Reingreso_Adopcion 
    FOREIGN KEY (AdopcionID) REFERENCES Adopcion(AdopcionID);
GO

ALTER TABLE Certificado 
    ADD CONSTRAINT FK_Certificado_Adopcion 
    FOREIGN KEY (AdopcionID) REFERENCES Adopcion(AdopcionID);
GO

-- Módulo Voluntariado
ALTER TABLE Voluntario 
    ADD CONSTRAINT FK_Voluntario_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

ALTER TABLE ActividadVoluntario 
    ADD CONSTRAINT FK_ActividadVoluntario_Voluntario 
    FOREIGN KEY (VoluntarioID) REFERENCES Voluntario(VoluntarioID);
GO

-- Módulo Tienda
ALTER TABLE Pedido 
    ADD CONSTRAINT FK_Pedido_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

ALTER TABLE DetallePedido 
    ADD CONSTRAINT FK_DetallePedido_Pedido 
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID);
GO

ALTER TABLE DetallePedido 
    ADD CONSTRAINT FK_DetallePedido_Producto 
    FOREIGN KEY (ProductoID) REFERENCES Producto(ProductoID);
GO

-- Módulo Rifas
ALTER TABLE BoletoRifa 
    ADD CONSTRAINT FK_BoletoRifa_Rifa 
    FOREIGN KEY (RifaID) REFERENCES Rifa(RifaID);
GO

ALTER TABLE BoletoRifa 
    ADD CONSTRAINT FK_BoletoRifa_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

-- Módulo Donaciones
ALTER TABLE Donacion 
    ADD CONSTRAINT FK_Donacion_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

ALTER TABLE Padrino 
    ADD CONSTRAINT FK_Padrino_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

ALTER TABLE Padrino 
    ADD CONSTRAINT FK_Padrino_Mascota 
    FOREIGN KEY (MascotaID) REFERENCES Mascota(MascotaID);
GO

-- Módulo Notificaciones
ALTER TABLE Notificacion 
    ADD CONSTRAINT FK_Notificacion_Usuario 
    FOREIGN KEY (UsuarioID) REFERENCES Usuario(UsuarioID);
GO

/* ============================================== */
/*  CREAR ÍNDICES PARA RENDIMIENTO               */
/* ============================================== */

-- Índices para búsquedas frecuentes
CREATE INDEX IX_Usuario_Email ON Usuario(Email);
CREATE INDEX IX_Usuario_Cedula ON Usuario(Cedula);
CREATE INDEX IX_Mascota_Estado ON Mascota(Estado);
CREATE INDEX IX_Mascota_Especie ON Mascota(Especie);
CREATE INDEX IX_Mascota_EsUrgente ON Mascota(EsUrgente);
CREATE INDEX IX_SolicitudAdopcion_Estado ON SolicitudAdopcion(Estado);
CREATE INDEX IX_Adopcion_Estado ON Adopcion(Estado);
CREATE INDEX IX_Rifa_Estado ON Rifa(Estado);
CREATE INDEX IX_Notificacion_Usuario_Leida ON Notificacion(UsuarioID, Leida);
GO

/* ============================================== */
/*  DATOS INICIALES (OPCIONAL)                   */
/* ============================================== */

-- Usuario administrador por defecto
-- Password: Admin123! (hash BCrypt - debes generar el hash real en tu aplicación)
INSERT INTO Usuario (Cedula, Nombres, Apellidos, Email, Password, Rol, Estado)
VALUES ('0000000000', 'Diana', 'Administrador', 'admin@colitasfelices.org', 
        '$2a$10$PLACEHOLDER_HASH_CHANGE_THIS', 'Admin', 'Activo');
GO

-- Mensaje de confirmación
PRINT '============================================';
PRINT ' Base de datos Colitas Felices creada con éxito';
PRINT ' Total de tablas: 20';
PRINT ' ';
PRINT ' MÓDULOS:';
PRINT ' - Seguridad: Usuario, Sesion';
PRINT ' - Mascotas: Mascota, FotoMascota, HistorialMascota';
PRINT ' - Adopciones: SolicitudAdopcion, Adopcion, SeguimientoAdopcion, Reingreso, Certificado';
PRINT ' - Voluntariado: Voluntario, ActividadVoluntario';
PRINT ' - Tienda: Producto, Pedido, DetallePedido';
PRINT ' - Rifas: Rifa, BoletoRifa';
PRINT ' - Donaciones: Donacion, Padrino';
PRINT ' - Sistema: Notificacion';
PRINT '============================================';
GO