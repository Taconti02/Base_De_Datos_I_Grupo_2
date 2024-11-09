# Trabajo de campo Grupo 2

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Integrantes**: 
- Fernandez Lezcano, Luciana Itati 
- Coronas Almada, Priscila Jezabel 
- Conti, Tomás Ariel 

**Año**: 2024

## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio
**TEMA:** Diseño e Implementación de una Base de Datos para un Negocio de Venta de Productos 

### Definición o planteamiento del problema

Se necesita crear una base de datos para un negocio de venta de productos, en el cual el empleado pueda registrar las ventas que realiza.  
Cada cliente tiene una identificación propia y se necesita saber su DNI, nombre, apellido, teléfono, email. 
Cada empleado necesita estar registrado en el sistema con su nombre usuario, contraseña y el tipo de perfil al que pertenece. 
Al realizarse la venta se debe registrar la fecha, el método de pago, total de la compra, los datos del cliente y el vendedor que la realiza.  
En el detalle de venta se debe especificar la cantidad y los productos que se compraron con el subtotal. 
Cada producto debe tener su precio unitario, categoría y el stock disponible. 
Se deben considerar las siguientes restricciones en el diseño físico: 
- La longitud DNI debe ser menor o igual a 8 caracteres. 
- El campo de email, teléfono y DNI debe ser único. 

### Objetivo del Trabajo Practico: 

Se realiza el trabajo para poder aplicar de forma práctica los distintos temas que se van desarrollando en la materia de Base de Datos I. 

#### i. Objetivos Generales. 

Desarrollar una base de datos para un negocio de venta de productos que permita a los empleados registrar las ventas realizadas, gestionar la información de clientes, empleados y productos, y asegurar la integridad y unicidad de los datos. Este objetivo responde al problema principal de cómo organizar y manejar eficientemente la información del negocio. 

#### ii. Objetivos Específicos. 

1. Diseñar el modelo de datos: 
   - Crear un esquema conceptual que incluya las entidades y relaciones necesarias para representar la información del negocio. 
   - Definir las restricciones y reglas de integridad para asegurar la calidad de los datos. 
2. Implementar la base de datos: 
   - Utilizar el sistema de gestión de bases de datos (DBMS) de SQL Server para crear las tablas y relaciones definidas en el modelo conceptual. 
   - Implementar las restricciones. 
3. Registrar y gestionar la información de clientes: 
   - Asegurar que cada cliente tenga una identificación única y almacenar su DNI, nombre, apellido, teléfono y email. 
   - Garantizar la unicidad de los campos de email, teléfono y DNI. 
4. Registrar y gestionar la información de empleados: 
   - Registrar a cada empleado.  
5. Registrar las ventas realizadas: 
   - Almacenar la fecha, método de pago, total de la compra, datos del cliente y del vendedor para cada venta. 
   - Detallar la cantidad y los productos comprados con el subtotal en cada venta. 
6. Gestionar la información de productos: 
   - Almacenar el precio unitario, categoría y stock disponible de cada producto. 
   - Asegurar la actualización constante del stock disponible tras cada venta. 

## CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL

### Manejo de Permisos a nivel de usuarios de base de datos


---
### Procedimientos y funciones almacenadas

Un procedimiento almacenado en SQL Server es un conjunto de una o más instrucciones Transact-SQL que se almacena asociado a una base de datos. Similar a las estructuras en otros lenguajes de programación, los procedimientos almacenados pueden aceptar parámetros de entrada, devolver múltiples valores en forma de parámetros de salida, realizar operaciones en la base de datos (incluyendo llamadas a otros procedimientos) y retornar un valor de estado que indica al programa si la operación se completó con éxito o si ocurrieron errores, junto con sus causas.

Algunas de las **ventajas** de usar estos procesimientos son:
- **Tráfico de red reducido entre el cliente y el servidor:**
Los comandos se ejecutan en un único lote de código, reduciendo el tráfico de red entre el servidor y el cliente porque solo se envía la solicitud para ejecutar el procedimiento, en lugar de enviar cada comando por separado, haciéndolo más eficiente.

- **Mayor Seguridad:**
Un procedimiento almacenado en SQL Server permite que usuarios y programas accedan a objetos de la base de datos de forma controlada, sin necesitar permisos directos sobre ellos. Con la cláusula EXECUTE AS, los usuarios pueden ejecutar acciones específicas, como truncar una tabla, sin recibir permisos elevados. Esto simplifica la seguridad y protege los objetos.
Además ayudan a evitar ataques de inyección SQL al tratar los parámetros como valores literales, pueden cifrarse para ocultar su código y mantener la seguridad de la lógica interna.

- **Reutilización del código:**
Cualquier operación de base de datos que se repita mucho es ideal para ponerla dentro de un procedimiento almacenado. Así no es necesario escribir el mismo de nuevo, reducienddo inconsistencias y permitiendo que cualquier usuario o aplicación con los permisos necesarios pueda usarlo y ejecutarlo.

- **Mantenimiento sencillo:**
Cuando las aplicaciones llaman a procedimientos y dejan las operaciones en la base de datos, solo es necesario actualizar los cambios en la base de datos misma. La aplicación sigue funcionando sin tener que conocer ni adaptarse a los cambios en el diseño, relaciones o procesos de la base de datos.

- **Rendimiento Mejorado:**
Cuando se compila un procedimiento por primera vez genera un plan de ejecución que se reutiliza en las siguientes ejecuciones, por lo que al no tener que crear un nuevo plan nos toma menos tiempo procesarlo. Sin embargo, si hay cambios importantes en las tablas o datos, este plan precompilado podría hacer que el procedimiento se ejecute más lentamente. En esos casos, recrear el procedimiento y forzar un nuevo plan de ejecución puede mejorar su rendimiento.

**Tipos de procedimientos almacenados**
- **Definidas por el usuario:**
Se puede crear en una base de datos definida por el usuario o en todas las bases de datos del sistema excepto en la base de datos Resource. El procedimiento se puede desarrollar en Transact-SQL o como referencia a un método de Common Language Runtime (CLR) de Microsoft .NET Framework.

- **Temporales:**
Son una forma de procedimientos definidos por el usuario, que pueden ser permanente a menos que se almacenen en tempdb. Hay dos tipos: locales y globales.
Los **locales** tienen como primer carácter de sus nombres un solo signo de número (#); solo son visibles en la conexión actual del usuario y se eliminan cuando se cierra la conexión.
Los **globales** presentan dos signos de número (##) antes del nombre; son visibles para cualquier usuario después de su creación y se eliminan al final de la última sesión en la que se usa el procedimiento.

- **Sistema:**
Los procedimientos del sistema se incluyen con el motor de base de datos y están almacenados físicamente en la base de datos interna y oculta Resource, pero se muestran de forma lógica en el esquema sys de cada base de datos.

```sql
/*** Este procedimiento almacenado nos permite cargar una nueva persona a la base de datos ***/
CREATE PROC PA_CargarPersona
   @id_persona INT,
   @nombre VARCHAR(50),
   @apellido VARCHAR(50),
   @estado VARCHAR(11),
   @email VARCHAR(50),
   @sexo VARCHAR(11),
   @telefono VARCHAR(30),
   @cumpleaños DATE,
   @dni INT
AS
BEGIN
   INSERT INTO Persona
   VALUES (
      @id_persona,
      @nombre,
      @apellido,
      @estado,
      @email,
      @sexo,
      @telefono,
      @cumpleaños,
      @dni
   );

   SELECT 
      @id_persona = id_persona,
      @nombre = nombre,
      @apellido = apellido,
      @estado = estado,
      @email = email,
      @sexo = sexo,
      @telefono = telefono,
      @cumpleaños = cumpleaños,
      @dni = dni
   FROM Persona;

   SELECT * FROM Persona;
END
GO
```

---
### Optimización de consultas a través de índices

**¿Qué es un índice?**

Un índice es una estructura de disco asociada con una tabla o una vista que acelera la recuperación de filas de la tabla o de la vista. Un índice contiene claves generadas a partir de una o varias columnas de la tabla o la vista. Dichas claves están almacenadas en una estructura (árbol b) que permite que SQL Server busque de forma rápida y eficiente la fila o filas asociadas a los valores de cada clave.

**Optimización de consultas a través de índices**

La optimización de consultas a través de índices es una técnica crucial para mejorar el rendimiento de las bases de datos. Los índices permiten a las bases de datos acceder a la información de manera más eficiente, similar a cómo un índice en un libro permite encontrar información rápidamente sin tener que leer cada página.

**Ventajas de usar índices:**
- Mejora del rendimiento de las consultas: Los índices permiten a SQL Server encontrar filas rápidamente sin tener que escanear toda la tabla, lo cual acelera significativamente las consultas SELECT.
- Reducción de tiempos de respuesta: Los tiempos de respuesta se reducen drásticamente, especialmente en tablas grandes, ya que los índices permiten saltar directamente a los registros relevantes.
- Optimización de operaciones de unión (JOIN): Los índices pueden optimizar las operaciones de unión entre tablas, haciendo que estas operaciones sean más rápidas al facilitar el acceso a las filas relacionadas.
- Minimización de la contención en operaciones concurrentes: En escenarios de alta concurrencia, los índices pueden ayudar a reducir la contención de bloqueo al permitir que las consultas accedan a las filas necesarias más rápido.

**Tipos de Índices y sus Aplicaciones**

*Índices Clustered (Agrupados):*
- Determinan el orden físico de los datos en la tabla.
- Solo puede haber uno por tabla.
- Son útiles para consultas que devuelven rangos de datos grandes.

*Índices Non-Clustered (No Agrupados):*
- No alteran el orden físico de los datos.
- Puede haber múltiples índices non-clustered en una tabla.
- Son útiles para consultas que buscan valores específicos.

*Índices Únicos:*
- Aseguran que los valores en la columna indexada sean únicos.
- Son útiles para columnas como IDs o emails.

*Índices Compuestos:*
- Incluyen más de una columna.
- Son útiles para consultas que filtran por múltiples columnas.

**Índices y restricciones**

Los índices se crean automáticamente cuando las restricciones PRIMARY KEY y UNIQUE se definen en las columnas de tabla. Por ejemplo, cuando crea una tabla con una restricción UNIQUE, el motor de base de datos crea automáticamente un índice no agrupado. Si configura una restricción PRIMARY KEY, el motor de base de datos crea automáticamente un índice agrupado, a menos que ya exista uno. Cuando intenta aplicar una restricción PRIMARY KEY en una tabla existente y ya existe un índice agrupado en esa tabla, SQL Server aplica la clave principal mediante un índice no agrupado.

**Impacto de los Índices en el Rendimiento**

Los índices mejoran el rendimiento de las consultas SELECT al reducir la cantidad de datos que el motor de la base de datos debe escanear. Sin embargo, los índices también pueden aumentar el tiempo de las operaciones de inserción, actualización y eliminación, ya que estas operaciones requieren mantener los índices actualizados.

```sql
USE taller_db_1;
GO

-- Insertar datos de prueba en la tabla Tipo_Venta
INSERT INTO Tipo_Venta (id_tipo, descripcion)
VALUES 
(1, 'Venta Directa'),
(2, 'Venta Online'),
(3, 'Venta Telefónica');
GO



-- Insertar datos de prueba en la tabla Perfil
INSERT INTO Perfil (id_perfil, descripcion)
VALUES 
(1, 'Administrador'),
(2, 'Usuario'),
(3, 'Invitado');
GO


-- Insertar datos de prueba en la tabla Persona
INSERT INTO Persona (nombre, apellido, estado, email, sexo, telefono, cumpleaños, dni)
VALUES 
('Juan', 'Perez', 'A', 'juan.perez@example.com', 'M', '123456789', '1980-01-01', 12345678),
('Maria', 'Garcia', 'A', 'maria.garcia@example.com', 'F', '987654321', '1985-02-02', 87654321),
('Carlos', 'Lopez', 'A', 'carlos.lopez@example.com', 'M', '456789123', '1990-03-03', 23456789),
('Ana', 'Martinez', 'A', 'ana.martinez@example.com', 'F', '789123456', '1995-04-04', 34567890),
('Jose', 'Rodriguez', 'A', 'jose.rodriguez@example.com', 'M', '321654987', '2000-05-05', 45678912);
GO

-- Insertar datos de prueba en la tabla Cliente
INSERT INTO Cliente (id_cliente)
VALUES 
(1),
(2),
(3),
(4),
(5);
GO


-- Insertar datos de prueba en la tabla Usuario con nombres válidos
INSERT INTO Usuario (id_usuario, nombre_usuario, contraseña, id_perfil)
VALUES 
(1, 'userone', 'password1', 1),
(2, 'usertwo', 'password2', 1),
(3, 'userthree', 'password3', 1),
(4, 'userfour', 'password4', 1),
(5, 'userfive', 'password5', 1);
GO


-- Insertar datos de prueba en la tabla Venta 10000 datos
BEGIN TRANSACTION;
DECLARE @i INT = 0;
WHILE @i < 10000
BEGIN
    INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
    VALUES (DATEADD(DAY, @i % 365, '2023-01-01'), @i * 0.1, @i % 5 + 1, @i % 3 + 1, @i % 5 + 1);
    SET @i = @i + 1;

    IF @i % 1000 = 0 -- Cada 1,000 inserciones, confirmamos la transacción
    BEGIN
        COMMIT TRANSACTION;
        BEGIN TRANSACTION;
    END
END
COMMIT TRANSACTION;
GO



-- Consulta con índice no agrupado incluyendo columnas adicionales
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

USE taller_db_1;
GO

-- Insertar un millón de registros en la tabla Venta
BEGIN TRANSACTION;
DECLARE @i INT = 0;
WHILE @i < 1000000
BEGIN
    INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
    VALUES (DATEADD(DAY, @i % 365, '2023-01-01'), @i * 0.1, @i % 5 + 1, @i % 3 + 1, @i % 5 + 1);
    SET @i = @i + 1;

    IF @i % 10000 = 0 -- Cada 10,000 inserciones, confirmamos la transacción
    BEGIN
        COMMIT TRANSACTION;
        BEGIN TRANSACTION;
    END
END
COMMIT TRANSACTION;
GO



-- Consulta sin índice
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO


-- Crear índice no agrupado en fecha_venta
CREATE NONCLUSTERED INDEX IDX_Venta_FechaVenta ON Venta(fecha_venta);
GO

-- Consulta con índice no agrupado en fecha_venta
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Eliminar índice no agrupado en fecha_venta
DROP INDEX IDX_Venta_FechaVenta ON Venta;
GO

-- Eliminar índice no agrupado en fecha_venta
DROP INDEX IDX_Venta_FechaVenta_ClienteId ON Venta;
GO

-- Crear índice no agrupado con columnas adicionales
CREATE NONCLUSTERED INDEX IDX_Venta_FechaVenta_ClienteId ON Venta(fecha_venta, id_cliente);
GO

-- Consulta con índice no agrupado en fecha_venta e id_cliente
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Eliminar índice no agrupado en fecha_venta
DROP INDEX IDX_Venta_FechaVenta_ClienteId ON Venta;
GO
```



---
### Manejo de transacciones y transacciones anidadas


## CAPÍTULO III: METODOLOGÍA SEGUIDA

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama relacional
![diagrama_relacional](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/doc/diagrama_relacional.jpeg)


### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

## CAPÍTULO V: CONCLUSIONES

## BIBLIOGRAFÍA DE CONSULTA

 1. Base de Datos 2.2.3 Entidad relación [En Línea] Disponible en [eLibro UNNE](https://elibro.net/es/ereader/unne/121283?page=52 "eLibro UNNE") Pulido Romero, E. Escobar Domínguez 
2. Microsoft Ignite [En Línea] Disponible en [Learn/SQL/Procedimientos Almacenados](https://learn.microsoft.com/es-es/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver16)

Optimización de consultas a través de índices:

3. Cañizares, L. (2008). Bases de datos. Teoría y diseño (2ª ed.). Alfaomega.
4. Salvatierra, H. (2012). Optimización de consultas SQL en bases de datos relacionales. Editorial UOC
5. Microsoft Ignite [En Línea]. Disponible en Learn/SQL/Procedimientos Almacenados. Recuperado de https://learn.microsoft.com/es-es/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16

