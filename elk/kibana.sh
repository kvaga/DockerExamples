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
 function getESContainerId(){
	pidES=$(docker container ls -a | grep /elasticsearch/elasticsearch | awk {'print $1'})
	echo $pidES
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

function run(){
	elasticsearch_container_id=$(getESContainerId)
        echo "Starting Kibana for ES [$elasticsearch_container_id]"
        docker run \
		--link $elasticsearch_container_id:elasticsearch \
		--rm \
		--name kibana \
		--network elk_network \
		-p 5601:5601 \
		docker.elastic.co/kibana/kibana:6.7.1
}




case $1 in
	run)
	run
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


