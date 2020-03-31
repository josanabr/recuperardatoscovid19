#!/usr/bin/env python
#
# Author: John Sanabria
# Date: 21-03-2020
#
# Modified
#
# 28-03-2020	Se adiciono un nuevo campo indicando cuando se registro el 
#          	primer caso de COVID-19 en cada pais
# ---
#
from __future__ import print_function
from os import path
from timeit import default_timer as timer
import datetime
import json
import os.path
import sys
import subprocess
import unicodedata

MAXFIELDS=10 # Realmente son 11 campos pero se cuentan solo hasta el 10
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
	return 0


CSVFILE="coronavirusco.csv"
OUTPUTFILE="coronavirusco.json"
cmd = "$(pwd)/recuperarDatosCOVID19CO.bash %s"%(OUTPUTFILE)
start = timer()
output = subprocess.check_output(cmd, shell = True)
end = timer()
eprint("Tiempo de acceso fue de %f segundos"%(end - start))
with open('%s/%s'%(os.getcwd(),OUTPUTFILE)) as f:
	data = json.load(f)
#print(data['data'][0])
with open(CSVFILE,'w') as f:
	for row in data['data'][0]:
		line = unicodedata.normalize('NFKD',",".join(row)).encode('ASCII', 'ignore').decode("utf-8")
		if row[0] == str(586): # hay un bug en este dato
			lines = line.split(',')[0:9]
			line = ",".join(lines)
			continue
		f.write("%s\n"%(line))
	
