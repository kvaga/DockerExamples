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

function run(){
        echo "Starting elasticsearch container"
        docker run \
		-p $2:$2 -p $3:$3 \
		-e "discovery.type=single-node" \
		--name $1 \
		--network elk_network \
		docker.elastic.co/elasticsearch/elasticsearch:6.7.1
        echo
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
				echo "Can't find a port number of ES's instance. Specify the port number of ES's instance in the second parameter. For example:"
				echo "# $0 run elasticsearch_043 9200 9300"
			exit 1
			fi
		if [ -z "$4" ]
			then
					echo "Can't find a management port number of ES's instance. Specify the management port number of ES's instance in the third parameter. For example:"
					echo "# $0 run elasticsearch_043 9200 9300"
			exit 1
		fi
		run ${@:2}
	;;
	stop)
	stop $1
	;;
	stopAndRun)
	stop $1
	run $1
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


