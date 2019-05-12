#!/bin/bash
source ../lib/management_scripts.sh

function getESContainerId(){
	pidES=$(docker container ls -a | grep $1 | awk {'print $1'})
	echo $pidES
}

function run(){
	# change port number through the Environment Variables is possible by the key: -e SERVER_PORT=$2 \
	elasticsearch_container_id=$(getESContainerId $3)
        echo "Starting Kibana for ES [$elasticsearch_container_id]..."
	echo "Parameters:"
	echo KIBANA_CONTAINER_NAME=$1
	echo KIBANA_PORT=$2
        echo
	docker run \
		--link $elasticsearch_container_id:elasticsearch \
		--name $1 \
		--network elk_network \
		-p $2:5601 \
		docker.elastic.co/kibana/kibana:6.7.1
}
echo "#####################################################"
echo "##############         KIBANA            ############"
echo "#####################################################"

case $1 in
	run)
		if [ -z "$2" ]
		then
			echo "Can't find a name of Kibana's instance. Specify the name of Kibana instance in the first parameter. For example:"
			echo "# $0 run kibana_043 5601 elasticsearch_043"
			exit 1
		fi
		if [ -z "$3" ]
			then
				echo "Can't find a port number of Kibana's instance. Specify the port number of Kibana's instance in the second parameter. For example:"
				echo "# $0 run kibana_043 5601 elasticsearch_043"
			exit 1
			fi
		if [ -z "$4" ]
			then
				echo "Can't find a name of ES's instance. Specify the name of ES instance in the third parameter. For example:"
				echo "# $0 run kibana_043 5601 elasticsearch_043"
			exit 1
		fi
		run ${@:2}
	;;
	stop)
	stop $2
	;;
	stopAndRun)
	stop $2
	start $2
	;;
	pause)
	pause $2
	;;
	unpause)
	unpause $2
	;;
	restart)
	restart $2
	;;
	logs)
	logs $2
	;;
	shell)
	shell $2
	;;
	*)
	printf "Commands are:\n"
	printf "run- \n"
	printf "stopAndRun- \n"
	printf "stop - \n"
	printf "restart - \n"
	printf "logs - \n"
	printf "shell - \n"
	printf "pause - \n"
	printf "unpause - \n"
	;;
esac


