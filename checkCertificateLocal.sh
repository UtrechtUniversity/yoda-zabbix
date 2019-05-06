#!/bin/sh
 
# \file      checkCertificateLocal.sh
# \brief     Returns the number of days until expiry of a local certificate (or 0 if certificate has expired)
# \param     certfile Filename containing the certificate.
# \param     sudouser Sudo to this user in order to read the file (optional - default behaviour: do not use sudo)
# \copyright Copyright (c) 2019, Utrecht University. All rights reserved.
 
CERTFILE="${1:-/etc/irods/localhost_and_chain.crt}"
SUDOUSER="$2"

set -e
set -o pipefail
set -u

if [ -z "$CERTFILE" ]
then echo "Error: need certificate file name argument."
     exit 1
fi

if [ -z "$SUDOUSER" ]
then CERTDATE=$(openssl x509 -in "$CERTFILE" -noout -text | \
           grep "Not After" | cut -d ":" -f 2- | sed 's/^ *//')
else CERTDATE=$(sudo -u "$SUDOUSER" openssl x509 -in "$CERTFILE" -noout -text | \
           grep "Not After" | cut -d ":" -f 2- | sed 's/^ *//')
fi

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
