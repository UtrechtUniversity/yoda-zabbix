#!/bin/sh

# \file      checkCertificateRemote.sh
# \brief     Returns the number of days until expiry of a remote certificate (or 0 if certificate has expired)
# \param servername Name of the server, e.g. yoda.uu.nl
# \param serverport TCP port number (optional - default value is 443)
# \copyright Copyright (c) 2019, Utrecht University. All rights reserved.

SERVERNAME="$1"
SERVERPORT="${2:-443}"

set -e
set -o pipefail
set -u

if [ -z "$SERVERNAME" ]
then echo "Error: need server name argument."
     exit 1
fi

CERTDATE=$(echo "Q" | \
           openssl s_client -connect "$SERVERNAME:$SERVERPORT" -servername "$SERVERNAME" 2> /dev/null | \
           openssl x509 -text -noout | grep "Not After" | cut -d ":" -f 2- | sed 's/^ *//')

if [ -z "$CERTDATE" ]
then echo "Error: unable to determine certificate expiry date"
     exit 1
fi

CUR_EPOCH_TIME=$(date "+%s")
EXP_EPOCH_TIME=$(date --date "$CERTDATE" "+%s")

if [ -z "$EXP_EPOCH_TIME" ]
then echo "Error: unable to parse expiry date of certificate."
     exit 1
fi

if [ "$CUR_EPOCH_TIME" -ge "$EXP_EPOCH_TIME" ]
then echo 0
else DIFF_SECONDS=$(( EXP_EPOCH_TIME - CUR_EPOCH_TIME ))
     echo $(( DIFF_SECONDS / 86400 ))
fi
