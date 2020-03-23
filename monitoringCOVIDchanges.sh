#!/usr/bin/env bash
#
# Este script invocara al script 'changeCOVID19.sh'. Si el script arroja un
# cambio entonces se invocara al script '${HOME}/twoitclico/mytweeterstdin.sh'
# para que envie un tweet indicando el nuevo comportamiento observador y otro
# tweet con los cambios.
#
# Author: John Sanabria
# Date: 2020-03-23
#
#TWITCLICOHOME=${HOME}/twitclico
#LASTREPORT="lastreportcovid.txt"
. covid.cfg
CWD=$(pwd)
TEMP1=$(mktemp)
${CWD}/changeCOVID19.sh > ${TEMP1}
echo "@josanabr" >> ${TEMP1}
if [ $(wc -l ${TEMP1}) -ne 0 ]; then
  if [ -f ${LASTREPORT} ]; then 
    cat ${LASTREPORT} | tail -n +2 | head -n -1 | tr -d '\t' | wc -c | ${TWITCLICO}/mytweetstdin.sh
  fi
  cat ${TEMP1} | ${TWITCLICO}/mytweetstdin.sh
fi
rm ${TEMP1}
cd ${CWD}
