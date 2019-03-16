#!/bin/bash
while getopts "u:c:k:" OPTION
do
	case $OPTION in
		u)
			HOST_USER=$OPTARG
			;;
		k)
			PUB_KEY_USER_NAME=$OPTARG
			;;
		c)
			KEY_CONTENT=$OPTARG
			;;
		\?)
			echo "u=host user, c=contents of file, k=public key user name";
			exit 1
			;;
	esac
done



if [ -z "$HOST_USER" ] ||  [ -z "$PUB_KEY_USER_NAME" ] || [ -z "$KEY_CONTENT" ]; then
	echo "parameters not set";
	echo "u=host user, c=contents of file, k=public key user name";
	exit 1;
fi;

AUTH_KEY_PATH=$(eval echo "~$HOST_USER")/.ssh/authorized_keys; 
SEARCH="~"${PUB_KEY_USER_NAME}'@qi~'

if test -f ${AUTH_KEY_PATH}; then 
	if grep -e " ${SEARCH}" ${AUTH_KEY_PATH}; then 
		echo "Pub key for $PUB_KEY_USER_NAME already exsit"; 
	else  echo  >> ${AUTH_KEY_PATH} && echo $KEY_CONTENT >> ${AUTH_KEY_PATH} && echo "Pub key for $PUB_KEY_USER_NAME added successfully"; 
	fi; 
else echo "${AUTH_KEY_PATH} file does not exist" && exit 1; 
fi;