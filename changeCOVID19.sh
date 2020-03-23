#!/usr/bin/env bash
#
# Este script busca identificar si hubo cambios en la evolucion del COVID19
#
# Author: John Sanabria
# Date: 23-03-2020
#
LASTUPDATE="lastreportcovid.txt"
NEWUPDATE="newreportcovid.txt"
HOMEDIR="."

#
# Si no hay archivo de ultimo reporte, se crea y se termina la ejecucion del
# script
#
if [ ! -f ${LASTUPDATE} ]; then
	${HOMEDIR}/datosxday.sh > ${LASTUPDATE} && exit 0
fi
${HOMEDIR}/datosxday.sh > ${NEWUPDATE}
TEMP1=$(mktemp)
TEMP2=$(mktemp)
TEMP3=$(mktemp)
#
# El script 'datosxday.sh' en su primera linea da la fecha y hora del dato 
# tomado. Eso puede cambiar pero los datos quiza no. Solo se compararan los 
# datos.
#
tail -n +2 ${LASTUPDATE} > ${TEMP1}
tail -n +2 ${NEWUPDATE} > ${TEMP2}
diferencia=$(diff ${TEMP1} ${TEMP2} | tee ${TEMP3} |  wc -l)
if [ ${diferencia} -eq 0 ]; then
  # No hubo cambios
  rm ${NEWUPDATE}
else
  # Hubo cambios y se actualiza el archivo de ultimo reporte, '${LASTUPDATE}'
  echo "Se presentaron cambios"
  cat ${TEMP3}
  mv ${NEWUPDATE} ${LASTUPDATE}
fi
rm ${TEMP1} ${TEMP2} ${TEMP3}
