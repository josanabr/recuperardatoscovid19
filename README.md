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
