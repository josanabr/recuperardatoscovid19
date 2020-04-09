#!/usr/bin/env bash
#
# Este script toma el archivo de reporte de casos en Colombia, los ordena y 
# prepara una cadena indicando el ranking de las cinco ciudades con mas casos
# reportados.
#
# AUTHOR: John Sanabria - john.sanabria@correounivalle.edu.co
# DATE: 2020-04-08
#
. covid.cfg
if [ ! -f "${REPORTCO}.csv" ]; then
  echo "Archivo de reporte de Colombia no esta disponible"
  exit 1
fi
IFS=$'\n'
COUNT=1
RESPONSESTR=""
for i in $(tail -n +2 ${REPORTCO}.csv  | cut -d ',' -f 3 | sort --ignore-case | uniq -c | sort -rn | tr -s ' ' | head -n 5); do 
  RESPONSESTR="${RESPONSESTR} ${COUNT} ${i:1:${#i}-1} "
  COUNT=$(( COUNT + 1))
done
echo "RANK COVID19 CO ${RESPONSESTR}"
