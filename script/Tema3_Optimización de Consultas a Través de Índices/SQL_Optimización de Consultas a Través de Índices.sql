
USE base_sistema_ventas;
GO
-- Parte 1: Carga Masiva de Datos


-- Crear tabla Ventas_Prueba para pruebas
CREATE TABLE Ventas_Prueba
(
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha_venta DATE NOT NULL,
    total_venta FLOAT NOT NULL,
    id_usuario INT NOT NULL,
    id_tipo INT NOT NULL,
    id_cliente INT NOT NULL
);
GO

-- Insertar un millón de registros en la tabla Ventas_Prueba
BEGIN TRANSACTION;
DECLARE @i INT = 0;
WHILE @i < 1000000
BEGIN
    INSERT INTO Ventas_Prueba (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
    VALUES (DATEADD(DAY, @i % 365, '2023-01-01'), @i * 0.1, @i % 100, @i % 5, @i % 1000);
    SET @i = @i + 1;

    IF @i % 10000 = 0 -- Cada 10,000 inserciones, confirmamos la transacción
    BEGIN
        COMMIT TRANSACTION;
        BEGIN TRANSACTION;
    END
END
COMMIT TRANSACTION;
GO




-- Parte 2: Realizar una Búsqueda por Periodo y Registrar el Plan de Ejecución

-- Habilitar el plan de ejecución
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Consulta sin índice
SELECT * FROM Ventas_Prueba WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Deshabilitar el plan de ejecución
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO


-- Parte 3: Definir un Índice Agrupado sobre la Columna Fecha y Repetir la Consulta

-- Eliminar clave primaria que es un índice agrupado
ALTER TABLE Ventas_Prueba DROP CONSTRAINT PK__Ventas_P__459533BFDAC4B70A;
GO

-- Crear índice agrupado en fecha_venta
CREATE CLUSTERED INDEX IDX_Ventas_Prueba_FechaVenta ON Ventas_Prueba(fecha_venta);
GO

-- Habilitar el plan de ejecución
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Consulta con índice agrupado en fecha_venta
SELECT * FROM Ventas_Prueba WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Deshabilitar el plan de ejecución
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO


-- Parte 4: Borrar el Índice Creado

-- Eliminar índice agrupado en fecha_venta
DROP INDEX IDX_Ventas_Prueba_FechaVenta ON Ventas_Prueba;
GO



-- Parte 5: Crear Otro Índice Agrupado Incluyendo las Columnas Seleccionadas y Repetir la Consulta


-- Crear índice agrupado en fecha_venta e id_cliente
CREATE CLUSTERED INDEX IDX_Ventas_Prueba_FechaVenta_Cliente ON Ventas_Prueba(fecha_venta, id_cliente);
GO

-- Habilitar el plan de ejecución
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- Consulta con índice agrupado en fecha_venta e id_cliente
SELECT * FROM Ventas_Prueba WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Deshabilitar el plan de ejecución
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

