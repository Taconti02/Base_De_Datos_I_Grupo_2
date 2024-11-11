-- Insertar perfiles
INSERT INTO Perfil (id_perfil, descripcion) VALUES 
(1, 'Administrador'), (2, 'Gerente'), (3, 'Empleado');

-- Insertar personas
INSERT INTO Persona (nombre, apellido, email, telefono, dni) VALUES 
('Juan', 'Perez', 'juancitop12@gmail.com', '3794284911', 27288012), 
('Marta', 'Torres', 'martatorres0@gmail.com', '3795104298', 38583412), 
('Ana', 'Gómez', 'ana.gomez@example.com', '9876-543210', 23456721);

-- Insertar usuarios
INSERT INTO Usuario (nombre_usuario, contraseña, id_usuario, id_perfil) VALUES 
('Juan', '12345678', 1, 1), ('Marta', '12345678', 2, 2), ('Ana', '12345678', 3, 3);

-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- 1. Creación de Roles
-- Verificar si los roles ya existen antes de crearlos
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Administrador')
    CREATE ROLE Administrador;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Empleado')
    CREATE ROLE Empleado;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Gerente')
    CREATE ROLE Gerente;
GO

-- 2. Creación de Logins en `master` (si no existen)
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

-- 3. Crear usuarios en la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Crear usuarios si no existen
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    CREATE USER user_admin FOR LOGIN admin WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_employee')
    CREATE USER user_employee FOR LOGIN employee WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_manager')
    CREATE USER user_manager FOR LOGIN manager WITH DEFAULT_SCHEMA = dbo;
GO

-- 4. Asignación de Roles a Usuarios
-- Se asegura que cada usuario exista en la base de datos antes de asignarle un rol
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    ALTER ROLE Administrador ADD MEMBER user_admin;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_employee')
    ALTER ROLE Empleado ADD MEMBER user_employee;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_manager')
    ALTER ROLE Gerente ADD MEMBER user_manager;
GO

-- 5. Asignación de Permisos
-- Asignación de permisos a nivel de tablas específicas
GRANT CONTROL ON DATABASE::base_sistema_ventas TO Administrador;

GRANT SELECT, INSERT, UPDATE ON Venta TO Empleado;
GRANT SELECT, INSERT, UPDATE ON Detalle_Venta TO Empleado;
GRANT SELECT ON Cliente TO Empleado;
GRANT SELECT ON Producto TO Empleado;

GRANT SELECT ON Venta TO Gerente;
GRANT SELECT ON Cliente TO Gerente;
GRANT SELECT ON Persona TO Gerente;
GO

PRINT 'Roles y permisos asignados correctamente en base_sistema_ventas';
