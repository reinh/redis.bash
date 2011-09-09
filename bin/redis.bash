#!/usr/bin/env bash

CRLF="\r\n"
COMMAND="*$#${CRLF}"

for arg in "$@"; do
    COMMAND="${COMMAND}\$${#arg}${CRLF}${arg}${CRLF}"
done

exec 3<>/dev/tcp/127.0.0.1/6379
{ printf $COMMAND; sleep 0.01; } >&3

read -r output <&3
case $output in
    +*) # Status reply
        echo "${output#+}"
        ;;
    -*) # Error reply
        echo "${output#-}" >&2
        exit 1
        ;;
    \$*) # bulk reply
        nchars="${output#\$}"
        read -n ${nchars} response <&3
        echo $response
        ;;
    *)  echo "WTF" ;;
esac
