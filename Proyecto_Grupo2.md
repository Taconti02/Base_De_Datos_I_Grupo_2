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

**Conceptos Básicos**

Para garantizar la seguridad y la integridad de la base de datos, es crucial manejar adecuadamente los permisos a nivel de usuarios. Los permisos determinan qué acciones pueden realizar los usuarios dentro de la base de datos. 

**Tipos de Permisos**
   - SELECT: Permite leer datos.
   - INSERT: Permite insertar nuevos datos.
   - UPDATE: Permite modificar datos existentes.
   - DELETE: Permite eliminar datos.

**Seguridad a Nivel de Objeto**

Permite definir permisos específicos para tablas, vistas, procedimientos almacenados, etc.

**Implementación de Permisos**

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

**Recomendaciones de Seguridad:**

**Mínimo Privilegio**
- Asignar solo los permisos necesarios para que los usuarios realicen sus tareas. Esto reduce el riesgo de accesos no autorizados o errores accidentales.

**Revisión Periódica**
- Revisar y ajustar permisos regularmente para adaptarse a cambios en roles y responsabilidades. Es importante eliminar los permisos de los usuarios que ya no los necesitan.

**Monitoreo y Auditoría**
- Mantener un registro de las actividades de los usuarios para detectar y prevenir accesos no autorizados. Herramientas de monitoreo y auditoría pueden ayudar a identificar actividades sospechosas o violaciones de seguridad.

**Buenas Prácticas Adicionales**
Uso de Roles Predefinidos:

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

**Implementación de Roles y Usuarios en un Proyecto Real:**

**Planificación de Roles y Permisos:**
   - Analizar las tareas y responsabilidades de cada tipo de usuario.
   - Definir claramente los roles y los permisos necesarios para cada rol.
   - Documentación de Roles y Permisos:
   - Mantener una documentación detallada de todos los roles, permisos y usuarios. Actualizar la documentación regularmente para reflejar cualquier cambio.

**Capacitación y Concienciación**

Capacitar a los usuarios sobre la importancia de la seguridad y las mejores prácticas, fomentando una cultura de seguridad dentro de la organización.

--- 

### Procedimientos y funciones almacenadas
Un procedimiento almacenado en SQL Server es un conjunto de una o más instrucciones Transact-SQL que se almacena asociado a una base de datos. Similar a las estructuras en otros lenguajes de programación, los procedimientos almacenados pueden aceptar parámetros de entrada, devolver múltiples valores en forma de parámetros de salida, realizar operaciones en la base de datos (incluyendo llamadas a otros procedimientos) y retornar un valor de estado que indica al programa si la operación se completó con éxito o si ocurrieron errores, junto con sus causas.
Algunas de las **ventajas** de usar estos procedimientos son:

- **Tráfico de red reducido entre el cliente y el servidor:**
Los comandos se ejecutan en un único lote de código, reduciendo el tráfico de red entre el servidor y el cliente porque solo se envía la solicitud para ejecutar el procedimiento, en lugar de enviar cada comando por separado, haciéndolo más eficiente.

- **Mayor Seguridad:**
Un procedimiento almacenado en SQL Server permite que usuarios y programas accedan a objetos de la base de datos de forma controlada, sin necesitar permisos directos sobre ellos. Con la cláusula EXECUTE AS, los usuarios pueden ejecutar acciones específicas, como truncar una tabla, sin recibir permisos elevados. Esto simplifica la seguridad y protege los objetos.
Además ayudan a evitar ataques de inyección SQL al tratar los parámetros como valores literales, pueden cifrarse para ocultar su código y mantener la seguridad de la lógica interna.

- **Reutilización del código:**
Cualquier operación de base de datos que se repita mucho es ideal para ponerla dentro de un procedimiento almacenado. Así no es necesario escribir el mismo de nuevo, reduciendo inconsistencias y permitiendo que cualquier usuario o aplicación con los permisos necesarios pueda usarlo y ejecutarlo.

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
CREATE PROCEDURE PA_CargarPersona
   @id_persona INT,
   @nombre VARCHAR(50),
   @apellido VARCHAR(50),
   @email VARCHAR(50),
   @telefono VARCHAR(30),
   @dni INT
AS
BEGIN
   INSERT INTO Persona
   VALUES (
      @id_persona,
      @nombre,
      @apellido,
      @email,
      @telefono,
      @dni
   );
   SELECT 
      @id_persona = id_persona,
      @nombre = nombre,
      @apellido = apellido,
      @email = email,
      @telefono = telefono,
      @dni = dni
   FROM Persona;
   SELECT * FROM Persona;
END
GO
```

Existe una diferencia entre procedimientos almacenados y funciones almacenadas en SQL Server. Esta se basa en su propósito, el tipo de valor que devuelven y las restricciones de uso en las consultas.

En el caso de los *Procedimientos Almacenados*, generalmente se utilizan para ejecutar operaciones complejas o secuencias de instrucciones, como modificar datos, insertar, actualizar o eliminar registros. No tienen una restricción en cuanto a la cantidad de valores que pueden devolver, pudiendo retornar múltiples conjuntos de resultados (usando SELECT) o valores de salida (con parámetros OUT). También pueden devolver valores de éxito o error (mediante RETURN). No pueden ser invocados directamente en consultas, sino que son llamados mediante EXEC.

En cambio, las *Funciones Almacenadas* suelen ser utilizadas en consultas para transformar datos o realizar operaciones que devuelven un único valor específico. Este valor es el resultado de la función y debe especificarse mediante un tipo de dato en la definición de la función. A diferencia de los procedimientos, las funciones sí pueden ser utilizadas en instrucciones SELECT o en una cláusula WHERE, permitiendo la transformación directa de datos en consultas. Generalmente, no deberían modificar los datos de la base.

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

#### a. Cómo se realizó el Trabajo Práctico

Se llevó a cabo un análisis de requerimientos para identificar las necesidades específicas del negocio, enfocándose en entidades clave como clientes, empleados, productos y ventas, y estableciendo restricciones fundamentales, como la unicidad de datos en el DNI, teléfono y correo electrónico. 
Diseñamos un modelo conceptual de datos, definiendo las relaciones entre entidades y estableciendo reglas de integridad, y a partir de este modelo, creamos la base de datos en SQL Server, incorporando tablas, relaciones y restricciones alineadas con los requerimientos del negocio.

A continuación, se establecieron roles de acceso (Administrador, Empleado y Gerente) con permisos diferenciados para proteger la integridad de los datos y gestionar el control de acceso. También desarrollamos procedimientos almacenados que optimizan el rendimiento y refuerzan la seguridad, automatizando tareas comunes para una ejecución eficiente. 

En la fase de pruebas, verificamos el correcto funcionamiento del sistema, identificando y corrigiendo errores en los procedimientos y restricciones. Al final, documentamos cada etapa del proceso y los detalles técnicos necesarios para facilitar el mantenimiento y futuras mejoras del sistema. 

#### b. Herramientas y Procedimientos

1. **Herramientas:**

Se utilizó:
- *SQL Server Management Studio* para la implementación y gestión de la base de datos.
- *GitHub* como repositorio de código y documentación, permitiendo el control de versiones y facilitando la colaboración entre los miembros del equipo.
- *WhatsApp* para la comunicación rápida, coordinando tareas y resolviendo dudas en tiempo real entre los miembros del equipo.

3. **Procedimientos de Recolección de Información:**
- *Revisión Bibliográfica* y *Consulta en Internet* para asegurar buenas prácticas en diseño y seguridad.
- *Asesoramiento* con profesores para resolver dudas técnicas.

4. **Dificultades Encontradas:**
- *Configuración de Permisos*: Ajustes para asegurar permisos correctos.
- *Optimización del Rendimiento*: Ajuste de procedimientos para mejorar la eficiencia.
- *Validación de Integridad*: Pruebas para verificar las restricciones sin afectar la inserción de datos.

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama relacional
![diagrama_relacional](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/doc/diagrama_relacional.jpeg)

---

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

---

### Manejo de Permisos: Resultados

Para poder comprobar que se asignaron correctamente los roles y permisos a cada usuario realizaremos algunas pruebas de verificación. Primero, tenemos que ejecutar el Script [SQLQuery_Manejo_Permisos](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/75053d1cd45373eb53c712e67a7acfc8df1db9c7/script/Tema1_Permisos/SQLQuery_Manejo_Permisos.sql), el cual nos permitirá crear los roles y asignar los permisos de SELECT, INSERT o UPDATE sobre ciertas tablas.

A continuación dejamos cada prueba de validación con sus resultados:

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Verificar los roles asignados a los usuarios
SELECT 
    dp.name AS Usuario,
    rp.name AS Rol
FROM 
    sys.database_principals dp
JOIN 
    sys.database_role_members drm ON dp.principal_id = drm.member_principal_id
JOIN 
    sys.database_principals rp ON drm.role_principal_id = rp.principal_id
WHERE 
    dp.type IN ('S', 'U')  
    AND dp.name IN ('Juan', 'Marta', 'Ana'); 
```

Resultado: 

![roles](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/cf40138356295b90d66a1ef8fafa86505ddf47c3/script/Tema1_Permisos/mp1.png)

```sql
-- Una vez verificado el rol de cada usuario podemos ver los permisos asignados
-- Verificamos los permisos de cada usuario sobre los objetos

SELECT 
    rp.name AS Rol, 
    o.name AS Objeto, 
    p.permission_name AS Permiso
FROM 
    sys.database_role_members drm
JOIN 
    sys.database_principals rp ON drm.role_principal_id = rp.principal_id
JOIN 
    sys.database_permissions p ON rp.principal_id = p.grantee_principal_id
JOIN 
    sys.objects o ON p.major_id = o.object_id
WHERE 
    rp.name IN ('Administrador', 'EmpleadoLectura', 'Empleado')
    AND o.name IN ('Persona', 'Venta', 'Detalle_Venta', 'Cliente', 'Producto', 'Usuario');
```

Resultado: 

![permisos](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/cf40138356295b90d66a1ef8fafa86505ddf47c3/script/Tema1_Permisos/mp2.png)

Con estas dos pruebas podemos verificar que todos los usuarios tienen los roles y permisos correspondientes. 

Ahora realizaremos algunas pruebas de acceso simulando la ejecución de operaciones por parte de los usuarios.
Nos conectaremos con un usuario con Rol de administrador usando login admin.

![login](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/a72bd5972ebf9337ec3cd2a0a24ddb7f923d3fe2/script/Tema1_Permisos/mp3.png)

Vamos a realizar un INSERT sobre la tabla Persona

```sql
-- INSERT directo en la tabla Persona
INSERT INTO Persona (nombre, apellido, email, telefono, dni) 
VALUES ('Carlos', 'López', 'carloslopez@gmail.com', '3791234567', 45678901);

-- Verificar que el registro se haya insertado
SELECT * FROM Persona WHERE nombre = 'Carlos' AND apellido = 'López';

-- INSERT usando el procedimiento almacenado sp_InsertarPersona
EXEC sp_InsertarPersona 
    @nombre = 'Claudia', 
    @apellido = 'Jiménez', 
    @email = 'claudia.jimenez@example.com', 
    @telefono = '3792345678', 
    @dni = 23456789;

-- Verificar que el registro se haya insertado
SELECT * FROM Persona WHERE nombre = 'Claudia' AND apellido = 'Jiménez';
```

Resultado: 

![insert](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/a229128f216b5903d2cabc588186c4fa1b4ed16e/script/Tema1_Permisos/mp4.png)

Como este usuario tiene permisos de administrador, puede realizar INSERT directamente en la tabla Persona y también a través del procedimiento almacenado sp_InsertarPersona.

Ahora realizaremos lo mismo pero con un usuario que tenga el Rol de Empleado.

![login](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/ba328a37a81f66394a1c9f4237ecec72e0d4f145/script/Tema1_Permisos/mp5.png)

Primero realizaremos un INSERT directo sobre la tabla Persona.

```sql
INSERT INTO Persona (nombre, apellido, email, telefono, dni) 
VALUES ('Luis', 'Garcia', 'luisgarcia@gmail.com', '3795432109', 12345678);

-- Esto debería producir un error de permiso, ya que este usuario solo tiene permisos de lectura.
```

Resultado: 

![insert](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/0848a4fdbc8da4dac097963ab29075d40150a3fb/script/Tema1_Permisos/mp6.png)

Ahora realizaremos lo mismo pero a través del procedimiento almacenado sp_InsertarPersona.

```sql
EXEC sp_InsertarPersona 
    @nombre = 'Laura', 
    @apellido = 'Ramirez', 
    @email = 'lauraramirez@gmail.com', 
    @telefono = '3794567890', 
    @dni = 11223344;

-- Verificar que el registro se haya insertado
SELECT * FROM Persona WHERE nombre = 'Laura' AND apellido = 'Ramirez';
```

Resultado: 

![insert](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/cf01f12f4cf70bc04e97966a3ff33dd3cc3d75b8/script/Tema1_Permisos/mp7.png)

Dado que este usuario solo tiene permiso de ejecución sobre el procedimiento sp_InsertarPersona, la inserción se realizó correctamente y se registró una nueva persona. Sin embargo, al intentar realizar un INSERT directo en la tabla, la operación fue denegada debido a la falta de permisos necesarios.

Por ultimo vamos a hacer una comparación de comportamiento entre un usuario con permiso de lectura (EmpleadoLectura) y otro que no (Empleado).

Empleado Lectura:

![select](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/66013dd8107edb76be9263f63e22e1135e70019c/script/Tema1_Permisos/mp8.png)

Empleado:

![select](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/66013dd8107edb76be9263f63e22e1135e70019c/script/Tema1_Permisos/mp9.png)

Con esta prueba podemos verificar cómo el acceso controlado mediante roles limita la visibilidad de datos a los usuarios autorizados.

---

### Procedimientos Almacenados: Resultados

Para poder comprobar que los procedimientos almacenados pueden realizar operaciones de inserción, actualización y obtención de datos vamos a tratar de llamarlos dentro del entorno. Primero, tenemos que ejecutar el Script [SQLQuery_Procedimientos_Almacenados](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/0c804e061448e2fb853827d970ab794c1eff5577/script/Tema2_Procedimientos/SQLQuery_Procedimientos_Almacenados.sql), que se encargará crear los procedimientos que nos permitirán a registrar una nueva venta.

A continuación dejamos las pruebas de cada procedimiento con sus resultados:

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Probar el procedimiento RegistrarVenta
-- Declarar variables para almacenar el resultado de la venta, el usuario y el cliente
DECLARE @id_venta INT;
DECLARE @id_usuario INT;
DECLARE @id_cliente INT;

SELECT @id_usuario = id_persona -- Obtener id_usuario basado en el dni
FROM Persona 
WHERE dni = 34567890;

SELECT @id_cliente = id_persona -- Obtener id_cliente basado en el dni
FROM Persona 
WHERE dni = 34567801;

-- Llamar al procedimiento para registrar una venta
EXEC RegistrarVenta 
    @fecha_venta = '2024-11-03', 
    @total_venta = 25.97, 
    @id_usuario = @id_usuario, 
    @id_tipo = 1, 
    @id_cliente = @id_cliente,
    @id_venta = @id_venta OUTPUT;

-- Validar la inserción en la tabla Venta
SELECT * FROM Venta 

-- Comprobar el ID de la venta generada
SELECT @id_venta AS id_venta;

-- Con el mismo id_venta, podemos probar el procedimiento RegistrarDetalleVenta
-- Llamar al procedimiento para registrar un detalle de venta
EXEC RegistrarDetalleVenta 
    @id_venta = @id_venta, 
    @id_producto = 1, 
    @cantidad = 2, 
    @subtotal = 21.98;

EXEC RegistrarDetalleVenta
    @id_venta = @id_venta,       
    @id_producto = 2,    
    @cantidad = 1,       
    @subtotal = 3.99;  

-- Validar la inserción en la tabla Detalle_Venta
SELECT * FROM Detalle_Venta WHERE id_venta = @id_venta;
GO
```

Resultado: 

![venta](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/b011172e1b0dfb832257aa8c81ea9215f6868f09/script/Tema2_Procedimientos/pa1.png)

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Probar el Procedimiento ActualizarStockProducto
-- Verificamos cuánto es el stock actual
SELECT * FROM Producto;

EXEC ActualizarStockProducto 
    @id_producto = 3,  
    @cantidad = 1; -- Restamos 1 producto

-- Verificamos si se actualizó
SELECT * FROM Producto;
```

Resultado: 

![producto](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/b011172e1b0dfb832257aa8c81ea9215f6868f09/script/Tema2_Procedimientos/pa2.png)

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Probar el Procedimiento EliminarVenta y EliminarDetalleVenta
-- Verificar el estado actual
SELECT * FROM Venta WHERE id_venta = 1
SELECT * FROM Detalle_Venta WHERE id_venta = 1

EXEC EliminarVenta @id_venta = 1;
EXEC EliminarDetalleVenta @id_detalle = 1

-- Validar que la venta y sus detalles han sido eliminados
SELECT * FROM Venta WHERE id_venta = 1 -- Debe retornar sin filas
SELECT * FROM Detalle_Venta WHERE id_venta = 1 -- Debe retornar sin filas
GO
```

Resultado: 

![eliminar](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/62b84268ff92bfd6b9afc0d1b6093805b3ae6e12/script/Tema2_Procedimientos/pa3.png)

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Probar la Función TotalVentasPorMes
-- Registrar varias Ventas para realizar esta prueba
DECLARE @id_venta INT;

EXEC RegistrarVenta 
    @fecha_venta = '2024-10-24', 
    @total_venta = 11.30, 
    @id_usuario = 1, 
    @id_tipo = 1, 
    @id_cliente = 2,
    @id_venta = @id_venta OUTPUT;

EXEC RegistrarVenta 
    @fecha_venta = '2024-11-15', 
    @total_venta = 23.75, 
    @id_usuario = 1, 
    @id_tipo = 1, 
    @id_cliente = 2,
    @id_venta = @id_venta OUTPUT;

EXEC RegistrarVenta 
    @fecha_venta = '2024-11-27', 
    @total_venta = 87.20, 
    @id_usuario = 1, 
    @id_tipo = 1, 
    @id_cliente = 2,
    @id_venta = @id_venta OUTPUT;

SELECT * FROM Venta

-- Vamos a contar las ventas en el mes de noviembre de 2024
SELECT dbo.TotalVentasPorMes(11, 2024) AS total_ventas_noviembre;

-- Validar el valor obtenido
SELECT COUNT(*) AS total_ventas FROM Venta WHERE MONTH(fecha_venta) = 11 AND YEAR(fecha_venta) = 2024;
GO
```

![contar](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/acafc1322956ec9bc921b18a7b1b3b9a06d24105/script/Tema2_Procedimientos/pa4.png)

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Prueba de TotalVentasPorCliente para un cliente en un mes y año específicos
DECLARE @total FLOAT;
SET @total = dbo.TotalVentasPorCliente(2, 11, 2024);

-- Mostrar el resultado
PRINT 'Total de ventas para el cliente con ID 1 en Noviembre 2024: ' + CAST(@total AS VARCHAR(50));

-- Prueba de VerificarStockProducto para un producto específico
DECLARE @stock INT;
SET @stock = dbo.VerificarStockProducto(1);

-- Mostrar el resultado
PRINT 'Stock disponible para el producto con ID 1: ' + CAST(@stock AS VARCHAR(50));
```

![contar](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/04e2ceee7b70700b1b83bfd936bca13dfbc945f1/script/Tema2_Procedimientos/pa6.png)

Con estas pruebas podemos verificar que los procedimientos y funciones definidas funcionan correctamente.

Ahora vamos a comparar la eficiencia entre de las operaciones directas y el uso de procedimientos y funciones.

```sql
-- Conectarse a la base de datos
USE base_sistema_ventas;
GO

-- Asegurarnos de que el cliente con id_cliente = 1 existe
IF NOT EXISTS (SELECT 1 FROM Cliente WHERE id_cliente = 1)
BEGIN
    INSERT INTO Cliente (id_cliente) VALUES (1);  -- Aseguramos que el cliente 1 esté en la tabla
END
GO

-- Declarar variables para medir el tiempo
DECLARE @InicioDirecto DATETIME, @FinDirecto DATETIME;
DECLARE @InicioProcedimiento DATETIME, @FinProcedimiento DATETIME;
DECLARE @id_venta INT;

---------------------------------
-- Insertar datos directamente --
---------------------------------
SET @InicioDirecto = GETDATE();

-- Realizar 100 inserts directos en Venta y Detalle_Venta
DECLARE @i INT = 1;
WHILE @i <= 100
BEGIN
    -- Declaramos la variable para total_venta
    DECLARE @totalVenta FLOAT;
    SET @totalVenta = 100.0 + CONVERT(FLOAT, @i);

    -- Insertar directamente en Venta
    INSERT INTO Venta (fecha_venta, total_venta, id_usuario, id_tipo, id_cliente)
    VALUES ('2024-11-12', @totalVenta, 1, 1, 1);

    -- Obtener el ID de la venta recién insertada
    SET @id_venta = SCOPE_IDENTITY();

    -- Insertar directamente en Detalle_Venta
    INSERT INTO Detalle_Venta (id_venta, id_producto, cantidad, subtotal)
    VALUES (@id_venta, 1, 2, 50.0), (@id_venta, 2, 1, 25.0);

    SET @i = @i + 1;
END

SET @FinDirecto = GETDATE();

------------------------------------------------------
-- Insertar datos usando procedimientos almacenados --
------------------------------------------------------
SET @InicioProcedimiento = GETDATE();

-- Realizar 100 inserts usando procedimientos almacenados
SET @i = 1;
WHILE @i <= 100
BEGIN
    -- Declaramos la variable para total_venta
    SET @totalVenta = 100.0 + CONVERT(FLOAT, @i);

    -- Llamar al procedimiento para insertar en Venta
    EXEC RegistrarVenta 
        @fecha_venta = '2024-11-12', 
        @total_venta = @totalVenta, 
        @id_usuario = 1, 
        @id_tipo = 1, 
        @id_cliente = 1,
        @id_venta = @id_venta OUTPUT;

    -- Llamar al procedimiento para insertar en Detalle_Venta
    EXEC RegistrarDetalleVenta 
        @id_venta = @id_venta, 
        @id_producto = 1, 
        @cantidad = 2, 
        @subtotal = 50.0;

    EXEC RegistrarDetalleVenta 
        @id_venta = @id_venta, 
        @id_producto = 2, 
        @cantidad = 1, 
        @subtotal = 25.0;

    SET @i = @i + 1;
END

SET @FinProcedimiento = GETDATE();

----------------------
-- Comparar tiempos --
----------------------
SELECT 
    DATEDIFF(MILLISECOND, @InicioDirecto, @FinDirecto) AS Tiempo_Insert_Directo_MS,
    DATEDIFF(MILLISECOND, @InicioProcedimiento, @FinProcedimiento) AS Tiempo_Procedimientos_MS;
GO
```

![tiempo](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/239ca2b358e946ac1dd4f8543040f7f3d1cb9027/script/Tema2_Procedimientos/pa5.png)

Con estas pruebas podemos concluir que los INSERTS directos son más eficientes en términos de tiempo de ejecución, ya que evitan la sobrecarga de la compilación del procedimiento, el paso de parámetros, el manejo de errores y las transacciones adicionales. Por otro lado, los procedimientos almacenados ofrecen mayor flexibilidad y seguridad, especialmente para tareas complejas que requieren lógica de negocio y manejo de múltiples tablas.

---

### Optimización de consultas a través de índices: Resultados

**Parte 2: Realizar una Búsqueda por Periodo y Registrar el Plan de Ejecución**

Sin índices, ejecutaremos una consulta y registraremos el plan de ejecución y los tiempos de respuesta.

*Plan de ejecución:*

![1OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/1OCTI.png)


*Resultado de tiempo de respuesta:*

![2OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/2OCTI.png)


**Parte 3: Definir un Índice Agrupado sobre la Columna Fecha y Repetir la Consulta**

Eliminamos el índice agrupado existente (el de la clave primaria) y creamos un nuevo índice agrupado en fecha_venta.

*Resultado de tiempo de respuesta:*

![3OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/3OCTI.png)



**Parte 4: Borrar el Índice Creado**

Eliminamos el índice agrupado.

*Indice agrupado eliminado:*

![4OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/4OCTI.png)


**Parte 5: Crear Otro Índice Agrupado Incluyendo las Columnas Seleccionadas y Repetir la Consulta**

Creamos un índice agrupado que incluya columnas adicionales (fecha_venta y id_cliente) y repetimos la consulta.

*Plan de ejecución:*

![5OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/5OCTI.png)

*Resultado de tiempo de respuesta:*

![6OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/6OCTI.png)


**Conclusiones:**

- Consulta sin Índice:
La consulta sin ningún índice requiere un escaneo completo de la tabla (table scan), lo que resulta en un tiempo de respuesta elevado de 8 segundos y un uso intensivo de I/O y CPU. Esto se debe a la necesidad de leer cada fila de la tabla para encontrar las filas que coinciden con el rango de fechas.
- Consulta con Índice Agrupado en fecha_venta:
Al aplicar un índice agrupado en la columna fecha_venta, se observa una mejora significativa en el tiempo de respuesta en 7 segundos. El motor de la base de datos puede acceder rápidamente a las filas que coinciden con el rango de fechas utilizando el índice, reduciendo así la cantidad de datos que necesita escanear.
- Consulta con Índice Agrupado en fecha_venta e id_cliente:
Al aplicar un índice agrupado en fecha_venta e id_cliente, la mejora en el tiempo de respuesta es 7 segundos al igual que índice agrupado en la columna fecha_venta.

### Manejo de transacciones y transacciones anidadas: Resultados

**Parte 1: Transacción Consistente**

Funciono correctamente la transacción consistente.

*Transaccion consistente exitosa:*

![MTTA1](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema4_%20%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/MTTA1.png)


**Parte 2: Provocar un Error y Verificar la Consistencia**

Se produjo el error y se verifica que el manejo de transacciones es efectivo.

*Error mostrando manejo de transacciones exitoso:*

![MTTA2](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema4_%20%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/MTTA2.png)


**Conclusión en base a pruebas realizadas:**

- Transacción Consistente:
En el primer script, si todas las operaciones son exitosas, los cambios se aplican a la base de datos. Si ocurre algún error en cualquier paso, la transacción se revierte, asegurando que ningún cambio parcial se aplique. Esto demuestra la efectividad de las transacciones para mantener la integridad de los datos.
- Transacción con Error Intencional:
En el segundo script, al provocar un error intencional después del primer INSERT, la transacción se revierte completamente. Esto asegura que no se realice ningún cambio en la base de datos, manteniéndola consistente y sin alteraciones parciales. Esta prueba confirma que el manejo de errores dentro de una transacción es efectivo para mantener la consistencia y atomicidad de los datos.

## CAPÍTULO V: CONCLUSIONES

**CONCLUSIONES**

El trabajo ha logrado cumplir los objetivos propuestos, diseñando e implementando una base de datos funcional y segura que satisface las necesidades de un negocio de ventas.

**Objetivo General:**
Se alcanzó el objetivo de desarrollar un sistema de base de datos que permite registrar ventas, gestionar clientes, empleados y productos, y asegurar la integridad de los datos. Esta solución facilita el acceso rápido y seguro a la información clave para una operación organizada y eficiente.

**Objetivos Específicos:**

1. **Modelo de datos**: Se diseñó un modelo que representa fielmente las entidades del negocio (clientes, empleados, productos, ventas), aplicando restricciones de unicidad y longitud para asegurar la integridad de los datos.
   
2. **Implementación en SQL Server**: La base de datos fue creada con las tablas, relaciones y restricciones necesarias, garantizando la precisión de la información.

3. **Gestión de clientes y empleados**: Se permite registrar y administrar datos únicos de clientes y empleados, facilitando su organización.

4. **Registro de ventas**: Se registra cada venta con detalles de cliente, empleado, productos y total de la compra, lo que permite un seguimiento claro de las transacciones.

5. **Gestión de inventario**: La actualización automática del stock tras cada venta asegura un control preciso del inventario.

6. **Seguridad mediante roles y permisos**: La asignación de permisos específicos para Administrador, Empleado y Gerente garantiza que cada usuario acceda solo a la información necesaria, protegiendo los datos del negocio.

7. **Eficiencia con procedimientos almacenados**: Los procedimientos almacenados optimizan tareas recurrentes, mejoran el rendimiento y refuerzan la seguridad.

**Evaluación Final:**
La base de datos resultante es segura, eficiente y cumple con los requerimientos del negocio. Este sistema facilita la gestión de información y usuarios, fortaleciendo las operaciones y contribuyendo al éxito del negocio de ventas.

## BIBLIOGRAFÍA DE CONSULTA

1. Base de Datos 2.2.3 Entidad relación [En Línea] Disponible en [eLibro UNNE](https://elibro.net/es/ereader/unne/121283?page=52 "eLibro UNNE") Pulido Romero, E. Escobar Domínguez 
2. Microsoft Ignite [En Línea] Disponible en [Learn/SQL/Procedimientos Almacenados](https://learn.microsoft.com/es-es/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver16)
3. Cañizares, L. (2008). Bases de datos. Teoría y diseño (2ª ed.). Alfaomega.
4. Salvatierra, H. (2012). Optimización de consultas SQL en bases de datos relacionales. Editorial UOC
5. Microsoft Ignite [En Línea]. Disponible en [Learn/SQL/Índices clúster y no clúster](https://learn.microsoft.com/es-es/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16)
6. Microsoft Ignite [En Línea]. Disponible en [Learn/SQL/Transacciones (Transact-SQL)](https://learn.microsoft.com/es-es/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver16)
7. Gómez Fuentes, M. del C. Bases de datos, pp. 135-140 [En Línea]. Universidad Autónoma Metropolitana, Unidad Cuajimalpa.
