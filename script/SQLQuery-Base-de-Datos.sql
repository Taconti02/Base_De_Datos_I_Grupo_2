CREATE DATABASE base_de_datos;

USE base_de_datos;

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
  CONSTRAINT UQ_Persona_telefono UNIQUE (telefono),
);

CREATE TABLE Categoria
(
  id_categoria INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Categoria_id PRIMARY KEY (id_categoria)
);

CREATE TABLE Perfil
(
  id_perfil INT NOT NULL,
  descripcion VARCHAR(20) NOT NULL,
  CONSTRAINT PK_Perfil_id PRIMARY KEY (id_perfil)
);

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

CREATE TABLE Pago
(
  id_pago INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT PK_Pago_id PRIMARY KEY (id_pago)
);

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

CREATE TABLE Cliente
(
  id_cliente INT NOT NULL,
  CONSTRAINT PK_Cliente_id PRIMARY KEY (id_cliente),
  CONSTRAINT FK_Cliente_id_persona FOREIGN KEY (id_cliente) REFERENCES Persona(id_persona)
);

CREATE TABLE Venta
(
  id_venta INT IDENTITY(1,1),
  fecha_venta DATE NOT NULL,
  total_venta FLOAT NOT NULL,
  id_usuario INT NOT NULL,
  id_pago INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT PK_Venta_id PRIMARY KEY (id_venta),
  CONSTRAINT FK_Venta_id_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  CONSTRAINT FK_Venta_id_pago FOREIGN KEY (id_pago) REFERENCES Pago(id_pago),
  CONSTRAINT FK_Venta_id_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
);

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

-- RESTRICCIONES --
ALTER TABLE Persona ADD CONSTRAINT CK_nombre CHECK (nombre NOT LIKE '%[^A-Za-z ]%');
ALTER TABLE Persona ADD CONSTRAINT CK_apellido CHECK (apellido NOT LIKE '%[^A-Za-z ]%');
ALTER TABLE Persona ADD CONSTRAINT CK_telefono CHECK (telefono NOT LIKE '%[^0-9 +-%]');
ALTER TABLE Persona ADD CONSTRAINT CK_dni CHECK (dni < 100000000 AND dni > 999999);

ALTER TABLE Venta ADD CONSTRAINT DF_fecha_venta DEFAULT getdate() for fecha_venta;

ALTER TABLE Usuario ADD CONSTRAINT CK_contraseña CHECK (LEN(contraseña) >= 8);
ALTER TABLE Usuario ADD CONSTRAINT CK_nombre_usuario CHECK (nombre_usuario NOT LIKE '%[^A-Za-z ]%');

-- LOTE DE DATOS --
INSERT INTO Categoria (id_categoria, descripcion) VALUES 
(1, 'Fundas'), (2, 'Pop Socket'), (3, 'Auriculares'), (4, 'Glass');

INSERT INTO Perfil (id_perfil, descripcion) VALUES 
(1, 'Administrador'), (2, 'Gerente'), (3, 'Empleado');

INSERT INTO Pago (id_pago, descripcion) VALUES 
(1, 'Contado'), (2, 'Crédito'), (3, 'Débito');

INSERT INTO Persona (nombre, apellido, email, telefono, dni) VALUES 
('Juan', 'Perez', 'juancitop12@gmail.com', '3794284911', 27288012), 
('Marta', 'Torres', 'martatorres0@gmail.com', '3795104298', 38583412), 
('Luciana', 'Fernandez', 'lucifernadnez@gmail.com', '3794228310', 44176144),
('Ana', 'Gómez', 'ana.gomez@example.com', '9876-543210', 23456789),
('Carlos', 'Rodríguez', 'carlos.rodriguez@example.com', '3794234505', 34567890),
('María', 'López', 'maria.lopez@example.com', '3784876615', 45678901),
('Luis', 'Martínez', 'luis.martinez@example.com', '5544332211', 56789012),
('Sofía', 'Ruiz', 'sofia.ruiz@example.com', '6655443322', 67890123),
('Miguel', 'Sánchez', 'miguel.sanchez@example.com', '7432-655443', 78901234),
('Laura', 'Torres', 'laura.torres@example.com', '+ 8776-765544', 89012345),
('Ricardo', 'García', 'ricardo.garcia@example.com', '9988776655', 90123456),
('Patricia', 'Fernández', 'patricia.fernandez@example.com', '3795334155', 10123456);

INSERT INTO Usuario (nombre_usuario, contraseña, id_usuario, id_perfil)
VALUES ('Luci', '12345678', 3, 1), ('Juan', '12345678', 1, 2), ('MartaT', '12345678', 2, 3);

INSERT INTO Producto (nombre_producto, precio, stock, id_categoria) VALUES 
('Funda de silicona para iPhone 12', 12.99, 100, 1),
('Funda de cuero para Samsung Galaxy S21', 24.99, 50, 1),
('Pop Socket diseño floral', 5.99, 200, 2),
('Pop Socket liso negro', 4.99, 150, 2),
('Auriculares inalámbricos Bluetooth', 29.99, 80, 3),
('Auriculares con cable con micrófono', 9.99, 120, 3),
('Protector de pantalla de vidrio templado', 7.99, 180, 4),
('Protector de pantalla curvado', 10.99, 90, 4);

INSERT INTO Cliente(id_cliente)
VALUES (4), (5), (6), (7), (8), (9), (10), (11), (12);

INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_pago, id_cliente) VALUES 
('2023-09-01', 55.97, 1, 1, 4), 
('2023-09-05', 86.95, 2, 2, 5),  
('2023-09-10', 17.97, 3, 3, 6),  
('2023-09-12', 31.97, 3, 1, 7),  
('2023-09-15', 44.96, 1, 3, 8),  
('2023-09-20', 19.98, 3, 1, 9);   

INSERT INTO Detalle_Venta (cantidad, id_producto, subtotal, id_venta) VALUES 
(2, 1, 25.98, 1), (1, 5, 29.99, 1), (3, 2, 74.97, 2), (2, 3, 11.98, 2), (1, 7, 7.99, 3), (2, 4, 9.98, 3), (1, 6, 9.99, 4), (2, 8, 21.98, 4), (3, 1, 38.97, 5), (1, 3, 5.99, 5), (2, 6, 19.98, 6); 


select * from Categoria
select * from Perfil
select * from Persona
select * from Producto
select * from Pago
select * from Usuario
select * from Cliente
select * from Venta
select * from Detalle_Venta