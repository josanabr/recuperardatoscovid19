#!/usr/bin/env python
#
# Author: John Sanabria
# Date: 21-03-2020
#
# Modified
#
# 28-03-2020	Se adiciono un nuevo campo indicando cuando se registro el 
#          	primer caso de COVID-19 en cada pais
# 04-04-2020    Eliminaron un campo llamado, First Case, pero adicionaron
#               dos llamados: "Total Tests", "Tests/ 1M pop"
# ---
#
from __future__ import print_function
from bs4 import BeautifulSoup
from os import path
from timeit import default_timer as timer
import datetime
import logging
import os.path
import pprint
import requests
import shutil
import sys
import tempfile

MAXFIELDS=11 # Realmente son 12 campos pero se cuentan solo hasta el 11
#
# Funcion para imprimir por archivo de error standard
#
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

#
# Funcion que convierte una cadena de caracteres a numero
#
def num(s):
    try:
        return int(s)
    except ValueError:
        return float(s)

#
# Esta funcion toma una fila (tr) de la pagina
# "https://www.worldometers.info/coronavirus/" de la tabla cuyo 'id' es
# "main_table_countries_today"
# 
def trelement2dict(keys, tr):
	counter = 0
	tdelements = tr.find_all("td")
	result = {}
	# Esta variable almacenara la cadena con valores para el CSV 
	# Fecha
	strrow = "%s,"%str(CDATETIME)
	for tdelement in tdelements:
		#print("x %s"%tdelement.text)
		if tdelement.text == "Total:": # Se ignora el 'Total'
			return None, None
		if counter == 0: # El primer valor
			if counter == 0:
				cadenaascii = tdelement.text.replace("\n", "")
			cadenaascii = cadenaascii.encode("ascii","ignore")
			result[keys[counter]] = str(cadenaascii)
			if counter == MAXFIELDS:
				strrow = strrow + ",%s"%str(cadenaascii)
			else:
				strrow = strrow + str(cadenaascii)
		else: # Se remueven espacios extra, el simbolo '+' y ','
			value = tdelement.text.replace(" ", "").strip("+").replace(",","")
			if value != "": # si no esta vacio es un numero
				value = num(value)
			result[keys[counter]] = value
			strrow = strrow + ",%s"%(value)
		counter = counter + 1 # se usa para indexar el arreglo 'keys'
	if strrow == "%s,"%str(CDATETIME): # no hubo datos 
		return None, None
	return result, strrow
	
#
#
# MAIN
#
#

URL = "https://www.worldometers.info/coronavirus/"
CSVFILE = "coronavirus.csv"
LASTREPORT = "coronavirus.csv.last"
TEMPORARYFILE = "temp.coronavirus.temp"
CDATETIME = datetime.datetime.now()

logging.basicConfig(level=logging.DEBUG,
		filename = 'coronavirus.log',
		filemode = 'a',
		format = '%(asctime)s - %(levelname)s - %(message)s')
start = timer()
page = requests.get(URL)
end = timer()
eprint("Tiempo de acceso a [%s] fue %f segundos"%(URL,end - start))
start = timer()
soup = BeautifulSoup(page.content, 'html.parser')
end = timer()
eprint("Tiempo de parsing fue %f segundos"%(end - start))
#
# Tomar los datos del sitio web
#
results = soup.find(id="main_table_countries_today"); # print(results.prettify)
#
# Labels meaning:
# - country
# - tcases: Total cases
# - ncases: New cases
# - tdeaths: Total deaths
# - ndeaths: New deaths
# - trecovered: Total recovered
# - acases: Active cases
# - scritical: Serious critical
# - casesxmillion: Total cases / 1M population
# - deathsxmillion: Total deaths / 1M population
# - ttests: Total Tests
# - testsxmillion: Tests / 1M population 
#
labels = [ "date time","country", "tcases", "ncases", "tdeaths", "ndeaths", "trecovered", "acases", "scritical", "casesxmillion", "deathsxmillion", "ttests", "testsxmillion" ]
#
# Si el archivo no existe, se crea uno con encabezado. Las etiquetas estan
# definidas en la variable 'labels' 
# 
#
if not path.exists(CSVFILE):
	with open(CSVFILE,'w') as f:
		f.write("%s\n"%(",".join(labels)))
#
# En la tabla 'main_table_countries_today' se recuperan todas las filas, 'tr'
# Estas filas se almacenan en un archivo temporal
#
elements = results.find_all("tr")
f = open(TEMPORARYFILE,"w")
for jobelement in elements:
	dictio,strrow = trelement2dict(labels, jobelement)
	if strrow == None:
		continue
	f.write("%s\n"%strrow)
f.close()
#
# Se comparan los datos recien leidos con los datos leidos en el ultimo reporte
# Si no existe el archivo de ultimo reporte entonces todos los datos recien
# leidos se insertan en el CSVFILE
#
f = open(TEMPORARYFILE,"r")
csvfile = open(CSVFILE,"a")
if not path.exists(LASTREPORT): 
	flr = open(LASTREPORT,"w")
	for x in f:
		csvfile.write(x)
		flr.write(x)
	flr.close()
else:
	flr = open(LASTREPORT, "r")
	for x in f: # 'x' datos recien leidos
		found = False
		for y in flr: # 'y' datos del ultimo reporte
			recent = x.split(",")[1:]
			lr = y.split(",")[1:] # lr: LastReport
			if recent[0] == lr[0]: #Encuentro el pais, recent y last
				found = True
				if ",".join(recent) != ",".join(lr): # diferent
					logging.debug("RECENT: %s BEFORE: %s"%(x[:-1],y[:-1]))
					csvfile.write(x) #diferences are written
				break
		if not found:
			logging.debug("PRIMERA ENTRADA: %s"%(x[:-1]))
			csvfile.write(x)
		flr.seek(0) 
	flr.close()
csvfile.close()
f.close()
#
# TEMPORARYFILE contains recent data. LASTREPORT contains prior data. Then,
# recent data now becomes last report
shutil.move(TEMPORARYFILE, LASTREPORT) # Temporary fil
