#!/usr/bin/env bash
#
# Este script permite el envio de mensajes a whatsapp. Se uso el sandbox
# creado por defecto en la pagina twilio.
#
# Author: John Sanabria
# Date: 2020-03-24
#
MESSAGE=""
while read line; do
	MESSAGE=$( echo -e "${MESSAGE} ${line}" ) 
done < "${1:-/dev/stdin}"
curl 'https://api.twilio.com/2010-04-01/Accounts/AC3fc7d2cc0bee3038fb0a785dd2d9595d/Messages.json' -X POST \
--data-urlencode 'To=whatsapp:+<YOURPHONENUMBER>' \
--data-urlencode 'From=whatsapp:+14155238886' \
--data-urlencode "Body=$(echo ${MESSAGE} )" \
-u AC3fc7d2cc0bee3038fb0a785dd2d9595d:915d6fdeb6a6bfc93632bbcaf1518cbf
