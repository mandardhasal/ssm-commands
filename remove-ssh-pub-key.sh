#!/bin/bash
while getopts "u:k:" OPTION
do
	case $OPTION in
		u)
			HOST_USER=$OPTARG
			;;
		k)
			PUB_KEY_USER_NAME=$OPTARG
			;;
		\?)
			echo "u=host user, k=public key user name";
			exit 1
			;;
	esac
done


USER_HOME=$(eval echo "~$HOST_USER")
AUTH_KEY_PATH=$USER_HOME/.ssh/authorized_keys; 
SEARCH=" "${PUB_KEY_USER_NAME}'@qi\\>'



if [ -z "$HOST_USER" ] ||  [ -z "$PUB_KEY_USER_NAME" ]; then
	echo "parameters not set";
	echo "u=host user, k=public key user name";
	exit 1;
fi;

if test -f ${AUTH_KEY_PATH}; then 
	if grep -e "${SEARCH}" ${AUTH_KEY_PATH}; then 
		if grep -v "${SEARCH}" ${AUTH_KEY_PATH} > $USER_HOME/.ssh/tmp; then 
			cat $USER_HOME/.ssh/tmp | sed -e :a -e '/^\*$/{$d;N;ba' -e '}' > ${AUTH_KEY_PATH} && chown `stat ${USER_HOME}/.ssh -c %u:%g` ${AUTH_KEY_PATH} && rm -rf $USER_HOME/.ssh/tmp && echo 'key removed successfully'; 
		fi; 
	else 
		echo "key for $PUB_KEY_USER_NAME does not exist"; 
	fi; 
else 
	echo "${AUTH_KEY_PATH} does not exist" && exit 1; 
fi;
