#!/usr/bin/env bash
#
# Este script busca identificar si hubo cambios en la evolucion del COVID19.
# Para ello este programa ejecuta el script 'datosxday.sh'. El script 
# 'datosxday.sh' revisa la ultima entrada en el archivo 'coronavirus.csv'. Si 
# esa entrada cambia con lo que se ha observado al momento entonces reportara 
# que hubo cambios. Se imprimira por pantalla el mensaje:
#
# 'Se presentaron cambios'
#
# y se mostrara al final los cambios observados usando el comando 'diff'.
#
# Author: John Sanabria
# Date: 23-03-2020
#
#LASTREPORT="lastreportcovid.txt"
#NEWREPORT="newreportcovid.txt"
#HOMEDIR="."

. covid.cfg

#
# Si no hay archivo de ultimo reporte, se crea y se termina la ejecucion del
# script
#
if [ ! -f ${LASTREPORT} ]; then
	${HOMEDIR}/datosxday.sh > ${LASTREPORT} && exit 0
fi
${HOMEDIR}/datosxday.sh > ${NEWREPORT}
TEMP1=$(mktemp)
TEMP2=$(mktemp)
TEMP3=$(mktemp)
#
# El script 'datosxday.sh' en su primera linea da la fecha y hora del dato 
# tomado. Eso puede cambiar pero los datos quiza no. Solo se compararan los 
# datos.
#
tail -n +2 ${LASTREPORT} > ${TEMP1}
tail -n +2 ${NEWREPORT} > ${TEMP2}
diferencia=$(diff ${TEMP1} ${TEMP2} | tee ${TEMP3} |  wc -l)
if [ ${diferencia} -eq 0 ]; then
  # No hubo cambios
  rm ${NEWREPORT}
else
  # Hubo cambios y se actualiza el archivo de ultimo reporte, '${LASTREPORT}'
  echo "Se presentaron cambios"
  cat ${TEMP3}
  mv ${NEWREPORT} ${LASTREPORT}
fi
rm ${TEMP1} ${TEMP2} ${TEMP3}
