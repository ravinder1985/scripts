#!/bin/bash
start(){
 numberofArguments=$#
 echo $@ | grep cassandra
 if [[ $? == 0 ]]; then
	check=0
 else
	check=1
 fi
 keyPath=~/.ssh/xplat_ssd
 server=$1;
 shift;
 echo "server ${server}"
 for (( num=1; num<$numberofArguments; num++ ))
 do
        service=$1
        shift;
        ssh -tt -i ${keyPath} clduser@${server} "sudo service ${service} start"
 done
 echo "CHECKING CASSANDRA TO BE UP"
 count=0
 if [[ $check == 0 ]]; then
 while [[ $count != 20 ]]
 do
	(( count++ ))
	ssh -tt -i ${keyPath} clduser@${server} "sudo nodetool status"
        if [[ $? == 0 ]]; then
		count=20
	fi
	echo "CHECKING CASSANDRA TO BE UP"
	sleep 20
 done
 fi
}
cleanup(){
	keyPath=~/.ssh/xplat_ssd
	server=$1;
	ssh -tt -i ${keyPath} clduser@${server} "sudo rm -rf /var/lib/cassandra/saved_caches/*"
}
unmount(){
	keyPath=~/.ssh/xplat_ssd
        server=$1;
        ssh -tt -i ${keyPath} clduser@${server} "sudo umount /srv"
	ssh -tt -i ${keyPath} clduser@${server} "sudo df -h"
}
status(){
 numberofArguments=$#
 keyPath=~/.ssh/xplat_ssd
 server=$1;
 shift;
 echo "server ${server}"
 for (( num=1; num<$numberofArguments; num++ ))
 do
        service=$1
        shift;
        ssh -tt -i ${keyPath} clduser@${server} "sudo service ${service} status"
 done
}

stop(){
 numberofArguments=$#
 keyPath=~/.ssh/xplat_ssd
 server=$1;
 shift;
 echo "server ${server}"
 for (( num=1; num<$numberofArguments; num++ ))
 do
        service=$1
        shift;
        ssh -tt -i ${keyPath} clduser@${server} "sudo service ${service} stop"
 done
}
filesytemOperations(){
	keyPath=~/.ssh/xplat_ssd
        server=$1;
 	shift;
	echo "server ${server}"
	mountPoint=$1
	ssh -tt -i ${keyPath} clduser@${server} "sudo fdisk -l"
	ssh -tt -i ${keyPath} clduser@${server} "sudo e2fsck  -f ${mountPoint}"
	ssh -tt -i ${keyPath} clduser@${server} "sudo resize2fs ${mountPoint}"
}
mount(){
	keyPath=~/.ssh/xplat_ssd
	server=$1;
        shift;
        echo "server ${server}"
	mountPoint=$1;
	ssh -tt -i ${keyPath} clduser@${server} "sudo mount -a ${mountPoint}"
	ssh -tt -i ${keyPath} clduser@${server} "sudo df -h"
}
 action=$1
 shift;
 server=$1;
 shift;
 echo "server ${server}"
 if [[ $action != 'stop' && $action != 'start' && $action != 'status' && $action != 'mount' && $action != 'cleanup' ]]; then
        echo "Wrong command and first argument has to be action you taking"
        echo "Supporting commands are stop, start, status"
        exit 1
 fi
 if [[ ${action} == "start" ]]; then
 	${action} ${server} $@
 elif [[ ${action} == "stop" ]]; then
	${action} ${server} $@
        unmount ${server}
 elif [[ ${action} == "status" ]]; then
        ${action} ${server} $@
 elif [[ ${action} == "mount" ]]; then
	keyPath=~/.ssh/xplat_ssd
        ssh -tt -i ${keyPath} clduser@${server} "sudo fdisk -l"
        echo "\n \n PLEASE ENTER YOUR MOUNT POINT: \n"
        read mountPoint
	filesytemOperations ${server} ${mountPoint}
	mount ${server} ${mountPoint}
	cleanup ${server}
	start ${server} $@
 elif [[ ${action} == "cleanup" ]]; then
	cleanup ${server}
 fi
