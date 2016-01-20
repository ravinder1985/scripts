#!/bin/bash
keyPath=~/.ssh/xplat_ssd
keyOption="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null";
user=clduser
if [[ $# < 1 ]]; then
	echo "PASS THE APPLICATION YOU WANT TO RESTART"
	exit 1
fi
if [[ $1 != "UGCAPP" && $1 != "UGCMEDIA" && $1 != "ALL" ]]; then
        echo "AVALIABLE OPTIONS ARE AS FOLLWOING"
	echo "UGCAPP"
	echo "UGCMEDIA"
	echo "ALL"
        exit 1
fi
if [[ $2 == "" ]]; then
	echo "Please pass the env file where you wanna run this script"
	echo "FOLLWOING ARE THE AVAILABLE FILES: "
	ls -ltr files/ | grep "xcloud" | awk '{print $NF}'
	exit 1
fi
service=$1
file=$2
echo "${file} \n \n"

#set -x
for server in $(cat files/${file} | grep "$1" | cut -f 2 -d":")
do
	if [[ $1 == "ALL" ]]; then
		service=$(cat files/${file} | grep ${server} | cut -f2 -d"," | cut -f1 -d":")
	fi
	if [[ ${service} == "UGCAPP" ]]; then
        	url=${server}:8080/ugc
	fi
	if [[ ${service} == "UGCMEDIA" ]]; then
        	url=${server}:8080/media
	fi
	ssh -tt -i ${keyPath} ${keyOption} ${user}@${server} "hostname"
	count=0
	while [[ $count != 20 ]]
 	do
        	(( count++ ))
        	#ssh -tt -i ${keyPath} ${user}@${server} "curl -IS ${url} | grep \"200\""
		curl -IS ${url} | grep "200"
        	if [[ $? == 0 ]]; then
                	count=20
			echo "TOMCAT UP AND RUNNING ON ${server}"
		else
			echo "WAITING TOMCAT TO BE UP......"
                	sleep 20
        	fi
 	done	
done
#set +x
