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

### Procedimientos y funciones almacenadas

### Optimización de consultas a través de índices

### Majero de transacciones y transacciones anidadas

## CAPÍTULO III: METODOLOGÍA SEGUIDA

## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama relacional
![diagrama_relacional](https://github.com/Taconti02/Base_De_Datos_I_Grupo_2/blob/main/doc/diagrama_relacional.jpeg)


### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

## CAPÍTULO V: CONCLUSIONES

## BIBLIOGRAFÍA DE CONSULTA

 1. Base de Datos 2.2.3 Entidad relación [En Línea] Disponible en [eLibro UNNE](https://elibro.net/es/ereader/unne/121283?page=52 "eLibro UNNE") Pulido Romero, E. Escobar Domínguez 


