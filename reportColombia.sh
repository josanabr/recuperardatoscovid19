#!/usr/bin/env bash
#
# Este script asume que datos de Colombia sobre COVID 19 fueron descargados y
# residen en un archivo llamado '${REPORTCO}.csv'.
# De ese archivo se obtiene una informacion similar a la siguiente:
#
#  1634 Casa
#    69 Fallecido
#   262 Hospital
#    83 Hospital UCI
#   174 Recuperado
#
# Esta informacion se almacena en un archivo llamado '${LASTREPORTCO}.last'
#
LOGFILE=$(basename -- "${0}")
. covid.cfg
# https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3
#exec 1>>${LOGFILE}.log 2>&1
if [ ! -f "${REPORTCO}.csv" ]; then
  echo "${REPORTCO}.csv not available"
  exit 2
fi
TMPFILE=$(mktemp)
# Se genera el reporte
cat ${REPORTCO}.csv | tail -n +2 |  cut -d ',' -f 5 | sort --ignore-case | uniq -ic > ${LASTREPORTCO}
if [ -f ${LASTREPORTCO}.last ]; then 
  # El archivo existe se compara con el actual reporte
  diff ${LASTREPORTCO}.last ${LASTREPORTCO} > ${TMPFILE}
  DIFFLINES=$(wc -l ${TMPFILE} | awk '{print $1}')
  if [ ${DIFFLINES} -eq 0 ]; then
    rm ${LASTREPORTCO}
    echo 0
    exit 0
  fi
fi
# El reporte actual sera el ultimo reporte
mv ${LASTREPORTCO} ${LASTREPORTCO}.last
echo 1
exit 1
