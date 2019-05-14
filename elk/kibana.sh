#!/bin/bash
source ../lib/management_scripts.sh

#function getESContainerId(){
#	pidES=$(docker container ls -a | grep $1 | awk {'print $1'})
#	echo $pidES
#}

function run(){
	# change port number through the Environment Variables is possible by the key: -e SERVER_PORT=$2 \
	#elasticsearch_container_id=$(getESContainerId $3)
        echo "Starting Kibana for ES [$elasticsearch_container_id]..."
	echo "Parameters:"
	ES_HTTP_URL=$3; echo ES_HTTP_URL=$ES_HTTP_URL
	KIBANA_CONTAINER_NAME=$1; echo KIBANA_CONTAINER_NAME=$KIBANA_CONTAINER_NAME
	KIBANA_PORT=$2; echo KIBANA_PORT=$KIBANA_PORT
	YML_KIBANA_TEMPLATE=kibana.yml; echo YML_KIBANA_TEMPLATE=$YML_KIBANA_TEMPLATE
	YML_KIBANA_FILE=$KIBANA_CONTAINER_NAME.$YML_KIBANA_TEMPLATE; echo YML_KIBANA_FILE=$YML_KIBANA_FILE
        echo
	cp $YML_KIBANA_TEMPLATE $YML_KIBANA_FILE
	insertParameter $YML_KIBANA_FILE %ES_HTTP_URL% $ES_HTTP_URL
	insertParameter $YML_KIBANA_FILE %KIBANA_HTTP_PORT% $KIBANA_PORT	
	docker run \
		-v $(pwd)/$YML_KIBANA_FILE:/usr/share/kibana/config/kibana.yml	 \
		--name $KIBANA_CONTAINER_NAME \
		--network elk_network \
		-p $KIBANA_PORT:$KIBANA_PORT \
		docker.elastic.co/kibana/kibana:6.7.1
# -p $2:5601 \
#--link $elasticsearch_container_id:elasticsearch \
}
echo "#####################################################"
echo "##############         KIBANA            ############"
echo "#####################################################"

case $1 in
	run)
		if [ -z "$2" ]
		then
			echo "Can't find a name of Kibana's instance. Specify the name of Kibana instance in the first parameter. For example:"
			echo "# $0 run kibanatest 5601 http://elasdticsearchtest:9200"
			exit 1
		fi
		if [ -z "$3" ]
			then
				echo "Can't find a port number of Kibana's instance. Specify the port number of Kibana's instance in the second parameter. For example:"
				echo "# $0 run kibanatest 5601 http://elasdticsearchtest:9200"
			exit 1
			fi
		if [ -z "$4" ]
			then
				echo "Can't find an HTTP URL of ES's instance. Specify the HTTP URL of ES instance in the third parameter. For example:"
				echo "# $0 run kibanatest 5601 http://elasdticsearchtest:9200"
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


