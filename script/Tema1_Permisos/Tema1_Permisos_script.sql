-------------------------------------------
---------- CREACIÓN BASE DE DATOS ----------
-------------------------------------------

CREATE DATABASE base_sistema_ventas;
GO

USE base_sistema_ventas;
GO

----------------------------------------
---------- CREACIÓN DE TABLAS ----------
----------------------------------------

IF OBJECT_ID('Detalle_Venta', 'U') IS NOT NULL DROP TABLE Detalle_Venta;
IF OBJECT_ID('Venta', 'U') IS NOT NULL DROP TABLE Venta;
IF OBJECT_ID('Cliente', 'U') IS NOT NULL DROP TABLE Cliente;
IF OBJECT_ID('Producto', 'U') IS NOT NULL DROP TABLE Producto;
IF OBJECT_ID('Pago', 'U') IS NOT NULL DROP TABLE Pago;
IF OBJECT_ID('Usuario', 'U') IS NOT NULL DROP TABLE Usuario;
IF OBJECT_ID('Perfil', 'U') IS NOT NULL DROP TABLE Perfil;
IF OBJECT_ID('Categoria', 'U') IS NOT NULL DROP TABLE Categoria;
IF OBJECT_ID('Persona', 'U') IS NOT NULL DROP TABLE Persona;
GO

CREATE TABLE Persona
(
  id_persona INT IDENTITY(1,1),
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  telefono VARCHAR(30) NOT NULL,
  dni INT NOT NULL,
  CONSTRAINT PK_Persona_id PRIMARY KEY (id_persona),
  CONSTRAINT UQ_Persona_email UNIQUE (email),
  CONSTRAINT UQ_Persona_dni UNIQUE (dni),
  CONSTRAINT UQ_Persona_telefono UNIQUE (telefono)
);
GO

CREATE TABLE Categoria
(
  id_categoria INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Categoria_id PRIMARY KEY (id_categoria)
);
GO

CREATE TABLE Perfil
(
  id_perfil INT NOT NULL,
  descripcion VARCHAR(20) NOT NULL,
  CONSTRAINT PK_Perfil_id PRIMARY KEY (id_perfil)
);
GO

CREATE TABLE Usuario
(
  nombre_usuario VARCHAR(50) NOT NULL,
  contraseña VARCHAR(50) NOT NULL,
  id_usuario INT NOT NULL,
  id_perfil INT NOT NULL,
  CONSTRAINT PK_Usuario_id PRIMARY KEY (id_usuario),
  CONSTRAINT FK_Usuario_id_persona FOREIGN KEY (id_usuario) REFERENCES Persona(id_persona),
  CONSTRAINT FK_Usuario_id_perfil FOREIGN KEY (id_perfil) REFERENCES Perfil(id_perfil)
);
GO

CREATE TABLE Pago
(
  id_tipo INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Pago_id PRIMARY KEY (id_tipo)
);
GO

CREATE TABLE Producto
(
  id_producto INT IDENTITY(1,1),
  nombre_producto VARCHAR(50) NOT NULL,
  precio FLOAT NOT NULL,
  stock INT NOT NULL,
  id_categoria INT NOT NULL,
  CONSTRAINT PK_Producto_id PRIMARY KEY (id_producto),
  CONSTRAINT FK_Producto_id_categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
  CONSTRAINT UQ_Producto_nombre UNIQUE (nombre_producto)
);
GO

CREATE TABLE Cliente
(
  id_cliente INT NOT NULL,
  CONSTRAINT PK_Cliente_id PRIMARY KEY (id_cliente),
  CONSTRAINT FK_Cliente_id_persona FOREIGN KEY (id_cliente) REFERENCES Persona(id_persona)
);
GO

CREATE TABLE Venta
(
  id_venta INT IDENTITY(1,1),
  fecha_venta DATE NOT NULL,
  total_venta FLOAT NOT NULL,
  id_usuario INT NOT NULL,
  id_tipo INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT PK_Venta_id PRIMARY KEY (id_venta),
  CONSTRAINT FK_Venta_id_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  CONSTRAINT FK_Venta_id_tipo FOREIGN KEY (id_tipo) REFERENCES Pago(id_tipo),
  CONSTRAINT FK_Venta_id_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO

CREATE TABLE Detalle_Venta
(
  id_detalle INT IDENTITY(1,1),
  cantidad INT NOT NULL,
  id_producto INT NOT NULL,
  subtotal FLOAT NOT NULL,
  id_venta INT NOT NULL,
  CONSTRAINT PK_Detalle_Venta_id PRIMARY KEY (id_detalle),
  CONSTRAINT FK_Detalle_Venta_id_producto FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  CONSTRAINT FK_Detalle_Venta_id_venta FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);
GO

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