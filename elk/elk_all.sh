#!/bin/bash
source ../lib/management_scripts.sh
FILEBEAT_CONTAINER_NAME=filebeat
KIBANA_CONTAINER_NAME=kibana
KIBANA_PORT=5601
ELASTICSEARCH_CONTAINER_NAME=elasticsearch
ELASTICSEARCH_PORT=9200
ELASTICSEARCH_MGMT_PORT=9300
LOGSTASH_CONTAINER_NAME=logstash
LOGSTSH_API_PORT=9600
LOGSTASH_PORT=5044

function suspendAll(){
        echo "Suspend all"
        suspend $FILEBEAT_CONTAINER_NAME
        suspend $LOGSTASH_CONTAINER_NAME
        suspend $KIBANA_CONTAINER_NAME
        suspend $ELASTICSEARCH_CONTAINER_NAME
}

function unsuspendAll(){
        echo "Unsuspend all"
	unsuspend $ELASTICSEARCH_CONTAINER_NAME
        unsuspend $FILEBEAT_CONTAINER_NAME
        unsuspend $LOGSTASH_CONTAINER_NAME
        unsuspend $KIBANA_CONTAINER_NAME
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
        ./logstash.sh run $LOGSTASH_CONTAINER_NAME $LOGSTSH_API_PORT $LOGSTASH_PORT& 
	echo "Sleeping for 180 seconds before starting of Kibana" 
	sleep 180
	./kibana.sh run $KIBANA_CONTAINER_NAME $KIBANA_PORT $ELASTICSEARCH_CONTAINER_NAME &
	echo "Sleeping for 120 seconds before starting of Filebeat"
	sleep 120
	./filebeat.sh run $FILEBEAT_CONTAINER_NAME &
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
	suspendAll)
	suspendAll
	;;
	unsuspendAll)
	unsuspendAll
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
	printf "suspendAll -\n"
	printf "unsuspendAll -\n"
	printf "restartAll - \n"
	;;
esac


