#!/usr/bin/env bash
#
# redis.bash - A Redis client
#
# usage: redis.bash <ARGS>
#
# CAVEATS
#
# - requires a bash with /dev/tcp enabled. Older debians/Ubuntus disabled /dev/tcp.
# - does not handle multi-bulk replies.
# - does not allow configuration of redis host or port
#
# EXIT VALUES
#
# 0: Success
# 1: Redis error
# 2: Unknown response

CRLF="\r\n"

# Build the command according to redis protocol
# http://code.google.com/p/redis/wiki/ProtocolSpecification
COMMAND="*$#${CRLF}"
for arg in "$@"; do
    COMMAND="${COMMAND}\$${#arg}${CRLF}${arg}${CRLF}"
done

# Make TCP request to Redis using numerical fd 3
exec 3<>/dev/tcp/127.0.0.1/6379
{ printf $COMMAND; sleep 0.01; } >&3 # sleep to avoid a socket close race condition. NOT ideal.

# Parse the response according to redis protocol
read -r response <&3
case $response in
    +*) # Status
        echo "${response#+}"
        ;;
    -*) # Error
        echo "${response#-}" >&2
        exit 1
        ;;
    :*) # Integer
        echo "${response#:}"
        ;;
    \$*) # Bulk reply
        nchars="${response#\$}"
        nchars="${nchars%\r}"
        read -n $nchars response <&3
        echo $response
        ;;
    *) # net yet handled
        echo "ERR - Unknown response\n" >&2
        exit 2
        ;;
esac

# vim: sw=4:ts=4:sts=4
