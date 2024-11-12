-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas4;
GO

-- 1. Insertar categorías (si no existen)
IF NOT EXISTS (SELECT 1 FROM Categoria)
BEGIN
	INSERT INTO Categoria (id_categoria, descripcion) VALUES 
	(1, 'Fundas y Protectores'), 
	(2, 'Pop Socket'), 
	(3, 'Auriculares y Altavoces');
END

-- 2. Insertar perfiles (si no existen)
IF NOT EXISTS (SELECT 1 FROM Perfil)
BEGIN
	INSERT INTO Perfil (id_perfil, descripcion) VALUES 
	(1, 'Administrador'), (2, 'Gerente'), (3, 'Empleado');
END 

-- 3. Insertar formas de pago (si no existen)
IF NOT EXISTS (SELECT 1 FROM Pago)
BEGIN
	INSERT INTO Pago (id_tipo, descripcion) VALUES 
	(1, 'Contado'), (2, 'Crédito'), (3, 'Débito');
END 

-- 4. Insertar productos
INSERT INTO Producto (nombre_producto, precio, stock, id_categoria) VALUES 
('Funda de Silicona para iPhone', 10.99, 20, 1),
('Pop Socket Estilo Mandala', 3.99, 0, 2),
('Auriculares Bluetooth Deportivos', 25.99, 15, 3);

-- 5. Insertar personas
INSERT INTO Persona (nombre, apellido, email, telefono, dni) VALUES 
('Carlos', 'Rodríguez', 'carlos.rodriguez@example.com', '3794234505', 34567890),
('Silvia', 'Mendoza', 'silvia.mendoza@example.com', '3792345671', 34567801);

-- 6. Insertar usuarios
INSERT INTO Usuario (nombre_usuario, contraseña, id_usuario, id_perfil) VALUES 
('Carlos', '12345678',
     (SELECT id_persona 
      FROM Persona 
      WHERE dni = 34567890), 3);

-- 7. Insertar clientes
INSERT INTO Cliente (id_cliente)
VALUES ((SELECT id_persona 
      FROM Persona 
      WHERE dni = 34567801));
GO

-- Una vez cargados los datos vamos a crear procedimientos almacenados para diferente funciones
-- Procedimiento para registrar una nueva venta
CREATE PROCEDURE RegistrarVenta
    @fecha_venta DATE,
    @total_venta FLOAT,
    @id_usuario INT,
    @id_tipo INT,
    @id_cliente INT,
    @id_venta INT OUTPUT  -- Parámetro de salida para devolver el ID de la venta
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en la tabla Venta
        INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
        VALUES (@fecha_venta, @total_venta, @id_usuario, @id_tipo, @id_cliente);

        -- Obtener el ID de la venta recién insertada
        SET @id_venta = SCOPE_IDENTITY();

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO

-- Procedimiento para registrar el detalle de una venta
CREATE PROCEDURE RegistrarDetalleVenta
    @id_venta INT,
    @id_producto INT,
    @cantidad INT,
    @subtotal FLOAT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, subtotal)
        VALUES (@id_venta, @id_producto, @cantidad, @subtotal);
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Procedimiento para eliminar una venta
CREATE PROCEDURE EliminarVenta
    @id_venta INT
AS
BEGIN
    BEGIN TRY
        -- Eliminar primero los detalles de venta asociados
        DELETE FROM Detalle_Venta WHERE id_venta = @id_venta;
        
        -- Luego, eliminar la venta
        DELETE FROM Venta WHERE id_venta = @id_venta;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Procedimiento para eliminar un detalle de venta
CREATE PROCEDURE EliminarDetalleVenta
    @id_detalle INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Detalle_Venta WHERE id_detalle = @id_detalle;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Procedimiento para actualizar el stock de un product
CREATE PROCEDURE ActualizarStockProducto
    @id_producto INT,
    @cantidad INT
AS
BEGIN
    BEGIN TRY
        UPDATE Producto
        SET stock = stock - @cantidad
        WHERE id_producto = @id_producto;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- Función para contar el total de ventas en un mes específico
CREATE FUNCTION TotalVentasPorMes(@mes INT, @anio INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalVentas INT;
    SELECT @totalVentas = COUNT(*)
    FROM Venta
    WHERE MONTH(fecha_venta) = @mes AND YEAR(fecha_venta) = @anio;
    RETURN ISNULL(@totalVentas, 0);
END;
GO

-- Estos procedimientos nos ayudarán a manejar más eficientemente el proceso de una venta
