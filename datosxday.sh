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
# 11- 1stcase: First case
#
maxcasos() {
  cat ${TMPFILE} | cut -d ',' -f 1,6 | uniq
}
#
# Esta funcion toma una cadena e identifica si un campo dado tiene un valor
# o no. Si no tiene valor devolvera la cadena 'NaN'. De otra forma, devolvera
# el valor encontrado
#
obtvalor() {
 lastrepo="${1}"
 campo="${2}"
 valor=$( echo "${lastrepo}" | cut -d ',' -f ${campo} )
 if [ "${valor}" == "" ]; then
   resultado="[NaN]"
 else
   resultado="[${valor}]"
 fi
}
#
# Cargando variables del script
#
. covid.cfg
#
# MAIN
#
TMPFILE=$(mktemp)
if [ ! "x${1}" == "x" ]; then
  COUNTRY="${1}"
fi
grep ${COUNTRY} ${FILENAME} > ${TMPFILE}
LASTREPO=$(cat ${TMPFILE} | tail -n 1)
DATETIME=$( obtvalor "${LASTREPO}" 1 )
TCASES=$( obtvalor "${LASTREPO}" 3)
NCASES=$( obtvalor "${LASTREPO}" 4)
ACASES=$( obtvalor "${LASTREPO}" 8)
TDEATHS=$( obtvalor "${LASTREPO}" 5)
TRECOVERED=$( obtvalor "${LASTREPO}" 7)
echo "Pais ${COUNTRY} - datos tomados ${DATETIME}"
echo -e "\n Numero total de casos (tcases): " ${TCASES}
echo -e "\n Numero total de casos activos (acases): " ${ACASES}
echo -e "\n Numero total de nuevos casos (ncases): " ${NCASES}
echo -e "\n Numero total de recuperados (trecovered): " ${TRECOVERED}
echo -e "\n Numero total de fallecidos (tdeaths): " ${TDEATHS}
#echo "T. casos activos + T. recuperados + T. fallecidos = T. de casos"
rm ${TMPFILE}
