#!/bin/bash
source ../lib/management_scripts.sh

container_name=kibana
:'
function pause(){
	docker container pause $container_name
}
function unpause(){
	docker container unpause $container_name
}
function restart(){
	docker container restart $container_name
}

function getContainerId(){
        pid=$(docker container ls -a | grep /kibana/kibana | awk {'print $1'})
        echo $pid
}
function logs(){
        docker logs $(getContainerId)
}
function shell(){
        docker exec -it $(getContainerId) /bin/bash
}

'
#function stop(){
#        pid=$(getContainerId)
#        if [ -z "$pid" ]
#        then
#                        echo "Couldn't find container id in the containers list"
#        else
#                        echo "Container ID: $pid"
#                        echo "Stopping container [$pid]..."
#                        docker container stop $pid
#                        echo "Removing container [$pid]..."
#                        docker container rm $pid
#        fi
#}

function getESContainerId(){
	pidES=$(docker container ls -a | grep /elasticsearch/elasticsearch | awk {'print $1'})
	echo $pidES
}


function run(){
	elasticsearch_container_id=$(getESContainerId)
        echo "Starting Kibana for ES [$elasticsearch_container_id]"
        docker run \
		--link $elasticsearch_container_id:elasticsearch \
		--rm \
		--name $1 \
		--network elk_network \
		-p $2:$2 \
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
	stop
	;;
	stopAndRun)
	stop
	start
	;;
	pause)
	pause
	;;
	unpause)
	unpause
	;;
	restart)
	restart
	;;
	logs)
	logs
	;;
	shell)
	shell
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


