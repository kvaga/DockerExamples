#!/bin/bash
source ../lib/management_scripts.sh
container_name=logstash
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
        pid=$(docker container ls -a | grep /logstash/logstash | awk {'print $1'})
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
#	pid=$(getContainerId)
#	if [ -z "$pid" ]
#	then
#			echo "Couldn't find container id in the containers list"
#	else
#			echo "Container ID: $pid"
#			echo "Stopping container [$pid]..."
#			docker container stop $pid
#			echo "Removing container [$pid]..."
#			docker container rm $pid
#	fi
#}

function run(){
	echo "Starting logstash container"
	docker run --name logstash \
	--rm -it \
	-v ~/DockerExamples/logstash.yml:/usr/share/logstash/config/logstash.yml \
        -v ~/DockerExamples/logstash.conf:/usr/share/logstash/config/logstash.conf \
	-p 9600:9600 -p 5044:5044 \
	--network elk_network \
	docker.elastic.co/logstash/logstash:6.7.1 -f /usr/share/logstash/config/logstash.conf --config.reload.automatic
	echo
#       -v ~/DockerExamples/logstash-filter.conf:/usr/share/logstash/config/logstash-filter.conf \
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
	run
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
	printf "run - \n"
	printf "stop - \n"
	printf "stopAndRun - \n"
	printf "logs - \n"
	printf "shell - \n"
	printf "pause - \n"
	printf "unpause - \n"
	printf "restart - \n"
	;;
esac

