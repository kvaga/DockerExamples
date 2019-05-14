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

	echo "Starting filebeat container..."
	
	echo "Parameters:"
	FILEBEAT_CONTAINER_NAME=$1; echo FILEBEAT_CONTAINER_NAME=$FILEBEAT_CONTAINER_NAME
	LOGSTASH_INSTANCE_URL=$2; echo LOGSTASH_INSTANCE_URL=$LOGSTASH_INSTANCE_URL
	YML_TEMPLATE=filebeat.yml.template; echo YML_TEMPLATE=$YML_TEMPLATE
	YML_CONFIG_FILE=$FILEBEAT_CONTAINER_NAME.filebeat.yml; echo YML_CONFIG_FILE=$YML_CONFIG_FILE
	echo "Preparing YML config file"
	cp $YML_TEMPLATE $YML_CONFIG_FILE
	insertParameter $YML_CONFIG_FILE %LOGSTASH_URL% $LOGSTASH_INSTANCE_URL
	
	echo "The [$YML_CONFIG_FILE] is:"
	cat $YML_CONFIG_FILE
	echo 
	
	docker run -d \
	  --name=$FILEBEAT_CONTAINER_NAME \
	  --user=root \
	  --network elk_network \
	  --volume="$(pwd)/$YML_CONFIG_FILE:/usr/share/filebeat/filebeat.yml:ro" \
	  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
	  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
	  --mount type=volume,dst=/opt/elk_filebeat_vol,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=/opt/docker_volumes/filebeat_vol/ \
	  docker.elastic.co/beats/filebeat:6.7.1 filebeat -e -strict.perms=false  \
	#docker.elastic.co/beats/filebeat:6.7.1 filebeat -e -strict.perms=false \
	echo
#-e OUTPUT_LOGSTASH_ENABLED='true' \
#-e OUTPUT_LOGSTASH_HOSTS='$LOGSTASH_INSTANCE_URL' \
# -E output.logstash.hosts=$LOGSTASH_INSTANCE_URL
}
echo "#####################################################"
echo "###############        FILEBEAT          ############"
echo "#####################################################"
case $1 in
	run)
		if [ -z "$2" ]
		then
			echo "Can't find a name of Filebeat's instance. Specify the name of filebeat instance in the first parameter. For example:"
			echo "# $0 run filebeat_043 elasticsearch:9200"
			exit 1
		fi
		if [ -z "$3" ]
                then
                        echo "Can't find URL of the Logstash. Specify the URL of Logstash instance in the second parameter. For example:"
                        echo "# $0 run filebeat_043 logstash:5044" 
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

