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
if [ ! -f "${STORAGEDIR}/${REPORTCO}.csv" ]; then
  echo "Archivo de reporte de Colombia no esta disponible"
  exit 1
fi
IFS=$'\n'
COUNT=1
RESPONSESTR=""
TOPE=5
TOTAL=$( tail -n 1 ${STORAGEDIR}/${REPORTCO}.csv | cut -d ',' -f 1 )
TOTALREPORTADOS=0
for i in $(tail -n +2 ${STORAGEDIR}/${REPORTCO}.csv  | cut -d ',' -f 3 | sort --ignore-case | uniq -c | sort -rn | tr -s ' ' | head -n ${TOPE}); do 
  REPORTADOS=$(echo ${i:0:${#i}} | awk '{print $1}')
  TOTALREPORTADOS=$(( ${TOTALREPORTADOS} + ${REPORTADOS} ))
  CIUDAD=$(echo ${i:0:${#i}} | awk '{print $2}')
  RESPONSESTR="${RESPONSESTR} (${COUNT}) ${CIUDAD} ${REPORTADOS}($(( ${REPORTADOS} * 100 / ${TOTAL}))%)"
  if [ ${COUNT} -ne ${TOPE} ]; then
    RESPONSESTR="${RESPONSESTR};"
  fi
  COUNT=$(( COUNT + 1))
done
echo "RANK ${TOPE} COVID19${RESPONSESTR}. Las ${TOPE} ciudades reportan el $((${TOTALREPORTADOS}*100/${TOTAL}))% del total de pacientes en CO."
