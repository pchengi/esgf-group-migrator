#!/usr/bin/python

import os,sys

try:
	dstgroup=sys.argv[1]
	dstrole=sys.argv[2]
	fname=sys.argv[3]
except:
	sys.exit(-1)

fname2='restoreusers.sql'
fname3='restoreperms.sql'

try:
	fp=open(fname)
	fp2=open(fname2,'w')
	fp3=open(fname3,'w')
except:
	print "Couldn't open file. Urk!";
	sys.exit(-1)

lines=fp.readlines()
fp.close()
for line in lines:
	fields=line.split(',')
	numfields=16
	openid=''
	mystr='insert into esgf_security.user (firstname,middlename,lastname,email,username,password,dn,openid,organization,organization_type,city,state,country,status_code,verification_token,notification_code) values ('	
	for i in range (0,16):
		if i == 7:
			openid=fields[i]
		if i != 13 and i != 15:
			if fields[i] == '\"\"':
				fields[i] ='\'\''
			if not fields[i].startswith('\''):
				mfield='\''+fields[i]+'\''
			else:
				mfield=fields[i]
		else:	
			mfield=fields[i]
		mystr+=mfield
		if i != 15:
			mystr+=','
	mystr=mystr.split('\n')[0]
	mystr+=');\n'
	mystr2='insert into esgf_security.permission (user_id,group_id,role_id,approved) values ((select id from esgf_security.user where openid=\''
	mystr2+=openid+'\'),'
	mystr2+=str(dstgroup)+','+str(dstrole)+',true);\n'
	fp2.write(mystr)
	fp3.write(mystr2)
fp2.close()
fp3.close()
