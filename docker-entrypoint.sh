#!/bin/bash

# turn on bash's job control
set -m

yell() { echo "$0: $*" >&2; }
die()  { yell "$*"; exit 111; }
try()  { echo "$ $@" 1>&2; "$@" || die "cannot $*"; }

# validate required input
if [ -z "$SERVICES" ]; then
  echo "Please define AWS service to run with Moto Server (e.g. s3, ec2, etc)"
  exit 1
else
  set MOTO_SERVICE = $SERVICES
fi

yell "Running moto server"

exec /usr/local/bin/moto_server $MOTO_SERVICE -H 0.0.0.0 --port 4566 &

yell "Running custom scripts in /moto/init.d/ ..."

for file in /moto/init.d/*.sh; do
    if [ -f "$file" ] && [ -x "$file" ]; then
        try "$file"
    else
        yell "Ignoring $file, it is either not a file or is not executable"
    fi
done

fg %1
