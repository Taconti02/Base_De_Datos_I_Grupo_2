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

Para garantizar la seguridad y la integridad de la base de datos, es crucial manejar adecuadamente los permisos a nivel de usuarios. Los permisos determinan qué acciones pueden realizar los usuarios dentro de la base de datos. A continuación, se describen los conceptos fundamentales:

**Roles de Usuarios**
   - Administrador: Tiene todos los permisos y puede gestionar otros usuarios.
   - Empleado: Permisos para registrar y consultar ventas.
   - Gerente: Permisos para consultar sus datos personales y el historial de compras.

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

Ejemplo Completo de Implementación:

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

Existe una diferencia entre procedimientos almacenados y funciones almacenadas en SQL Server, esta se basa en su propósito, el tipo de valor que devuelven y las restricciones de uso en las consultas.


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

Para poder comprobar que se asignaron correctamente los roles y permisos a cada usuario realizaremos algunas pruebas de verificación. Primero, tenemos que ejecutar el Script [SQLQuery_Manejo_Permisos](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/b974b56e9f5de60854b75f5b68535f3730426a7e/script/Tema1_Permisos/SQLQuery_Manejo_Permisos.sql), el cual nos permitirá crear los roles y asignar los permisos de SELECT, INSERT o UPDATE sobre ciertas tablas.

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

![roles](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/54c6764f611a53bd614f1977c89003bc008df28b/script/Tema1_Permisos/mp1.png)

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
    rp.name IN ('Administrador', 'Empleado', 'Gerente')
    AND o.name IN ('Persona', 'Venta', 'Detalle_Venta', 'Cliente', 'Producto', 'Usuario');
```

Resultado: 

![permisos](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/54c6764f611a53bd614f1977c89003bc008df28b/script/Tema1_Permisos/mp2.png)

Con estas dos pruebas podemos verificar que todos los usuarios tienen los roles y permisos correspondientes. 

Ahora realizaremos algunas pruebas de acceso simulando la ejecución de operaciones por parte de los usuarios.
Nos conectaremos con un usuario administrador usando login admin.

![login]()



```sql
-- Un administrador debería:
-- Poder realizar una consulta SELECT en la tabla Persona
-- Poder realizar un INSERT directo en la tabla Persona
-- Poder modificar un registro existente en la tabla Persona
-- Poder eliminar un registro en la tabla Persona



```

![insert]()

---

### Procedimientos Almacenados: Resultados

Para poder comprobar que los procedimientos almacenados pueden realizar operaciones de inserción, actualización y obtención de datos vamos a tratar de llamarlos dentro del entorno. Primero, tenemos que ejecutar el Script [SQLQuery_Procedimientos_Almacenados](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/c579682592167690616ab304171483088f5dffbd/script/Tema2_Procedimientos/SQLQuery_Procedimientos_Almacenados.sql), que se encargará crear los procedimientos que nos permitirán a registrar una nueva venta.

A continuación dejamos las pruebas de cada procedimiento con sus resultados:

```sql
-- Conectarse a la base de datos `base_sistema_ventas`
USE base_sistema_ventas;
GO

-- Probar el procedimiento RegistrarVenta
DECLARE @id_venta INT;
DECLARE @id_usuario INT;
DECLARE @id_cliente INT;

SELECT @id_usuario = id_persona -- Obtener id_usuario basado en el dni
FROM Persona 
WHERE dni = 34567890;

SELECT @id_cliente = id_persona -- Obtener id_cliente basado en el dni
FROM Persona 
WHERE dni = 45678901;

EXEC RegistrarVenta -- Llamar al procedimiento Registrando la venta
    @fecha_venta = '2024-11-03', 
    @total_venta = 25.97, 
    @id_usuario = @id_usuario, 
    @id_tipo = 1, 
    @id_cliente = @id_cliente,
	@id_venta = @id_venta OUTPUT;

SELECT * FROM Venta; -- Verificamos la inserción

-- Luego tenemos que obtener el id_venta de la venta recién registrada 
SELECT @id_venta AS id_venta;

-- Conseguido el id_venta, podemos probar el procedimiento RegistrarDetalleVenta
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

SELECT * FROM Detalle_Venta; -- Verificamos la inserción
```

Resultado: 

![venta](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/b011172e1b0dfb832257aa8c81ea9215f6868f09/script/Tema2_Procedimientos/pa1.png)

```sql
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

Con estas dos pruebas podemos verificar que los procedimientos definidos funcionan correctamente.

---

### Optimización de consultas a través de índices: Resultados

**Parte 2: Realizar una Búsqueda por Periodo y Registrar el Plan de Ejecución**
Sin índices, ejecutaremos una consulta y registraremos el plan de ejecución y los tiempos de respuesta.
![1OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/1OCTI.png)

*1OCTI*

![2OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/2OCTI.png)

*2OCTI*

Parte 3: Definir un Índice Agrupado sobre la Columna Fecha y Repetir la Consulta
Eliminamos el índice agrupado existente (el de la clave primaria) y creamos un nuevo índice agrupado en fecha_venta.

![3OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/3OCTI.png)

*3OCTI*

Parte 4: Borrar el Índice Creado
Eliminamos el índice agrupado.

![4OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/4OCTI.png)

*4OCTI*


Parte 5: Crear Otro Índice Agrupado Incluyendo las Columnas Seleccionadas y Repetir la Consulta
Creamos un índice agrupado que incluya columnas adicionales (fecha_venta y id_cliente) y repetimos la consulta.

![5OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/5OCTI.png)

*5OCTI*

![6OCTI](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema3_Optimizaci%C3%B3n%20de%20Consultas%20a%20Trav%C3%A9s%20de%20%C3%8Dndices/6OCTI.png)

*6OCTI*


Conclusiones:
-Consulta sin Índice:
La consulta sin ningún índice requiere un escaneo completo de la tabla (table scan), lo que resulta en un tiempo de respuesta elevado de 8 segundos y un uso intensivo de I/O y CPU. Esto se debe a la necesidad de leer cada fila de la tabla para encontrar las filas que coinciden con el rango de fechas.
-Consulta con Índice Agrupado en fecha_venta:
Al aplicar un índice agrupado en la columna fecha_venta, se observa una mejora significativa en el tiempo de respuesta en 7 segundos. El motor de la base de datos puede acceder rápidamente a las filas que coinciden con el rango de fechas utilizando el índice, reduciendo así la cantidad de datos que necesita escanear.
-Consulta con Índice Agrupado en fecha_venta e id_cliente:
Al aplicar un índice agrupado en fecha_venta e id_cliente, la mejora en el tiempo de respuesta es 7 segundos al igual que índice agrupado en la columna fecha_venta.



### Manejo de transacciones y transacciones anidadas: Resultados


Parte 1: Transacción Consistente
Funciono correctamente la transacción consistente

![MTTA1]
(https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema4_%20%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/MTTA1.png)
*MTTA1*

Parte 2: Provocar un Error y Verificar la Consistencia
Se produjo el error y se verifica que el manejo de transacciones es efectivo.

![MTTA2]
(https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/script/Tema4_%20%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/MTTA2.png)
*MTTA2*


Conclusión en base a pruebas realizadas:
-Transacción Consistente:
En el primer script, si todas las operaciones son exitosas, los cambios se aplican a la base de datos. Si ocurre algún error en cualquier paso, la transacción se revierte, asegurando que ningún cambio parcial se aplique. Esto demuestra la efectividad de las transacciones para mantener la integridad de los datos.
-Transacción con Error Intencional:
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
