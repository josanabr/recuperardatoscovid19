#!/usr/bin/env bash
. covid.cfg
if [ ! -f "${REPORTCO}.csv" ]; then
  echo "${REPORTCO}.csv is not available"
  exit 1
fi
RESPSTR=""
OUTPUT=$(./reportColombia.sh)
if [ ! "${OUTPUT}" == "1" ]; then
  exit 0
fi
TOTAL=$(tail -n 1 ${REPORTCO}.csv | cut -d ',' -f 1)
RESPSTR="Informe COVID19 CO Total: ${TOTAL}"
IFS=$'\n'
STRDEAD="Fallecidos "
STRRECOVERED="Recuperados "
for line in $(cat ${LASTREPORTCO}.last); do
  LUGAR=$(echo ${line} | awk '{for (i=2; i<=NF; i++) print $i}' | tr '[:upper:]' '[:lower:]')
  NUMBER=$(echo ${line} | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
  if [ "${LUGAR}" == "fallecido" ]; then
    STRDEAD=" \b. ${STRDEAD} ${NUMBER}."
  elif [ "${LUGAR}" == "recuperado" ]; then
    STRRECOVERED=" ${STRRECOVERED} ${NUMBER}."
  else
    RESPSTR="${RESPSTR}, en ${LUGAR} ${NUMBER}"
  fi
done
echo -e ${RESPSTR}${STRDEAD}${STRRECOVERED} |  ${TWITCLICOHOME}/mytweetstdin.sh

