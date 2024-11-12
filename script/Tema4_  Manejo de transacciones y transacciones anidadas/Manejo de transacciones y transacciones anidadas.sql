-- Parte 1: Transacci�n Consistente


USE base_sistema_ventas;
GO

BEGIN TRANSACTION;

BEGIN TRY
    -- Inserci�n en la tabla Persona
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Ana', 'Sanchez', 'ana.sanchez@example.com', '987654321', 98765432);  -- Cambiamos el tel�fono para evitar duplicados

    -- Inserci�n en la tabla Cliente
    INSERT INTO Cliente (id_cliente)
    VALUES (SCOPE_IDENTITY());

    -- Actualizaci�n en la tabla Usuario
    UPDATE Usuario
    SET nombre_usuario = 'nuevo_usuario'
    WHERE id_usuario = 1;

    -- Si todo es exitoso, confirmar la transacci�n
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si hay alg�n error, revertir la transacci�n
    ROLLBACK TRANSACTION;

    -- Mostrar informaci�n del error
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
    -- Inserci�n en la tabla Persona
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Ana', 'Sanchez', 'ana.sanchez@example.com', '123456789', 98765432);

    -- Provocar un error intencional (duplicar clave �nica)
    INSERT INTO Persona (nombre, apellido, email, telefono, dni)
    VALUES ('Error', 'Intentional', 'ana.sanchez@example.com', '123456789', 98765432);

    -- Inserci�n en la tabla Cliente
    INSERT INTO Cliente (id_cliente)
    VALUES (SCOPE_IDENTITY());

    -- Actualizaci�n en la tabla Usuario
    UPDATE Usuario
    SET nombre_usuario = 'nuevo_usuario'
    WHERE id_usuario = 1;

    -- Si todo es exitoso, confirmar la transacci�n
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    -- Si hay alg�n error, revertir la transacci�n
    ROLLBACK TRANSACTION;

    -- Mostrar informaci�n del error
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
