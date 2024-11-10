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


### Manejo de Permisos a Nivel de Usuarios de Base de Datos

### Conceptos Básicos
Para garantizar la seguridad y la integridad de la base de datos, es crucial manejar adecuadamente los permisos a nivel de usuarios. Los permisos determinan qué acciones pueden realizar los usuarios dentro de la base de datos. A continuación, se describen los conceptos fundamentales:

### Roles de Usuarios
   - Administrador: Tiene todos los permisos y puede gestionar otros usuarios.
   - Empleado: Permisos para registrar y consultar ventas.
   - Gerente: Permisos para consultar sus datos personales y el historial de compras.

### Tipos de Permisos
   - SELECT: Permite leer datos.
   - INSERT: Permite insertar nuevos datos.
   - UPDATE: Permite modificar datos existentes.
   - DELETE: Permite eliminar datos.

### Seguridad a Nivel de Objeto
Permite definir permisos específicos para tablas, vistas, procedimientos almacenados, etc.

### Implementación de Permisos
Creación de Usuarios y Asignación de Roles:

```sql
-- Crear roles
CREATE ROLE Administrador;
CREATE ROLE Empleado;
CREATE ROLE Gerente;

-- Crear usuarios y asignar roles
CREATE USER user_admin WITH PASSWORD = 'adminpassword';
CREATE USER user_employee WITH PASSWORD = 'employeepassword';
CREATE USER user_manager WITH PASSWORD = 'managerpassword';

-- Asignar roles a los usuarios
ALTER ROLE Administrador ADD MEMBER user_admin;
ALTER ROLE Empleado ADD MEMBER user_employee;
ALTER ROLE Gerente ADD MEMBER user_manager;
```

Asignación de Permisos:

```sql
-- Permisos para el rol de Administrador
GRANT ALL PRIVILEGES ON SCHEMA public TO Administrador;

-- Permisos para el rol de Empleado
GRANT SELECT, INSERT, UPDATE ON TABLE ventas TO Empleado;
GRANT SELECT ON TABLE clientes TO Empleado;

-- Permisos para el rol de Gerente
GRANT SELECT ON TABLE clientes TO Gerente;
```

### Recomendaciones de Seguridad:

### Mínimo Privilegio
Asignar solo los permisos necesarios para que los usuarios realicen sus tareas. Esto reduce el riesgo de accesos no autorizados o errores accidentales.

### Revisión Periódica
Revisar y ajustar permisos regularmente para adaptarse a cambios en roles y responsabilidades. Es importante eliminar los permisos de los usuarios que ya no los necesitan.

### Monitoreo y Auditoría
Mantener un registro de las actividades de los usuarios para detectar y prevenir accesos no autorizados. Herramientas de monitoreo y auditoría pueden ayudar a identificar actividades sospechosas o violaciones de seguridad.

### Buenas Prácticas Adicionales
### Uso de Roles Predefinidos:

   - READONLY: Un rol para usuarios que solo necesitan leer datos.
   - READWRITE: Un rol para usuarios que necesitan leer y escribir datos.
   - ADMIN: Un rol para administradores que necesitan acceso total.

```sql
-- Crear roles predefinidos
CREATE ROLE READONLY;
CREATE ROLE READWRITE;
CREATE ROLE ADMIN;

-- Asignar permisos a roles predefinidos
GRANT SELECT ON ALL TABLES IN SCHEMA public TO READONLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO READWRITE;
GRANT ALL PRIVILEGES ON SCHEMA public TO ADMIN;
```

### Implementación de Roles y Usuarios en un Proyecto Real:

### Planificación de Roles y Permisos:
   - Analizar las tareas y responsabilidades de cada tipo de usuario.
   - Definir claramente los roles y los permisos necesarios para cada rol.
   - Documentación de Roles y Permisos:
   - Mantener una documentación detallada de todos los roles, permisos y usuarios. Actualizar la documentación regularmente para reflejar cualquier cambio.

### Capacitación y Concienciación
Capacitar a los usuarios sobre la importancia de la seguridad y las mejores prácticas, fomentando una cultura de seguridad dentro de la organización.

### Ejemplo Completo de Implementación:

```sql
-- Crear roles
CREATE ROLE Administrador;
CREATE ROLE Empleado;
CREATE ROLE Gerente;

-- Crear usuarios y asignar roles
CREATE USER admin WITH PASSWORD = 'adminpassword';
CREATE USER employee WITH PASSWORD = 'employeepassword';
CREATE USER manager WITH PASSWORD = 'managerpassword';

-- Asignar roles a los usuarios
ALTER ROLE Administrador ADD MEMBER admin;
ALTER ROLE Empleado ADD MEMBER employee;
ALTER ROLE Gerente ADD MEMBER manager;

-- Permisos para el rol de Administrador
GRANT ALL PRIVILEGES ON SCHEMA public TO Administrador;

-- Permisos para el rol de Empleado
GRANT SELECT, INSERT, UPDATE ON TABLE ventas TO Empleado;
GRANT SELECT ON TABLE clientes TO Empleado;

-- Permisos para el rol de Gerente
GRANT SELECT ON TABLE clientes TO Gerente;

-- Buenas prácticas adicionales
-- Crear roles predefinidos
CREATE ROLE READONLY;
CREATE ROLE READWRITE;
CREATE ROLE ADMIN;

-- Asignar permisos a roles predefinidos
GRANT SELECT ON ALL TABLES IN SCHEMA public TO READONLY;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO READWRITE;
GRANT ALL PRIVILEGES ON SCHEMA public TO ADMIN;

-- Asignar roles predefinidos a usuarios existentes
ALTER ROLE READONLY ADD MEMBER manager;
ALTER ROLE READWRITE ADD MEMBER employee;
ALTER ROLE ADMIN ADD MEMBER admin;
```

--- 

### Optimización de consultas a través de índices

**¿Qué es un índice?**

Un índice es una estructura de disco asociada con una tabla o una vista que acelera la recuperación de filas de la tabla o de la vista. Un índice contiene claves generadas a partir de una o varias columnas de la tabla o la vista. Dichas claves están almacenadas en una estructura (árbol B) que permite que SQL Server busque de forma rápida y eficiente la fila o filas asociadas a los valores de cada clave.

**Optimización de consultas a través de índices**

La optimización de consultas a través de índices es una técnica crucial para mejorar el rendimiento de las bases de datos. Los índices permiten a las bases de datos acceder a la información de manera más eficiente, similar a cómo un índice en un libro permite encontrar información rápidamente sin tener que leer cada página.

**Ventajas de usar índices:**
- **Mejora del rendimiento de las consultas:** Los índices permiten a SQL Server encontrar filas rápidamente sin tener que escanear toda la tabla, lo cual acelera significativamente las consultas SELECT.
- **Reducción de tiempos de respuesta:** Los tiempos de respuesta se reducen drásticamente, especialmente en tablas grandes, ya que los índices permiten saltar directamente a los registros relevantes.
- **Optimización de operaciones de unión (JOIN):** Los índices pueden optimizar las operaciones de unión entre tablas, haciendo que estas operaciones sean más rápidas al facilitar el acceso a las filas relacionadas.
- **Minimización de la contención en operaciones concurrentes:** En escenarios de alta concurrencia, los índices pueden ayudar a reducir la contención de bloqueo al permitir que las consultas accedan a las filas necesarias más rápido.

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

**Prueba en script SQL de indices**

A continuacion se prueban los indices usando codigo SQL, teniendo como base el script que creo la estructura inicial:

```sql

-- Consulta sin índice para probar rendimiento inicial
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Crear índice no agrupado en fecha_venta
CREATE NONCLUSTERED INDEX IDX_Venta_FechaVenta ON Venta(fecha_venta);
GO

-- Consulta con índice no agrupado en fecha_venta
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Eliminar índice no agrupado en fecha_venta para crear un índice compuesto
DROP INDEX IDX_Venta_FechaVenta ON Venta;
GO

-- Crear índice no agrupado compuesto en fecha_venta e id_cliente
CREATE NONCLUSTERED INDEX IDX_Venta_FechaVenta_ClienteId ON Venta(fecha_venta, id_cliente);
GO

-- Consulta con índice compuesto en fecha_venta e id_cliente
SELECT * FROM Venta WHERE fecha_venta BETWEEN '2023-01-01' AND '2023-12-31';
GO

-- Eliminar índice compuesto en fecha_venta e id_cliente después de las pruebas
DROP INDEX IDX_Venta_FechaVenta_ClienteId ON Venta;
GO

```

---
### Manejo de transacciones y transacciones anidadas
Una transacción es un conjunto de operaciones que se tratan como una única unidad, es decir, todas las modificaciones realizadas dentro de la transacción deben confirmarse en conjunto o revertirse por completo en caso de error. Para iniciar una transacción se utiliza la sentencia BEGIN TRAN. Si alguna operación dentro de la transacción falla, es necesario revertir todos los cambios realizados con ROLLBACK TRAN, devolviendo la base de datos a su estado inicial. Si la transacción tiene éxito, se finaliza con COMMIT TRAN y los cambios realizados se guardan permanentemente en la base de datos. Además, los puntos de recuperación, o SavePoints, permiten hacer reversiones parciales, lo que significa que puedes deshacer solo hasta un punto específico de la transacción sin tener que revertirla por completo. También se pueden manejar las transacciones tomadas como excepciones mediante un TRY o un CATCH, así como con un operador condicional IF.

SQL Server admite varios modos de transacción, cada uno con características específicas:

- **Transacciones de confirmación automática:** Cada instrucción que se ejecuta se trata como una transacción independiente. No es necesario especificar un inicio ni fin de transacción; cada operación se confirma o se revierte automáticamente.

- **Transacciones explícitas:** El usuario controla explícitamente el inicio y fin de la transacción. Una transacción comienza con BEGIN TRANSACTION y se completa con COMMIT (para confirmar los cambios) o ROLLBACK (para revertirlos en caso de error).

- **Transacciones implícitas:** Cada vez que una transacción termina (con COMMIT o ROLLBACK), SQL Server inicia automáticamente una nueva transacción. Sin embargo, cada transacción sigue necesitando un COMMIT o ROLLBACK explícito para completar o revertir los cambios.

- **Transacciones de ámbito de lote:** Este tipo de transacción aplica solo cuando se usa una sesión de MARS (Conjuntos de Resultados Activos Múltiples), que permite ejecutar múltiples consultas al mismo tiempo en la misma conexión. Las transacciones en MARS se llaman "de ámbito de lote" porque, si no se confirman o revierten al finalizar el lote de instrucciones, SQL Server revierte automáticamente los cambios para mantener la integridad de los datos.

#### Transacciones anidadas
SQL Server también permite el uso de transacciones anidadas, es decir, transacciones dentro de otras transacciones. Esto significa que se puede iniciar una nueva transacción sin haber terminado la anterior. Cada transacción interna tiene sus propias instrucciones de BEGIN TRANSACTION, COMMIT, y ROLLBACK, aunque la confirmación o reversión final de los cambios depende de la transacción externa principal: solo se confirmarán permanentemente si todas las transacciones, incluyendo las anidadas, se completan correctamente. 

```sql

/*** Esta transacción cancela la operación si no hay stock del producto ***/
CREATE PROC comprarProducto (
   @cod_usuario INT,
   @cod_cliente INT,
   @cod_producto INT,
   @cantidad INT,
   @total_venta FLOAT,
   @fecha_venta DATE
)
AS
BEGIN
BEGIN TRY
   BEGIN TRANSACTION

   DECLARE @fecha_emision DATETIME
   SELECT @fecha_emision = GETDATE()
   
   DECLARE @stock_actual INT
   SELECT @stock_actual = stock FROM Producto WHERE id_producto = @cod_producto
    
   IF @stock_actual < @cantidad
   BEGIN
      PRINT 'No hay suficiente stock del producto';
      ROLLBACK TRANSACTION
      RETURN
   END
    
   INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_cliente)
   VALUES (@fecha_venta, @total_venta, @cod_usuario, @cod_cliente)
    
   DECLARE @id_venta INT
   SELECT @id_venta = SCOPE_IDENTITY()
    
   INSERT INTO Detalle_Venta (cantidad, id_producto, subtotal, id_venta)
   VALUES (@cantidad, @cod_producto, @total_venta, @id_venta)
    
   UPDATE Producto 
   SET stock = stock - @cantidad
   WHERE id_producto = @cod_producto
    
   COMMIT TRANSACTION
END TRY
BEGIN CATCH
   ROLLBACK TRANSACTION
   PRINT 'Ocurrió un error durante la operación';
   THROW;
END CATCH
END
GO

```

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
3. Cañizares, L. (2008). Bases de datos. Teoría y diseño (2ª ed.). Alfaomega.
4. Salvatierra, H. (2012). Optimización de consultas SQL en bases de datos relacionales. Editorial UOC
5. Microsoft Ignite [En Línea]. Disponible en [Learn/SQL/Índices clúster y no clúster](https://learn.microsoft.com/es-es/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16)
6. Microsoft Ignite [En Línea]. Disponible en [Learn/SQL/Transacciones (Transact-SQL)](https://learn.microsoft.com/es-es/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver16)
