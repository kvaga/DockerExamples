#!/bin/bash
source ../lib/management_scripts.sh

function run(){
	echo "Starting logstash container"
	docker run --name $1 \
	-i \
	-v $(pwd)/logstash.yml:/usr/share/logstash/config/logstash.yml \
    -v $(pwd)/logstash.conf:/usr/share/logstash/config/logstash.conf \
	-p $2:$2 -p $3:$3 \
	--network elk_network \
	docker.elastic.co/logstash/logstash:6.7.1 -f /usr/share/logstash/config/logstash.conf --config.reload.automatic
	echo
#       -v ~/DockerExamples/logstash-filter.conf:/usr/share/logstash/config/logstash-filter.conf \
}
echo "#####################################################"
echo "###############        LOGSTASH          ############"
echo "#####################################################"
case $1 in
	run)
	if [ -z "$2" ]
	then
		echo "Can't find a name of Logstash's instance. Specify the name of Logstash instance in the first parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
		exit 1
	fi
	if [ -z "$3" ]
	then
		echo "Can't find a port number of Logstash's instance. Specify the port number of Logstash's instance in the second parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
		exit 1
	fi
	if [ -z "$4" ]
	then
		echo "Can't find a management port number of Logstash's instance. Specify the management port number of Logstash's instance in the second parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
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

