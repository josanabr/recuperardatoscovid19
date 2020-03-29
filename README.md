# Datos del COVID 19

Este script en Python permite recuperar datos del sitio web [https://www.worldometers.info/coronavirus/](https://www.worldometers.info/coronavirus/). 
Este sitio mantiene datos actualizados relativos a los contagiados por COVID 19 a nivel mundial. 
Este script toma los datos de esta página y los almacena en un archivo .CSV llamado `coronavirus.csv`.

# Instalacion

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

# Ejecucion

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

# Recoleccion periodica de datos

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

Lo que acaba de hacer es programar la ejecución del script `${HOME}/covid-recuperardatoscovid19.sh` cada 15 minutos. 
Los datos colectados quedarán en el directorio `${HOME}/recuperardatoscovid19/coronavirus.csv`

---

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
