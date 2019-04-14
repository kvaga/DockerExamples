#!/bin/bash

function stopAll(){
	echo "Stopping all"
    	kill -9 $(jobs -l | grep ./generate_test_data.sh | awk {'print $2'})
	./filebeat.sh stop
	./logstash.sh stop
	./kibana.sh stop
	./elasticsearch.sh stop
}

function startAll(){
    	echo "Starting All"
	./network_elk_setup.sh
	./generate_test_data.sh &
	./elasticsearch.sh start & 
	echo "Sleeping for 60 seconds before starting of Kibana" 
	sleep 60
	./kibana.sh start &
	echo "Sleeping for 30 seconds before starting of Logstash"
	sleep 30
	./logstash.sh start &
	echo "Sleeping for 120 seconds before starting of Filebeat"
	sleep 120
	./filebeat.sh start &
}

function statusAll(){
       	docker container ls -a
	jobs -l
}


case $1 in
        startAll)
        startAll
        ;;

        stopAll)
        stopAll
        ;;

        statusAll)
        statusAll
        ;;
        *)
        printf "Commands are:\n"
        printf "startAll -\n"
        printf "stopAll -\n"
        printf "statusAll - \n"
        ;;

esac


