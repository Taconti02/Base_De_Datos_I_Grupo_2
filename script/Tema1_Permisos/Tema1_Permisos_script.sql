-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- 1. Creación de Roles
CREATE ROLE Administrador;
CREATE ROLE Empleado;
CREATE ROLE Gerente;
GO

-- 2. Creación de Logins y Usuarios
USE master;
GO

-- Crear logins si no existen
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'admin')
    CREATE LOGIN admin WITH PASSWORD = 'adminpassword';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'employee')
    CREATE LOGIN employee WITH PASSWORD = 'employeepassword';

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'manager')
    CREATE LOGIN manager WITH PASSWORD = 'managerpassword';
GO

USE base_sistema_ventas;
GO

-- Crear usuarios en la base de datos si no existen
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    CREATE USER user_admin FOR LOGIN admin WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_employee')
    CREATE USER user_employee FOR LOGIN employee WITH DEFAULT_SCHEMA = dbo;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_manager')
    CREATE USER user_manager FOR LOGIN manager WITH DEFAULT_SCHEMA = dbo;
GO

-- 3. Asignación de Roles a Usuarios
-- Se asegura que cada usuario exista en la base de datos antes de asignarle un rol
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    ALTER ROLE Administrador ADD MEMBER user_admin;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_employee')
    ALTER ROLE Empleado ADD MEMBER user_employee;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_manager')
    ALTER ROLE Gerente ADD MEMBER user_manager;
GO

-- 4. Asignación de Permisos
GRANT CONTROL ON DATABASE::base_sistema_ventas TO Administrador;
GRANT SELECT, INSERT, UPDATE ON Venta TO Empleado;
GRANT SELECT, INSERT, UPDATE ON Detalle_Venta TO Empleado;
GRANT SELECT ON Cliente TO Empleado;
GRANT SELECT ON Producto TO Empleado;
GRANT SELECT ON Venta TO Gerente;
GRANT SELECT ON Cliente TO Gerente;
GRANT SELECT ON Persona TO Gerente;
GO

-- 5. Creación de Roles Predefinidos
CREATE ROLE READONLY;
CREATE ROLE READWRITE;
CREATE ROLE ADMIN;
GO

GRANT SELECT ON SCHEMA::dbo TO READONLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO READWRITE;
GRANT CONTROL ON DATABASE::base_sistema_ventas TO ADMIN;
GO

-- Asignar roles predefinidos a usuarios específicos
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_manager')
    ALTER ROLE READONLY ADD MEMBER user_manager;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_employee')
    ALTER ROLE READWRITE ADD MEMBER user_employee;

IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'user_admin')
    ALTER ROLE ADMIN ADD MEMBER user_admin;
GO

PRINT 'Roles y permisos asignados correctamente en base_sistema_ventas';
