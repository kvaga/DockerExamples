#!/bin/bash
source ../lib/management_scripts.sh
container_name=filebeat
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
	pid=$(docker container ls -a | grep /beats/filebeat | awk {'print $1'})
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
#	echo "Getting container ID from the pid file..."
#	pid=$(cat filebeat.pid)
#	if [ -z "$pid" ]
#	then
#			echo "Couldn't find container id in the pid file"
#
#	else
#			echo "Container ID: $pid"
#			echo "Stopping container [$pid]..."
#			docker container stop $pid
#			echo "Removing container [$pid]..."
#			docker container rm $pid
#	fi
#	
	#pid=$(docker container ls -a | grep /beats/filebeat | awk {'print $1'})
#	pid=$(getContainerId)
#	if [ -z "$pid" ]
#	then
#			echo "Can't find container id in the containers list"
#	else
#			echo "Container ID: $pid"
#			echo "Stopping container [$pid]..."
#			docker container stop $pid
#			echo "Removing container [$pid]..."
#			docker container rm $pid
#	fi
#}


function run(){
	# Pull image
	# docker pull docker.elastic.co/beats/filebeat:6.7.1

	# run container
	#docker run \
	#--rm --name filebeat --network elk_network \
	#docker.elastic.co/beats/filebeat:6.7.1 \
	#setup -E setup.kibana.host=kibana:5601 \
	#-E output.elasticsearch.hosts=["elasticsearch:9200"]

	echo "Starting filebeat container"
	docker run -d \
	  --name=filebeat \
	  --user=root \
	  --network elk_network \
	  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
	  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
	  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
	  --mount type=volume,dst=/opt/elk_filebeat_vol,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=/opt/docker_volumes/filebeat_vol/ \
	  docker.elastic.co/beats/filebeat:6.7.1 filebeat -e -strict.perms=false 
	#docker.elastic.co/beats/filebeat:6.7.1 filebeat -e -strict.perms=false -E output.elasticsearch.hosts=["elasticsearch:9200"] > filebeat.pid
	echo
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

