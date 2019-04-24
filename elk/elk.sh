#!/bin/bash
source ../lib/management_scripts.sh
function suspendAll(){
        echo "Suspend all"
        docker container suspend filebeat
        docker container suspend logstash
        docker container suspend kibana
        docker container suspend elasticsearch
}

function unsuspendAll(){
        echo "Unsuspend all"
	docker container unsuspend elasticsearch
        docker container unsuspend filebeat
        docker container unsuspend logstash
        docker container unsuspend kibana
}

function restartAll(){
        echo "Restart all"
	docker container restart elasticsearch
        docker container restart filebeat
        docker container restart logstash
        docker container restart kibana
}

function stopAll(){
	echo "Stopping all"
    	kill -9 $(jobs -l | grep ./generate_test_data.sh | awk {'print $2'})
	./filebeat.sh stop
	./logstash.sh stop
	./kibana.sh stop
	./elasticsearch.sh stop
}

function runAll(){
    	echo "Starting All"
	./network_elk_setup.sh
	./generate_test_data.sh &
	./elasticsearch.sh run & 
	echo "Sleeping for 60 seconds before starting of Kibana" 
	sleep 60
	./kibana.sh run &
	echo "Sleeping for 30 seconds before starting of Logstash"
	sleep 30
	./logstash.sh run &
	echo "Sleeping for 120 seconds before starting of Filebeat"
	sleep 120
	./filebeat.sh run &
}

function statusAll(){
       	docker container ls -a
	jobs -l
}


case $1 in
	runAll)
	runAll
	;;
	stopAll)
	stopAll
	;;
	statusAll)
	statusAll
	;;
	suspendAll)
	suspendAll
	;;
	unsuspendAll)
	unsuspendAll
	;;
	restartAll)
	restartAll
	;;
	*)
	printf "Commands are:\n"
	printf "runAll -\n"
	printf "stopAll -\n"
	printf "statusAll - \n"
	printf "suspendAll -\n"
	printf "unsuspendAll -\n"
	printf "restartAll - \n"
	;;
esac


