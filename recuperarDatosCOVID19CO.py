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
import io
import json
import os.path
import sys
import subprocess
import unicodedata

#
# Funcion para imprimir por archivo de error standard
#
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

import covid

CSVFILE="%s/%s"%(covid.STORAGEDIR,"coronavirusco.csv")
OUTPUTFILE="%s/%s"%(covid.STORAGEDIR,"coronavirusco.json")

cmd = "$(pwd)/recuperarDatosCOVID19CO.bash %s"%(OUTPUTFILE)
start = timer()
output = subprocess.check_output(cmd, shell = True)
end = timer()
eprint("Tiempo de acceso fue de %f segundos"%(end - start))
with io.open('%s'%(OUTPUTFILE),"r",encoding="utf-8") as f:
	data = json.load(f)
with open(CSVFILE,'w') as f:
	for row in data['data'][0]:
		line = unicodedata.normalize('NFKD',",".join(row)).encode('ASCII', 'ignore').decode("utf-8")
		if row[0] == str(586): # hay un bug en este dato
			lines = line.split(',')[0:9]
			line = ",".join(lines)
			continue
		f.write("%s\n"%(line))
	
