-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- 1. Insertar perfiles (si no existen)
IF NOT EXISTS (SELECT 1 FROM Perfil)
BEGIN
     INSERT INTO Perfil (id_perfil, descripcion) 
     VALUES (1, 'Administrador'), (2, 'Empleado');
END
     
-- 1.1 Insertar personas
INSERT INTO Persona (nombre, apellido, email, telefono, dni) 
VALUES 
('Juan', 'Perez', 'juancitop12@gmail.com', '3794284911', 27288012), 
('Marta', 'Torres', 'martatorres0@gmail.com', '3795104298', 38583412),
('Ana', 'Gómez', 'anagomez@gmail.com', '1234567890', 23456721);

-- 1.2 Insertar usuarios
INSERT INTO Usuario (nombre_usuario, contraseña, id_usuario, id_perfil) 
VALUES 
('Juan', '12345678',
     (SELECT id_persona 
      FROM Persona 
      WHERE dni = 27288012), 1),
('Marta', '12345678',
     (SELECT id_persona 
      FROM Persona 
      WHERE dni = 38583412), 2),
('Ana', '12345678',
     (SELECT id_persona 
      FROM Persona 
      WHERE dni = 23456721), 2);

-- 2. Creación de Roles
-- Verificar si los roles ya existen antes de crearlos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Administrador')
    CREATE ROLE Administrador;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'EmpleadoLectura')
    CREATE ROLE EmpleadoLectura;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Empleado')
    CREATE ROLE Empleado;
GO

-- 3. Creación de Logins en `master` (si no existen)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'admin')
    CREATE LOGIN admin WITH PASSWORD = 'admin_password';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'employee')
    CREATE LOGIN employee WITH PASSWORD = 'employee_password';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'employee2')
    CREATE LOGIN employee2 WITH PASSWORD = 'employee_password';
GO

-- 3.1 Crear usuarios en la base de datos `base_sistema_ventas`
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Juan')
    CREATE USER Juan FOR LOGIN admin WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Marta')
    CREATE USER Marta FOR LOGIN employee WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Ana')
    CREATE USER Ana FOR LOGIN employee2 WITH DEFAULT_SCHEMA = dbo;
GO

-- 4. Asignación de Roles a Usuarios
-- Se asegura que cada usuario exista en la base de datos antes de asignarle un rol
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Juan')
    ALTER ROLE Administrador ADD MEMBER Juan;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Marta')
    ALTER ROLE EmpleadoLectura ADD MEMBER Marta;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Ana')
    ALTER ROLE Empleado ADD MEMBER Ana;
GO

-- 5. Asignación de Permisos
-- Permisos de administrador a Juan
GRANT CONTROL ON DATABASE::base_sistema_ventas TO Administrador;
GRANT SELECT, INSERT, UPDATE ON Persona TO Administrador;

-- Permisos de solo lectura a Marta en todas las tablas del esquema dbo
DECLARE @tabla NVARCHAR(128);
DECLARE tabla_cursor CURSOR FOR 
    SELECT name FROM sys.tables WHERE schema_id = SCHEMA_ID('dbo');

OPEN tabla_cursor;
FETCH NEXT FROM tabla_cursor INTO @tabla;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @sql NVARCHAR(MAX) = N'GRANT SELECT ON dbo.' + QUOTENAME(@tabla) + ' TO EmpleadoLectura;';
    EXEC sp_executesql @sql;
    FETCH NEXT FROM tabla_cursor INTO @tabla;
END;

CLOSE tabla_cursor;
DEALLOCATE tabla_cursor;
GO

-- 6. Crear procedimiento almacenado para INSERT en la tabla Persona
CREATE PROCEDURE sp_InsertarPersona
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @email NVARCHAR(50),
    @telefono NVARCHAR(15),
    @dni INT
AS
BEGIN
    INSERT INTO Persona (nombre, apellido, email, telefono, dni) 
    VALUES (@nombre, @apellido, @email, @telefono, @dni);
END;
GO

-- 7. Dar permiso de ejecución del procedimiento a Marta
GRANT EXECUTE ON sp_InsertarPersona TO Marta;
GO

PRINT 'Roles, permisos y procedimientos asignados correctamente en base_sistema_ventas';
