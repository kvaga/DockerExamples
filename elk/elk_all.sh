#!/bin/bash

source ../lib/management_scripts.sh
FILEBEAT_CONTAINER_NAME=filebeat_test
KIBANA_CONTAINER_NAME=kibana_test
KIBANA_PORT=5605
ELASTICSEARCH_CONTAINER_NAME=elasticsearchtest
ELASTICSEARCH_PORT=9203
ELASTICSEARCH_MGMT_PORT=9303
LOGSTASH_CONTAINER_NAME=logstash_test
LOGSTSH_API_PORT=9603
LOGSTASH_PORT=5047

function pauseAll(){
        echo "Pause all"
        pause $FILEBEAT_CONTAINER_NAME
        pause $LOGSTASH_CONTAINER_NAME
        pause $KIBANA_CONTAINER_NAME
        pause $ELASTICSEARCH_CONTAINER_NAME
}

function unpauseAll(){
        echo "Unpause all"
	unpause $ELASTICSEARCH_CONTAINER_NAME
        unpause $FILEBEAT_CONTAINER_NAME
        unpause $LOGSTASH_CONTAINER_NAME
        unpause $KIBANA_CONTAINER_NAME
}

function restartAll(){
        echo "Restart all"
	restart $ELASTICSEARCH_CONTAINER_NAME
        restart $FILEBEAT_CONTAINER_NAME
        restart $LOGSTASH_CONTAINER_NAME
        restart $KIBANA_CONTAINER_NAME
}

function stopAll(){
	echo "Stopping all"
    	kill -9 $(jobs -l | grep ./generate_test_data.sh | awk {'print $2'})
	stop $FILEBEAT_CONTAINER_NAME
	stop $LOGSTASH_CONTAINER_NAME
	stop $KIBANA_CONTAINER_NAME
	stop $ELASTICSEARCH_CONTAINER_NAME
	statusAll
	echo
}

function runAll(){
    	echo "Starting All"
	./network_elk_setup.sh
	./generate_test_data.sh &
	./elasticsearch.sh run $ELASTICSEARCH_CONTAINER_NAME $ELASTICSEARCH_PORT $ELASTICSEARCH_MGMT_PORT & 
	echo "Sleeping for 120 seconds before starting of Logstash"
        sleep 120
        ./logstash.sh run $LOGSTASH_CONTAINER_NAME $LOGSTSH_API_PORT $LOGSTASH_PORT http://$ELASTICSEARCH_CONTAINER_NAME:$ELASTICSEARCH_PORT & 
	echo "Sleeping for 180 seconds before starting of Kibana" 
	sleep 180
	./kibana.sh run $KIBANA_CONTAINER_NAME $KIBANA_PORT $ELASTICSEARCH_CONTAINER_NAME &
	echo "Sleeping for 120 seconds before starting of Filebeat"
	sleep 120
	./filebeat.sh run $FILEBEAT_CONTAINER_NAME $ELASTICSEARCH_CONTAINER_NAME:$ELASTICSEARCH_PORT &
}
function statusAll(){
	echo
	echo "STATUS OF CONTAINERS:"
	status $KIBANA_CONTAINER_NAME
        status $ELASTICSEARCH_CONTAINER_NAME
        status $FILEBEAT_CONTAINER_NAME
        status $LOGSTASH_CONTAINER_NAME
	echo "STATUS OF DATA GENERATION:"
	jobs -l | grep ./generate_test_data.sh
}
echo "#####################################################"
echo "###############        ELK ALL           ############"
echo "#####################################################"

case $1 in
	runAll)
	runAll
	;;
	stopAll)
	stopAll
	;;
	pauseAll)
	pauseAll
	;;
	unpauseAll)
	unpauseAll
	;;
	restartAll)
	restartAll
	;;
	statusAll)
	statusAll
	;;
	*)
	printf "Commands are:\n"
	printf "runAll -\n"
	printf "stopAll -\n"
	printf "statusAll - \n"
	printf "pauseAll -\n"
	printf "unpauseAll -\n"
	printf "restartAll - \n"
	;;
esac


