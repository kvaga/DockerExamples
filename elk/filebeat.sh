#!/bin/bash
source ../lib/management_scripts.sh

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
	  --name=$1 \
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
echo "#####################################################"
echo "###############        FILEBEAT          ############"
echo "#####################################################"
case $1 in
	run)
		if [ -z "$2" ]
		then
			echo "Can't find a name of Filebeat's instance. Specify the name of filebeat instance in the first parameter. For example:"
			echo "# $0 run filebeat_043"
			exit 1
		fi
		run ${@:2}
	;;
	stop)
	stop $1
	;;
	stopAndRun)
	stop $1
	start $1
	;;
	pause)
	pause $1
	;;
	unpause)
	unpause $1
	;;
	restart)
	restart $1
	;;	
	logs)
	logs $1
	;;
	shell)
	shell $1
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

