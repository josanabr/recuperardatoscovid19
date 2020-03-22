#!/usr/bin/env python
#
# Author: John Sanabria
# Date: 21-03-2020
#
from __future__ import print_function
from bs4 import BeautifulSoup
from os import path
from timeit import default_timer as timer
import datetime
import os.path
import pprint
import requests
import sys

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
			return None
		if counter == 0: # El primer valor es una cadena de caracteres
			result[keys[0]] = tdelement.text
			strrow = strrow + tdelement.text
		else: # Se remueven espacios extra, el simbolo '+' y ','
			value = tdelement.text.replace(" ", "").strip("+").replace(",","")
			if value != "": # si no esta vacio es un numero
				value = num(value)
			result[keys[counter]] = value
			strrow = strrow + ",%s"%(value)
		counter = counter + 1 # se usa para indexar el arreglo 'keys'
	if strrow == "%s,"%str(CDATETIME): # no hubo datos 
		return result
	with open(CSVFILE,'a',newline='') as f: # se almacenan los datos
		f.write("%s\n"%strrow.encode('utf8'))
	return result
	

URL = "https://www.worldometers.info/coronavirus/"
CSVFILE = "coronavirus.csv"
CDATETIME = datetime.datetime.now()

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
# country
# tcases: Total cases
# ncases: New cases
# tdeaths: Total deaths
# ndeaths: New deaths
# trecovered: Total recovered
# acases: Active cases
# scritical: Serious critical
# casesxmillion: Total cases / 1M population
#
labels = [ "date time","country", "tcases", "ncases", "tdeaths", "ndeaths", "trecovered", "acases", "scritical", "casesxmillion" ]
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
#
elements = results.find_all("tr")
for jobelement in elements:
	dictio = trelement2dict(labels, jobelement)
	print(dictio)
	#print(dictio)
