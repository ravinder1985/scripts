#!/bin/bash
restart(){
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
        ssh -tt -i ${keyPath} clduser@${server} "sudo rm -rf /var/lib/cassandra/saved_caches/*;sudo service ${service} restart"
 done
 echo "CHECKING CASSANDRA TO BE UP"
 count=0
 if [[ $check == 0 ]]; then
 while [[ $count != 20 ]]
 do
        (( count++ ))
	if [[ $count == 1 ]]; then
		sleep 40
	fi
        ssh -tt -i ${keyPath} clduser@${server} "sudo nodetool status"
        if [[ $? == 0 ]]; then
                count=20
	else
		if [[ $count == 20 ]]; then
			echo "COULDNR START ${server}"
			exit 1;
		fi
		sleep 30
        fi
        echo "CHECKING CASSANDRA TO BE UP"
        #sleep 20
 done
 fi
}

keyPath=~/.ssh/xplat_ssd
action=$1
shift;
server=$1;
shift;
echo $server;
for i in $server
do
	#echo "#${action} ${server} $@"
	#${action} ${i} $@
	ssh -tt -i ${keyPath} clduser@${i} 'cat /etc/cassandra/conf/cassandra.yaml | grep "seeds" | grep -v "#"'
	${action} ${i} $@
done
#${action} ${server} $@



