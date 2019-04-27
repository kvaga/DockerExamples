#!/bin/bash
source ../lib/management_scripts.sh
IMAGE_NAME=splunk/splunk

function run(){
	echo "Running container [$1]  from image [$IMAGE_NAME] with password [$1]"
	docker run -d -p $3:$3 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=$2" --name $1 \
	--network common_network\
	$IMAGE_NAME:latest
}

function check_hec(){
	"Checking HEC [$1]"
	if [ -z "$1" ]
        then
                echo "You must specify a HEC hash value"
		exit 1
        fi
	curl -k https://$container_name:8089/services/collector/event/1.0 -H "Authorization: Splunk $1" -d '{"event": "hello world"}'
}
function show_commandline_parameters_run(){
	echo "Example of commandline parameters for the run command:"
	echo "# $0 run splunk secret 8000"
}
case $1 in
        run)
	 if [ -z "$2" ]
        then
                echo "You must specify a name of splunk's container name for the newly created splunk instance"
                show_commandline_parameters_run
                exit 1
        fi

	if [ -z "$3" ]
	then
		echo "You must specify a password for the newly created splunk instance"
		show_commandline_parameters_run
		exit 1
	fi
	if [ -z "$4" ]
        then
                echo "You must specify a port number for the newly created splunk instance"
		show_commandline_parameters_run
                exit 1
        fi
	
	run ${@:2}
        ;;
        stop)
        stop $1
        ;;
        stopAndRun)
        stop $1
        run ${@:2}
        ;;
        suspend)
        suspend $1
        ;;
        unsuspend)
        unsuspend $1
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
	check_hec)
	check_hec ${@:2}
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
	echo "check_hec <HEC_hash_value>"
        ;;
esac

