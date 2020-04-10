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
for line in $(cat ${LASTREPORTCO}.last); do
  LUGAR=$(echo ${line} | awk '{print $2}' | tr '[:upper:]' '[:lower:]')
  NUMBER=$(echo ${line} | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
  if [ "${LUGAR}" == "fallecido" ]; then
    RESPSTR="${RESPSTR} fallecidos ${NUMBER}"
  elif [ "${LUGAR}" == "recuperado" ]; then
    RESPSTR="${RESPSTR} recuperados ${NUMBER}"
  else
    RESPSTR="${RESPSTR} en ${LUGAR} ${NUMBER}"
  fi
done
echo ${RESPSTR} |  ${TWITCLICOHOME}/mytweetstdin.sh
