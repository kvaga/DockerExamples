#!/bin/bash
source ../lib/management_scripts.sh

#function stop(){
#        pid=$(getContainerId)
#        if [ -z "$pid" ]
#        then
#                        echo "Couldn't find container id in the containers list"
#        else
#                        echo 'Container ID: $pid'
#                        echo 'Stopping container [$pid]...'
#                        docker container stop $pid
#                        echo 'Removing container [$pid]...'
#                        docker container rm $pid
#        fi
#}
prepareYmlFile(){
	ES_YML_TEMPLATE=$1
	ES_YML_FILE=$2
	ELASTICSEARCH_HTTP_PORT=$3
	ELASTICSEARCH_TCP_PORT=$4
	cp $ES_YML_TEMPLATE $ES_YML_FILE
	sed -i -e "s/%ELASTICSEARCH_HTTP_PORT%/$ELASTICSEARCH_HTTP_PORT/" $ES_YML_FILE
	sed -i -e "s/%ELASTICSEARCH_TCP_PORT%/$ELASTICSEARCH_TCP_PORT/" $ES_YML_FILE
	echo "ES Yml file is:"
	cat $ES_YML_FILE
}
function run(){
        echo "Starting elasticsearch container..."
	echo "Parameters:"
	ELASTICSEARCH_CONTAINER_NAME=$1; echo ELASTICSEARCH_CONTAINER_NAME=$ELASTICSEARCH_CONTAINER_NAME
	ELASTICSEARCH_HTTP_PORT=$2; echo ELASTICSEARCH_HTTP_PORT=$ELASTICSEARCH_HTTP_PORT
	ELASTICSEARCH_TCP_PORT=$3; echo ELASTICSEARCH_TCP_PORT=$ELASTICSEARCH_TCP_PORT
	ES_YML_TEMPLATE=elasticsearch.yml; ES_YML_TEMPLATE=$ES_YML_TEMPLATE
	ES_YML_FILE=$ELASTICSEARCH_CONTAINER_NAME.$ES_YML_TEMPLATE; echo ES_YML_FILE=$ES_YML_FILE
	prepareYmlFile $ES_YML_TEMPLATE $ES_YML_FILE $ELASTICSEARCH_HTTP_PORT $ELASTICSEARCH_TCP_PORT 
        echo
	docker run \
		-p $2:$2 \
		-p $3:$3 \
		-v $(pwd)/$ES_YML_FILE:/usr/share/elasticsearch/config/elasticsearch.yml \
		-e "discovery.type=single-node" \
		--name $1 \
		--network elk_network \
		docker.elastic.co/elasticsearch/elasticsearch:6.7.1
        echo
#-p $2:9200 \
#-p $3:9300 \
}
echo "#####################################################"
echo "###########        ELASTICSEARCH         ############"
echo "#####################################################"
case $1 in
	run)
		if [ -z "$2" ]
		then
			echo "Can't find a name of ES's instance. Specify the name of ES instance in the first parameter. For example:"
			echo "# $0 run elasticsearch_043 9200 9300"
			exit 1
		fi
		if [ -z "$3" ]
			then
				echo "Can't find a HTTP port number of ES's instance. Specify the HTTP port number of ES's instance in the second parameter. For example:"
				echo "# $0 run elasticsearch_043 9200 9300"
			exit 1
			fi
		if [ -z "$4" ]
			then
				echo "Cann't find TCP port number of ES's instance. Specify the TCP port number of ES's instance in the third parameter. For example:"
				echo "# $0 run elasticsearch_043 9200 9300"
			exit 1
		fi
		run ${@:2}
	;;
	stop)
	stop $2
	;;
	stopAndRun)
	stop $2
	run $2
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


