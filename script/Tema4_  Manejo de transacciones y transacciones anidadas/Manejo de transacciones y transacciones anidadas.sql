-- Parte 1: Transacción Consistente


USE base_sistema_ventas;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- Inserción en la tabla Persona
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Ana', 'Sanchez', 'ana.sanchez@example.com', '987654321', 98765432);  -- Cambiamos el teléfono para evitar duplicados

    -- Inserción en la tabla Cliente
    INSERT INTO Cliente (id_cliente)
    VALUES (SCOPE_IDENTITY());

    -- Actualización en la tabla Usuario
    UPDATE Usuario
    SET nombre_usuario = 'nuevo_usuario'
    WHERE id_usuario = 1;

    -- Si todo es exitoso, confirmar la transacción
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si hay algún error, revertir la transacción
    ROLLBACK TRANSACTION;

    -- Mostrar información del error
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO



-- Parte 2: Provocar un Error y Verificar la Consistencia


USE base_sistema_ventas;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- Inserción en la tabla Persona
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Ana', 'Sanchez', 'ana.sanchez@example.com', '123456789', 98765432);

    -- Provocar un error intencional (duplicar clave única)
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Error', 'Intentional', 'ana.sanchez@example.com', '123456789', 98765432);

    -- Inserción en la tabla Cliente
    INSERT INTO Cliente (id_cliente)
    VALUES (SCOPE_IDENTITY());

    -- Actualización en la tabla Usuario
    UPDATE Usuario
    SET nombre_usuario = 'nuevo_usuario'
    WHERE id_usuario = 1;

    -- Si todo es exitoso, confirmar la transacción
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si hay algún error, revertir la transacción
    ROLLBACK TRANSACTION;

    -- Mostrar información del error
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO
