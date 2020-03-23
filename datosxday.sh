#!/usr/bin/env bash
#
# Este script brinda datos puntuales de interes respecto al desarrollo del 
# COVID 19 para un pais en particular
#
# Author: John Sanabria
# Date: 23-03-2020
#
# Los datos separados por coma que se encuentran son
#
# Labels meaning:
# 1- date time
# 2- country
# 3- tcases: Total cases
# 4- ncases: New cases
# 5- tdeaths: Total deaths
# 6- ndeaths: New deaths
# 7- trecovered: Total recovered
# 8- acases: Active cases
# 9- scritical: Serious critical
# 10- casesxmillion: Total cases / 1M population
#
maxcasos() {
  cat ${TMPFILE} | cut -d ',' -f 1,6 | uniq
}

#FILENAME="coronavirus.csv"
#COUNTRY="Colombia"
. covid.cfg
TMPFILE=$(mktemp)
if [ ! "x${1}" == "x" ]; then
  COUNTRY="${1}"
fi
grep ${COUNTRY} ${FILENAME} > ${TMPFILE}
LASTREPO=$(cat ${TMPFILE} | tail -n 1)
DATETIME=$( echo ${LASTREPO} | cut -d ',' -f 1)
TCASES=$( echo ${LASTREPO} | cut -d ',' -f 3)
NCASES=$( echo ${LASTREPO} | cut -d ',' -f 4)
ACASES=$( echo ${LASTREPO} | cut -d ',' -f 8)
TDEATHS=$( echo ${LASTREPO} | cut -d ',' -f 5)
TRECOVERED=$( echo ${LASTREPO} | cut -d ',' -f 7)
echo "Pais ${COUNTRY} - datos tomados ${DATETIME}"
echo -e "\t Numero total de casos (tcases): " ${TCASES}
echo -e "\t Numero total de casos activos (acases): " ${ACASES}
echo -e "\t Numero total de nuevos casos (ncases): " ${NCASES}
echo -e "\t Numero total de recuperados (trecovered): " ${TRECOVERED}
echo -e "\t Numero total de fallecidos (tdeaths): " ${TDEATHS}
echo "T. casos activos + T. recuperados + T. fallecidos = T. de casos"
rm ${TMPFILE}
