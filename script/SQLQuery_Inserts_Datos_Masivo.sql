USE base_sistema_ventas;
GO

BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insertar en Categoria
    INSERT INTO Categoria (id_categoria, descripcion) VALUES 
        (1, 'Fundas y Protectores'), 
        (2, 'Pop Socket'), 
        (3, 'Auriculares y Altavoces'), 
        (4, 'Protectores de Pantalla'), 
        (5, 'Cargadores y Baterías'),
        (6, 'Soportes'), 
        (7, 'Lentes para Celulares'), 
        (8, 'Accesorios para Selfies');

    -- 2. Insertar en Perfil
    INSERT INTO Perfil (id_perfil, descripcion) VALUES 
        (1, 'Administrador'), 
        (2, 'Gerente'), 
        (3, 'Empleado');

    -- 3. Insertar en Pago
    INSERT INTO Pago (id_tipo, descripcion) VALUES 
        (1, 'Contado'), 
        (2, 'Crédito'), 
        (3, 'Débito');

    -- 4. Generar registros en la tabla Persona por lotes
    DECLARE @TempPersona TABLE (
        nombre VARCHAR(100),
        apellido VARCHAR(100),
        email VARCHAR(100),
        telefono VARCHAR(50),
        dni INT
    );

    DECLARE @iPersona INT = 1;
    WHILE @iPersona <= 5000
    BEGIN
        INSERT INTO @TempPersona (nombre, apellido, email, telefono, dni)
        VALUES 
            (CONCAT('Nombre', @iPersona), CONCAT('Apellido', @iPersona), CONCAT('email', @iPersona, '@example.com'), CONCAT('123456', @iPersona), @iPersona + 1000000);
        SET @iPersona += 1;
        
        -- Insertar en la tabla Persona cada 1000 registros
        IF @iPersona % 1000 = 0
        BEGIN
            INSERT INTO Persona (nombre, apellido, email, telefono, dni)
            SELECT nombre, apellido, email, telefono, dni
            FROM @TempPersona;
            
            -- Limpiar la variable de tabla para el siguiente lote
            DELETE FROM @TempPersona;
        END
    END;

    -- Insertar cualquier registro restante
    IF EXISTS (SELECT 1 FROM @TempPersona)
    BEGIN
        INSERT INTO Persona (nombre, apellido, email, telefono, dni)
        SELECT nombre, apellido, email, telefono, dni
        FROM @TempPersona;
    END

    -- 5. Generar registros en la tabla Cliente
    -- Crear una tabla temporal para almacenar los registros seleccionados
    CREATE TABLE #TempCliente (id_cliente INT);

    -- Insertar los registros seleccionados
    INSERT INTO #TempCliente (id_cliente)
    SELECT id_persona 
    FROM Persona
    WHERE id_persona % 2 = 1;

    -- Insertar en Cliente por lotes
    DECLARE @batchSizeCliente INT = 1000;
    DECLARE @offsetCliente INT = 0;

    WHILE @offsetCliente < (SELECT COUNT(*) FROM #TempCliente)
    BEGIN
        INSERT INTO Cliente (id_cliente)
        SELECT id_cliente
        FROM #TempCliente
        ORDER BY id_cliente
        OFFSET @offsetCliente ROWS FETCH NEXT @batchSizeCliente ROWS ONLY;

        SET @offsetCliente = @offsetCliente + @batchSizeCliente;
    END;

    -- Eliminar la tabla temporal
    DROP TABLE #TempCliente;

    -- 6. Generar registros en la tabla Usuario
    -- Crear una tabla temporal para almacenar los registros seleccionados
    CREATE TABLE #TempUsuario (
        nombre_usuario VARCHAR(100),
        contraseña VARCHAR(100),
        id_usuario INT,
        id_perfil INT
    );

    -- Insertar los registros seleccionados
    INSERT INTO #TempUsuario (nombre_usuario, contraseña, id_usuario, id_perfil)
    SELECT 
        CONCAT('Usuario', id_persona), 
        'password123', 
        id_persona, 
        1 + (id_persona % 3)
    FROM Persona
    WHERE id_persona % 2 = 0;

    -- Insertar en Usuario por lotes
    DECLARE @offsetUsuario INT = 0;

    WHILE @offsetUsuario < (SELECT COUNT(*) FROM #TempUsuario)
    BEGIN
        INSERT INTO Usuario (nombre_usuario, contraseña, id_usuario, id_perfil)
        SELECT nombre_usuario, contraseña, id_usuario, id_perfil
        FROM #TempUsuario
        ORDER BY id_usuario
        OFFSET @offsetUsuario ROWS FETCH NEXT @batchSizeCliente ROWS ONLY;

        SET @offsetUsuario = @offsetUsuario + @batchSizeCliente;
    END;

    -- Eliminar la tabla temporal
    DROP TABLE #TempUsuario;

    -- 7. Generar registros en la tabla Producto por lotes
    DECLARE @TempProducto TABLE (
        nombre_producto VARCHAR(100),
        precio DECIMAL(10, 2),
        stock INT,
        id_categoria INT
    );

    DECLARE @iProducto INT = 1;
    WHILE @iProducto <= 5000
    BEGIN
        INSERT INTO @TempProducto (nombre_producto, precio, stock, id_categoria)
        VALUES 
            (CONCAT('Producto', @iProducto), ROUND(RAND() * 100, 2), ABS(CHECKSUM(NEWID())) % 1000 + 1, 1 + (@iProducto % 8));
        SET @iProducto += 1;
        
        -- Insertar en la tabla Producto cada 1000 registros
        IF @iProducto % 1000 = 0
        BEGIN
            INSERT INTO Producto (nombre_producto, precio, stock, id_categoria)
            SELECT nombre_producto, precio, stock, id_categoria
            FROM @TempProducto;
            
            -- Limpiar la variable de tabla para el siguiente lote
            DELETE FROM @TempProducto;
        END
    END;

    -- Insertar cualquier registro restante
    IF EXISTS (SELECT 1 FROM @TempProducto)
    BEGIN
        INSERT INTO Producto (nombre_producto, precio, stock, id_categoria)
        SELECT nombre_producto, precio, stock, id_categoria
        FROM @TempProducto;
    END

    -- 8. Generar registros en la tabla Venta por lotes
    DECLARE @TempVenta TABLE (
        fecha_venta DATETIME,
        total_venta DECIMAL(10, 2),
        id_usuario INT,
        id_tipo INT,
        id_cliente INT
    );

    DECLARE @iVenta INT = 1;
    WHILE @iVenta <= 4000
    BEGIN
        INSERT INTO @TempVenta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
        VALUES 
            (DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 3650, '2015-01-01'), ROUND(RAND() * 1000 + 100, 2),
             (SELECT TOP 1 id_usuario FROM Usuario ORDER BY NEWID()), 
             (SELECT TOP 1 id_tipo FROM Pago ORDER BY NEWID()), 
             (SELECT TOP 1 id_cliente FROM Cliente ORDER BY NEWID()));
        SET @iVenta += 1;
        
        -- Insertar en la tabla Venta cada 1000 registros
        IF @iVenta % 1000 = 0
        BEGIN
            INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
            SELECT fecha_venta, total_venta, id_usuario, id_tipo, id_cliente
            FROM @TempVenta;
            
            -- Limpiar la variable de tabla para el siguiente lote
            DELETE FROM @TempVenta;
        END
    END;

    -- Insertar cualquier registro restante
    IF EXISTS (SELECT 1 FROM @TempVenta)
    BEGIN
        INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
        SELECT fecha_venta, total_venta, id_usuario, id_tipo, id_cliente
        FROM @TempVenta;
    END

    -- 9. Generar registros en la tabla Detalle_Venta por lotes
    DECLARE @TempDetalleVenta TABLE (
        cantidad INT,
        id_producto INT,
        subtotal DECIMAL(10, 2),
        id_venta INT
    );

    DECLARE @iDetalleVenta INT = 1;
    WHILE @iDetalleVenta <= 6000
    BEGIN
        INSERT INTO @TempDetalleVenta (cantidad, id_producto, subtotal, id_venta)
        VALUES 
            (ABS(CHECKSUM(NEWID())) % 10 + 1,
             (SELECT TOP 1 id_producto FROM Producto ORDER BY NEWID()), 
             ROUND(RAND() * 500, 2), 
             (SELECT TOP 1 id_venta FROM Venta ORDER BY NEWID()));
        SET @iDetalleVenta += 1;
        
        -- Insertar en la tabla Detalle_Venta cada 1000 registros
        IF @iDetalleVenta % 1000 = 0
        BEGIN
            INSERT INTO Detalle_Venta (cantidad, id_producto, subtotal, id_venta)
            SELECT cantidad, id_producto, subtotal, id_venta
            FROM @TempDetalleVenta;
            
            -- Limpiar la variable de tabla para el siguiente lote
            DELETE FROM @TempDetalleVenta;
        END
    END;

    -- Insertar cualquier registro restante
    IF EXISTS (SELECT 1 FROM @TempDetalleVenta)
    BEGIN
        INSERT INTO Detalle_Venta (cantidad, id_producto, subtotal, id_venta)
        SELECT cantidad, id_producto, subtotal, id_venta
        FROM @TempDetalleVenta;
    END

    COMMIT;

END TRY
BEGIN CATCH
    -- En caso de error, revertir la transacción
    ROLLBACK;
    PRINT ERROR_MESSAGE();
END CATCH;

-- Verificar los registros insertados
SELECT 'Persona' AS Tabla, COUNT(*) AS Registros FROM Persona
UNION ALL
SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL
SELECT 'Perfil', COUNT(*) FROM Perfil
UNION ALL
SELECT 'Usuario', COUNT(*) FROM Usuario
UNION ALL
SELECT 'Pago', COUNT(*) FROM Pago
UNION ALL
SELECT 'Producto', COUNT(*) FROM Producto
UNION ALL
SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL
SELECT 'Venta', COUNT(*) FROM Venta
UNION ALL
SELECT 'Detalle_Venta', COUNT(*) FROM Detalle_Venta;
