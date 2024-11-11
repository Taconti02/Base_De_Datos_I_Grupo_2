-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- 1. Insertar perfiles
INSERT INTO Perfil (id_perfil, descripcion) 
VALUES (1, 'Administrador'), (2, 'Gerente'), (3, 'Empleado');

-- 2. Insertar personas
INSERT INTO Persona (nombre, apellido, email, telefono, dni) 
VALUES 
('Juan', 'Perez', 'juancitop12@gmail.com', '3794284911', 27288012), 
('Marta', 'Torres', 'martatorres0@gmail.com', '3795104298', 38583412), 
('Ana', 'Gómez', 'ana.gomez@example.com', '9876-543210', 23456721);

-- 3. Insertar usuarios
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
      WHERE dni = 23456721), 3);

-- 4. Creación de Roles
-- Verificar si los roles ya existen antes de crearlos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Administrador')
    CREATE ROLE Administrador;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Empleado')
    CREATE ROLE Empleado;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Gerente')
    CREATE ROLE Gerente;
GO

-- 5. Creación de Logins en `master` (si no existen)
USE master;
GO

-- Crear logins si no existen
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'admin')
    CREATE LOGIN admin WITH PASSWORD = 'admin_password';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'employee')
    CREATE LOGIN employee WITH PASSWORD = 'employee_password';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'manager')
    CREATE LOGIN manager WITH PASSWORD = 'manager_password';
GO

-- 6. Crear usuarios en la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Crear usuarios si no existen
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Juan')
    CREATE USER Juan FOR LOGIN admin WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Marta')
    CREATE USER Marta FOR LOGIN employee WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Ana')
    CREATE USER Ana FOR LOGIN manager WITH DEFAULT_SCHEMA = dbo;
GO

-- 7. Asignación de Roles a Usuarios
-- Se asegura que cada usuario exista en la base de datos antes de asignarle un rol
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Juan')
    ALTER ROLE Administrador ADD MEMBER Juan;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Marta')
    ALTER ROLE Empleado ADD MEMBER Marta;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Ana')
    ALTER ROLE Gerente ADD MEMBER Ana;
GO

-- 8. Asignación de Permisos
-- Asignación de permisos a nivel de tablas específicas dentro de la base de datos actual
GRANT CONTROL ON DATABASE::base_sistema_ventas TO Administrador;
GRANT SELECT, INSERT, UPDATE ON Persona TO Administrador;

GRANT SELECT, INSERT, UPDATE ON Venta TO Empleado;
GRANT SELECT, INSERT, UPDATE ON Detalle_Venta TO Empleado;
GRANT SELECT ON Cliente TO Empleado;

GRANT SELECT, INSERT, UPDATE ON Producto TO Gerente;
GRANT SELECT ON Usuario TO Gerente;
GO

PRINT 'Roles y permisos asignados correctamente en base_sistema_ventas';
