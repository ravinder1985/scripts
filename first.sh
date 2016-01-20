#!/bin/bash
echo $@ | grep cass
f(){
	echo "Harvinder"
	echo "singh"
result=0
while [[ $result != 10 ]]
do
	(( result++ ))
	echo $result
done
}
$1
