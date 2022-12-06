# GitDataIdaStatement

El objetivo de este proyecto, es el de realizar un Dashbord Interactivo enfocado en las regiones, los paises y sus respectivas instituciones sociales
que tienen relación con los prestamos y creditos adquiridos con IDA (International Development Association) por medio de una API publica ofrecida por el Banco Mundial.

Para evidenciar el desarrollo del proyecto se realizaron 3 archivos. Un Jupyter que contiene el proceso de llamada, transformación, conexión y subida del dataframe a MYSQL
del contenido del archivo JSON brindado por la API atraves de Python. Se refleja además, el uso de las respectivas librerias para darle mantenimiento a la data tales
como REQUEST, PANDAS y PyMYSQL.

El segundo archivo contiene consultas en lenguaje SQL para la creación de la base datos, procesos de normalización, consultas basicas, manejo constraints, primary keys
y creación de INDEX para volver más eficiente la base de datos y las consultas posteriores que se puedan realizar sobre ella. 

Finalmente, el proceso de data analytics se enfocó en realizar un analisis descriptivo mediante la inmersion y la implementación tecnica de estrategias y metodologias que
permitieron identificar acontecimientos importantes. Lo primero, es que la mayor cantidad de creditos adquiridos en el mundo fueron solicitados en la región oriental
y Africana. También, se halló que en su mayoria ya habían retribuido el credito total o continuaban pagandolo, caso contrario a los paises de Latinoamerica los cuales ninguno
a terminado de pagar el credito y además en su mayoria han dejado de realizarle pagos a la institución. 
