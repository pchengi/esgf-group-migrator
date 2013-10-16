#!/bin/bash

env|grep PGPATH >/dev/null

if [ $? -eq 1 ]; then
	echo "Please export the Postgres home with PGPATH, ex: export PGPATH=/usr/local/pgsql";
	exit -1;
fi
PGPATH=`env|grep PGPATH|cut -d'=' -f2`

if [ $# -lt 2 ]; then
	echo "Please provide source groupid and output file name (without path)";
	exit -1;
fi


PSQL=$PGPATH/bin/psql

sourcegroupid=$1
outputfile=$2

echo "copy(select firstname,middlename,lastname,email,username,password,dn,openid,\
organization, organization_type,city,state,country,status_code,verification_token,\
notification_code from esgf_security.user u, esgf_security.permission p where \
p.group_id=$sourcegroupid and p.approved = 't' and u.id = p.user_id) to '/tmp/$outputfile' with csv;" >getuserdata.sql

$PSQL -d esgcet -U dbsuper -f getuserdata.sql >/dev/null
mv /tmp/$outputfile .
