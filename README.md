# Platzi-Students-database

A continuación se presenta una Bases de datos de un sistema de alumnos, profesores y carreras, en cada uno de los scripts se presentan querys de manipulación de la DB.

<details>
<summary>Instalación de la DB </summary>

1️⃣ Instalar PostgreSQL y pgAdmin
Archivos de datos SQL: descarga archivo platzi-carreras.sql y archivo platzi-alumnos.sql.

Una vez tienes instalado PostgreSQL y pgAdmin vamos a crear la estructura de datos que veremos a lo largo del curso.

Para hacerlo abre pgAdmin (normalmente está en la dirección: http://127.0.0.1:63435/browser/), y expande el panel correspondiente a tu base de datos, en mi caso la he nombrado “prueba”.

En la sección esquemas da click secundario y selecciona la opción Create > Schema…

Al seleccionar la opción abrirá un cuadro de diálogo en donde debes escribir el nombre del esquema, en este caso será “platzi”. Si eliges un nombre distinto, asegúrate de seguir los ejemplos en el curso con el nombre elegido; por ejemplo si en el curso mencionamos la sentencia:

SELECT * FROM platzi.alumnos
Sustituye platzi por el nombre que elegiste.

Finalmente selecciona tu usuario de postgres en el campo Owner, esto es para que asigne todos los permisos del nuevo esquema a tu usuario.

Revisa que tu esquema se haya generado de manera correcta recargando la página y expandiendo el panel Schemas en tu base de datos.

Dirígete al menú superior y selecciona el menú Tools > Query Tool.

Esto desplegará la herramienta en la ventana principal. Da click en el botón “Open File” ilustrado por un icono de folder abierto.

Busca en tus archivos y selecciona el archivo platzi.alumnos.sql que descargaste de este curso, da click en el botón “Select”.

Esto abrirá el código SQL que deberás ejecutar dando click en el botón ”Execute/Refresh” con el icono play.

Al terminar debes ver un aviso similar al siguiente:

Ahora repetiremos el proceso para la tabla platzi.carreras. Dirígete nuevamente al botón “Open File” y da click en él.

Encuentra y selecciona el archivo platzi.carreras.sql y da click en el botón “Select”.

Una vez abierto el archivo corre el script dando click en el botón “Execute/Refresh”

Debes ver nuevamente un aviso como el siguiente:
</details>