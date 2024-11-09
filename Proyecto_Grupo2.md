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

---
### Optimización de consultas a través de índices


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

