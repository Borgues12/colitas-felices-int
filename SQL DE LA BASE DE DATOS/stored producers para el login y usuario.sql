-- ============================================
-- SISTEMA DE CIFRADO AES-256 PURO
-- Sistema de Refugio - Proyecto Académico
-- ============================================


-- ============================================
-- PARTE 1: CONFIGURACIÓN DE SEGURIDAD
-- (Ejecutar UNA sola vez)
-- ============================================

-- PASO 1: Master Key (La bóveda principal)
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ColitasFelices_MasterKey_2025$.,';
    PRINT '✅ Master Key creada';
END
ELSE
    PRINT '✅ Master Key ya existe';
GO

SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##';
SELECT name, algorithm_desc, create_date 
FROM sys.symmetric_keys;

-- PASO 2: Certificado (Protege la llave AES)
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'CertRefugio')
BEGIN
    CREATE CERTIFICATE CertRefugio
        WITH SUBJECT = 'Certificado Refugio',
        EXPIRY_DATE = '2030-12-31';
    PRINT '✅ Certificado creado';
END
ELSE
    PRINT '✅ Certificado ya existe';
GO

SELECT 
    name AS Nombre,
    subject AS Descripcion,
    expiry_date AS FechaExpiracion,
    start_date AS FechaInicio
FROM sys.certificates;

-- PASO 3: Clave Simétrica AES-256 (La llave que cifra)
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'ClaveAES_Refugio')
BEGIN
    CREATE SYMMETRIC KEY ClaveAES_Refugio
        WITH ALGORITHM = AES_256
        ENCRYPTION BY CERTIFICATE CertRefugio;
    PRINT '✅ Clave AES-256 creada';
END
ELSE
    PRINT '✅ Clave AES ya existe';
GO

SELECT name, algorithm_desc FROM sys.symmetric_keys;

-- Verificación
PRINT '';
PRINT '=== VERIFICACIÓN DE COMPONENTES ===';
SELECT 'Master Key' AS Componente, '✅ OK' AS Estado WHERE EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
UNION ALL
SELECT 'Certificado', '✅ OK' WHERE EXISTS (SELECT * FROM sys.certificates WHERE name = 'CertRefugio')
UNION ALL
SELECT 'Clave AES-256', '✅ OK' WHERE EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'ClaveAES_Refugio');
GO

-- ============================================
-- PARTE 2: STORED PROCEDURES
-- ============================================


-- ============================================
-- SP 1: CREAR USUARIO CON CIFRADO AES
-- ============================================


CREATE PROCEDURE SP_CrearUsuario_Admin
    @Email VARCHAR(150),
    @Password VARCHAR(255),
    @Rol VARCHAR(20),
    @CuentaID INT OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validaciones
    IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
    BEGIN
        SET @Mensaje = 'ERROR: Email obligatorio';
        RETURN -1;
    END
    
    IF @Email NOT LIKE '%_@__%.__%'
    BEGIN
        SET @Mensaje = 'ERROR: Formato de email inválido';
        RETURN -1;
    END
    
    IF LEN(@Password) < 6
    BEGIN
        SET @Mensaje = 'ERROR: Contraseña mínimo 6 caracteres';
        RETURN -1;
    END
    
    IF EXISTS (SELECT 1 FROM Cuenta WHERE Email = @Email)
    BEGIN
        SET @Mensaje = 'ERROR: Email ya registrado';
        RETURN -1;
    END
    
    BEGIN TRY
        DECLARE @PasswordCifrado VARBINARY(500);
        
        OPEN SYMMETRIC KEY ClaveAES_Refugio
            DECRYPTION BY CERTIFICATE CertRefugio;
        
        SET @PasswordCifrado = ENCRYPTBYKEY(KEY_GUID('ClaveAES_Refugio'), @Password);
        
        CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        -- Usuario ACTIVO directamente (sin token)
        INSERT INTO Cuenta (
            Email, Password, Rol, FechaRegistro,
            IntentosFallidos, VecesBloqueo, TipoAutenticacion, Estado
        )
        VALUES (
            @Email, @PasswordCifrado, @Rol, GETDATE(),
            0, 0, 'LOCAL', 'ACTIVO'
        );
        
        SET @CuentaID = SCOPE_IDENTITY();
        SET @Mensaje = 'Usuario creado exitosamente (activo)';
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'ClaveAES_Refugio')
            CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        SET @Mensaje = 'ERROR: ' + ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END;
GO

-- ============================================
-- SP 2: USUARIO SE REGISTRA (con verificación)
-- ============================================
CREATE PROCEDURE SP_RegistrarUsuario
    @Email VARCHAR(150),
    @Password VARCHAR(255),
    @CuentaID INT OUTPUT,
    @TokenVerificacion VARCHAR(6) OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validaciones
    IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
    BEGIN
        SET @Mensaje = 'ERROR: Email obligatorio';
        RETURN -1;
    END
    
    IF @Email NOT LIKE '%_@__%.__%'
    BEGIN
        SET @Mensaje = 'ERROR: Formato de email inválido';
        RETURN -1;
    END
    
    IF LEN(@Password) < 6
    BEGIN
        SET @Mensaje = 'ERROR: Contraseña mínimo 6 caracteres';
        RETURN -1;
    END
    
    IF EXISTS (SELECT 1 FROM Cuenta WHERE Email = @Email)
    BEGIN
        SET @Mensaje = 'ERROR: Email ya registrado';
        RETURN -1;
    END
    
    BEGIN TRY
        DECLARE @PasswordCifrado VARBINARY(500);
        
        -- Generar código de 6 dígitos
        SET @TokenVerificacion = RIGHT('000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000 AS VARCHAR), 6);
        
        OPEN SYMMETRIC KEY ClaveAES_Refugio
            DECRYPTION BY CERTIFICATE CertRefugio;
        
        SET @PasswordCifrado = ENCRYPTBYKEY(KEY_GUID('ClaveAES_Refugio'), @Password);
        
        CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        -- Usuario PENDIENTE con token
        INSERT INTO Cuenta (
            Email, Password, Rol, FechaRegistro,
            IntentosFallidos, VecesBloqueo, TipoAutenticacion, Estado,
            TokenRecuperacion, TokenExpiracion
        )
        VALUES (
            @Email, @PasswordCifrado, 'USUARIO', GETDATE(),
            0, 0, 'LOCAL', 'PENDIENTE',
            @TokenVerificacion, DATEADD(MINUTE, 15, GETDATE())
        );
        
        SET @CuentaID = SCOPE_IDENTITY();
        SET @Mensaje = 'Usuario registrado. Verificar email con código enviado';
        RETURN 0;
        
    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'ClaveAES_Refugio')
            CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        SET @Mensaje = 'ERROR: ' + ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END;
GO

-- ============================================
-- SP 3: VERIFICAR TOKEN (activar cuenta)
-- ============================================
CREATE PROCEDURE SP_VerificarToken
    @Email VARCHAR(150),
    @Token VARCHAR(6),
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TokenGuardado VARCHAR(6);
    DECLARE @TokenExpiracion DATETIME;
    DECLARE @Estado VARCHAR(20);
    
    -- Obtener datos
    SELECT 
        @TokenGuardado = TokenRecuperacion,
        @TokenExpiracion = TokenExpiracion,
        @Estado = Estado
    FROM Cuenta
    WHERE Email = @Email;
    
    -- Validaciones
    IF @TokenGuardado IS NULL
    BEGIN
        SET @Mensaje = 'ERROR: Usuario no encontrado';
        RETURN -1;
    END
    
    IF @Estado = 'ACTIVO'
    BEGIN
        SET @Mensaje = 'La cuenta ya está verificada';
        RETURN 0;
    END
    
    IF @TokenExpiracion < GETDATE()
    BEGIN
        SET @Mensaje = 'ERROR: Token expirado. Solicite uno nuevo';
        RETURN -1;
    END
    
    IF @TokenGuardado != @Token
    BEGIN
        SET @Mensaje = 'ERROR: Token incorrecto';
        RETURN -1;
    END
    
    -- Activar cuenta
    UPDATE Cuenta
    SET Estado = 'ACTIVO',
        TokenRecuperacion = NULL,
        TokenExpiracion = NULL
    WHERE Email = @Email;
    
    SET @Mensaje = 'Cuenta verificada exitosamente';
    RETURN 0;
END;
GO

ALTER PROCEDURE SP_VerificarLogin
    @Email VARCHAR(150),
    @Password VARCHAR(255),
    @LoginExitoso BIT OUTPUT,
    @CuentaID INT OUTPUT,
    @RolUsuario VARCHAR(20) OUTPUT,
    @Mensaje VARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @PasswordCifrado VARBINARY(500);
    DECLARE @PasswordDescifrado VARCHAR(255);
    DECLARE @IntentosFallidos INT;
    DECLARE @BloqueadoHasta DATETIME;
    DECLARE @VecesBloqueo INT;
    DECLARE @Estado VARCHAR(20);
    
    -- Inicializar
    SET @LoginExitoso = 0;
    SET @CuentaID = NULL;
    SET @RolUsuario = NULL;
    
    -- Obtener datos del usuario
    SELECT 
        @CuentaID = CuentaID,
        @PasswordCifrado = Password,
        @IntentosFallidos = IntentosFallidos,
        @BloqueadoHasta = BloqueadoHasta,
        @VecesBloqueo = VecesBloqueo,
        @RolUsuario = Rol,
        @Estado = Estado
    FROM Cuenta
    WHERE Email = @Email;
    
    -- ¿Usuario existe?
    IF @CuentaID IS NULL
    BEGIN
        SET @Mensaje = 'Credenciales incorrectas';
        RETURN -1;
    END
    
    -- ¿Cuenta pendiente?
    IF @Estado = 'PENDIENTE'
    BEGIN
        SET @Mensaje = 'Cuenta no verificada. Revise su email';
        SET @CuentaID = NULL;
        RETURN -1;
    END
    
    -- ¿Cuenta bloqueada? (Solo si NO es admin)
    IF @Estado = 'BLOQUEADO' AND @RolUsuario != 'ADMIN'
    BEGIN
        IF @BloqueadoHasta > GETDATE()
        BEGIN
            DECLARE @MinutosRestantes INT = DATEDIFF(MINUTE, GETDATE(), @BloqueadoHasta);
            SET @Mensaje = 'Cuenta bloqueada. Espere ' + CAST(@MinutosRestantes AS VARCHAR) + ' minutos';
            SET @CuentaID = NULL;
            SET @RolUsuario = NULL;
            RETURN -1;
        END
        ELSE
        BEGIN
            UPDATE Cuenta SET 
                Estado = 'ACTIVO',
                BloqueadoHasta = NULL,
                IntentosFallidos = 0
            WHERE CuentaID = @CuentaID;
            
            SET @Estado = 'ACTIVO';
            SET @IntentosFallidos = 0;
        END
    END
    
    -- ¿Cuenta inactiva?
    IF @Estado NOT IN ('ACTIVO', 'BLOQUEADO')
    BEGIN
        SET @Mensaje = 'Cuenta no activa';
        SET @CuentaID = NULL;
        SET @RolUsuario = NULL;
        RETURN -1;
    END
    
    -- Descifrar y comparar
    BEGIN TRY
        OPEN SYMMETRIC KEY ClaveAES_Refugio
            DECRYPTION BY CERTIFICATE CertRefugio;
        
        SET @PasswordDescifrado = CONVERT(VARCHAR(255), DECRYPTBYKEY(@PasswordCifrado));
        
        CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        -- ¿Contraseñas coinciden?
        IF @PasswordDescifrado = @Password
        BEGIN
            -- ✅ LOGIN EXITOSO
            UPDATE Cuenta SET 
                UltimoAcceso = GETDATE(),
                IntentosFallidos = 0,
                BloqueadoHasta = NULL,
                Estado = 'ACTIVO'
            WHERE CuentaID = @CuentaID;
            
            SET @LoginExitoso = 1;
            SET @Mensaje = 'Login exitoso';
            RETURN 0;
        END
        ELSE
        BEGIN
            -- ❌ CONTRASEÑA INCORRECTA
            
            -- Si es ADMIN, solo mostrar mensaje (sin bloqueo)
            IF @RolUsuario = 'ADMIN'
            BEGIN
                SET @Mensaje = 'Credenciales incorrectas';
                SET @CuentaID = NULL;
                SET @RolUsuario = NULL;
                RETURN -1;
            END
            
            -- Para otros roles, aplicar bloqueo
            SET @IntentosFallidos = @IntentosFallidos + 1;
            
            IF @IntentosFallidos >= 5
            BEGIN
                DECLARE @MinutosBloqueo INT;
                DECLARE @NuevoVecesBloqueo INT = @VecesBloqueo + 1;
                
                SET @MinutosBloqueo = CASE @NuevoVecesBloqueo
                    WHEN 1 THEN 15
                    WHEN 2 THEN 30
                    ELSE 60
                END;
                
                UPDATE Cuenta SET 
                    IntentosFallidos = @IntentosFallidos,
                    BloqueadoHasta = DATEADD(MINUTE, @MinutosBloqueo, GETDATE()),
                    VecesBloqueo = @NuevoVecesBloqueo,
                    Estado = 'BLOQUEADO'
                WHERE CuentaID = @CuentaID;
                
                SET @Mensaje = 'Cuenta bloqueada por ' + CAST(@MinutosBloqueo AS VARCHAR) + ' minutos';
            END
            ELSE
            BEGIN
                UPDATE Cuenta SET IntentosFallidos = @IntentosFallidos
                WHERE CuentaID = @CuentaID;
                
                SET @Mensaje = 'Credenciales incorrectas. Intentos restantes: ' + CAST(5 - @IntentosFallidos AS VARCHAR);
            END
            
            SET @CuentaID = NULL;
            SET @RolUsuario = NULL;
            RETURN -1;
        END
        
    END TRY
    BEGIN CATCH
        IF EXISTS (SELECT * FROM sys.openkeys WHERE key_name = 'ClaveAES_Refugio')
            CLOSE SYMMETRIC KEY ClaveAES_Refugio;
        
        SET @Mensaje = 'ERROR: ' + ERROR_MESSAGE();
        RETURN -1;
    END CATCH
END;
GO


-- Probar login correcto
DECLARE @Exito BIT, @ID INT, @Rol VARCHAR(20), @Msg VARCHAR(500);

EXEC SP_VerificarLogin
    @Email = 'jampaex12@gmail.com',
    @Password = 'admin123',
    @LoginExitoso = @Exito OUTPUT,
    @CuentaID = @ID OUTPUT,
    @RolUsuario = @Rol OUTPUT,
    @Mensaje = @Msg OUTPUT;

SELECT @Exito AS Exitoso, @ID AS CuentaID, @Rol AS Rol, @Msg AS Mensaje;
UPDATE Cuenta SET IntentosFallidos = 0, VecesBloqueo = 0, Estado = 'ACTIVO', BloqueadoHasta = NULL
WHERE Email = 'jampaex12@gmail.com';
select * from cuenta;
