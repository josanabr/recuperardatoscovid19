#!/usr/bin/env bash
#
# Este script permite acceder a datos de la evolucion del COVID19 por ciudades
# en Colombia.
#
# AUTHOR: John Sanabria - john.sanabria@correounivalle.edu.co
# DATE: 2020-03-31
#
OUTPUTFILE="datos.json"
if [ ! "$1" == "" ]; then
  OUTPUTFILE="${1}"
fi
curl 'https://e.infogram.com/api/live/flex/bc384047-e71c-47d9-b606-1eb6a29962e3/664bc407-2569-4ab8-b7fb-9deb668ddb7a?' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:74.0) Gecko/20100101 Firefox/74.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'Cookie: _ga=GA1.2.2018392962.1585434723; _gid=GA1.2.565197144.1585434723; ig_putma=s%3A%7B%22id%22%3A%22b5505a7f-d430-4bb5-aae9-4a781ff75052%22%2C%22createdAt%22%3A%222020-03-30T08%3A55%3A54.632Z%22%7D.bSeWZcAWPVsk0uZ3SxxVlFf2GU1HfTvseBxUNFKGQw4' -H 'If-None-Match: W/"11fb1-Zy1GG3/9D8npEod8K7Zpo+9Krz4"' -H 'TE: Trailers' > ${OUTPUTFILE}
