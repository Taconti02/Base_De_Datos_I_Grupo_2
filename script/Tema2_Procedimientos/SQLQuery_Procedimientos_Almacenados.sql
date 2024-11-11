-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Vamos a crear procedimientos almacenados para diferente funciones
-- Procedimiento para registrar una nueva venta

CREATE PROCEDURE RegistrarVenta
    @fecha_venta DATE,
    @total_venta FLOAT,
    @id_usuario INT,
    @id_tipo INT,
    @id_cliente INT
AS
BEGIN
    DECLARE @id_venta INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Insertar en la tabla Venta
        INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
        VALUES (@fecha_venta, @total_venta, @id_usuario, @id_tipo, @id_cliente);

        -- Obtener el ID de la venta recién insertada
        SET @id_venta = SCOPE_IDENTITY();

        COMMIT;
        RETURN @id_venta; -- Retornar el ID de la nueva venta
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

-- Función para obtener el total de ventas por cliente

CREATE FUNCTION TotalVentasPorCliente (@id_cliente INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @total FLOAT;

    SELECT @total = SUM(total_venta)
    FROM Venta
    WHERE id_cliente = @id_cliente;

    RETURN ISNULL(@total, 0);
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

-- Procedimiento para obtener el detalle de una venta

CREATE PROCEDURE ObtenerDetalleVenta
    @id_venta INT
AS
BEGIN
    SELECT 
        DV.id_detalle,
        P.nombre_producto,
        DV.cantidad,
        DV.subtotal
    FROM Detalle_Venta DV
    JOIN Producto P ON DV.id_producto = P.id_producto
    WHERE DV.id_venta = @id_venta;
END;
GO

-- Estos procedimientos nos ayudarán a manejar más eficientemente el proceso de una venta