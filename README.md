# Datos del COVID 19

En este repositorio se encuentran dos proyectos. 
Uno que se encarga de recuperar datos del desarrollo del COVID19 alrededor del mundo y otro que monitorea el desarrollo del COVID19 en Colombia.

* [recuperarDatosCOVID19](#recuperardatoscovid19)
* [recuperarDatosCOVID19CO](#recuperardatoscovid19co)
* [Notas para el programador](#notas-para-el-programador)

---

# recuperarDatosCOVID19

Este script en Python permite recuperar datos del sitio web [https://www.worldometers.info/coronavirus/](https://www.worldometers.info/coronavirus/). 
Este sitio mantiene datos actualizados relativos a los contagiados por COVID 19 a nivel mundial. 
Este script toma los datos de esta página y los almacena en un archivo .CSV llamado `coronavirus.csv`.

## Instalacion

Para la instalación, lo primero que se debe hacer es descargar/clonar este repositorio.

```
git clone https://github.com/josanabr/recuperardatoscovid19.git
```

Una vez descargado este repositorio se creará un directorio llamado `recuperardatoscovid19`. 
Ingresar a este repositorio.
Ejecutar el siguiente comando:

```
virtualenv venv
source venv/bin/activate
```

Una vez se prepara el entorno para la ejecución del script, se hace la instalación de las dependencias con el siguiente comando:

```
pip3 install -r requirements.txt
```

## Ejecucion

Para ejecutar el script se invoca el siguiente comando:

```
python3 recuperarDatosCOVID19.py
```

La ejecución de esta aplicación almacenará los datos en un archivo llamado `coronavirus.csv`.
Si el archivo no existe, creará uno con el siguiente encabezado:

```
date time,country,tcases,ncases,tdeaths,ndeaths,trecovered,acases,scritical,casesxmillion,1stcase
```

Si el archivo existe entonces anexará los nuevos datos leidos.

## Recoleccion periodica de datos

Si usted desea que el script `recuperarDatosCOVID19.py` se ejecute periódicamente, llevar a cabo los siguientes pasos:

* Crear un archivo llamado `covid-recuperardatoscovid19.sh` en el directorio `${HOME}`. 
* Este archivo debe tener las siguientes líneas:
```
#!/usr/bin/env bash
CWD=$(pwd)
cd ${HOME}/recuperardatoscovid19
source venv/bin/activate
python3 recuperarDatosCOVID19.py && echo $(date) > recuperardatoscovid19.txt
cd ${CWD}
```
* Ejecute el comando `cat ${HOME}/covid-recuperardatoscovid19.sh`. Le deberá mostrar las líneas del ítem anterior. Cambie los permisos de este archivo de la siguiente manera `chmod +x ${HOME}/covid-recuperardatoscovid19.sh`. 
* Adicione esta tarea para que se ejecute de forma periódica con el comando `cron`. Edite el archivo de configuracion de tareas de `cron`
```
crontab -e
```
* Al final del archivo adicione las siguientes líneas:
```
*/15 * * * * /home/pi/covid-recuperardatoscovid19.sh
```
* **IMPORTANTE** Cambie el nombre del usuario `pi` por el nombre de su usuario. Guarde los cambios y salga de la edición del archivo.

Lo que acaba de hacer es programar la ejecución del script `${HOME}/covid-recuperardatoscovid19.sh` cada 15 minutos. 
Los datos colectados quedarán en el directorio `${HOME}/recuperardatoscovid19/coronavirus.csv`

---

# recuperarDatosCOVID19CO

Este parte del proyecto consta de dos archivos. 
El archivo `recuperarDatosCOVID19CO.py` y el archivo `recuperarDatosCOVID19CO.bash`.
El archivo `.py` invoca la ejecución del archivo `.bash`. 
El archivo `.bash` hace una conexión HTTP usando el comando `curl` a un **frame** dentro de esta página web [https://www.ins.gov.co/Noticias/Paginas/Coronavirus.aspx](https://www.ins.gov.co/Noticias/Paginas/Coronavirus.aspx).

Para ejecutar este script y traer los datos mas recientes se corre el siguiente comando:

```
python3 recuperardatosCOVID19CO.py
```

Este archivo por defecto genera un archivo llamado `coronavirusco.csv`.

Este archivo se puede procesar a través de un Jupyter notebook llamado [`COVID19CO.ipynb`](COVID19CO.ipynb).
Para poder interactuar con los datos en `coronavirusco.csv` se sugiere ejecutar el siguiente comando:

```
docker run -d --name jupyter -p 8888:8888 -v $(pwd):/opt playniuniu/jupyter-pandas
```

Una vez lanzado el contenedor se puede visitar el sitio [http://localhost:8888](http://localhost:8888).
Cargar el notebook  `COVID19CO.ipynb`. 

---

# Notas para el programador

Se ha creado un archivo llamado [`datoxday.sh`](datosxday.sh) en el cual muestra como ha sido el comportamiento de un país respecto a su evolución con respecto al COVID 19.
Esta es una salida posible de la ejecución del comando:

```
Pais Colombia - datos tomados 2020-03-23 11:00:03.239289
	 Numero total de casos (tcases):  235
	 Numero total de casos activos (acases):  229
	 Numero total de nuevos casos (ncases):  4
	 Numero total de recuperados (trecovered):  3
	 Numero total de fallecidos (tdeaths):  3
T. casos activos + T. recuperados + T. fallecidos = T. de casos
```

---

Se ha creado un archivo llamado [`changeCOVID19.sh`](changeCOVID19.sh) y el cual determina si ha habido cambios en la evolucion del COVID19. 
Si hay cambios, presenta el siguiente mensaje por pantalla:

```
Se presentaron cambios
```

---

# Notas para el programador

En el archivo [`recuperarDatosCOVID19.py`](recuperarDatosCOVID19.py) se encuentran los campos de los que se lleva registro.
