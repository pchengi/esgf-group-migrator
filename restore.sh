#!/bin/bash

env|grep PGPATH >/dev/null

if [ $? -eq 1 ]; then
	echo "Please export the Postgres home with PGPATH, ex: export PGPATH=/usr/local/pgsql";
	exit -1;
fi
PGPATH=`env|grep PGPATH|cut -d'=' -f2`
PSQL=$PGPATH/bin/psql

if [ $# -lt 3 ]; then
	echo "Please provide target group id, role id for 'user' role and input filename";
	exit -1;
fi


python prepingestion.py $1 $2 $3

$PSQL -d esgcet -U dbsuper -f restoreusers.sql >/dev/null
$PSQL -d esgcet -U dbsuper -f restoreperms.sql >/dev/null
