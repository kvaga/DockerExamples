#!/bin/bash
source ../lib/management_scripts.sh
container_name=splunk
image_name=splunk/splunk

function getContainerId(){
        pid=$(docker container ls -a | grep $container_name | awk {'print $1'})
        echo $pid
}

function stop(){
        pid=$(getContainerId)
        if [ -z "$pid" ]
        then
                        echo "Couldn't find container id in the containers list"
        else
                        echo "Container ID: $pid"
                        echo "Stopping container [$pid]..."
                        docker container stop $pid
                        echo "Removing container [$pid]..."
                        docker container rm $pid
        fi
}

function run(){
	echo "Running container [$container_name]  from image [$image_name] with password [$1]"
	docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=$1" --name $container_name \
	--network common_network\
	$image_name:latest
}

function logs(){
        docker logs $(getContainerId)
}

function shell(){
        docker exec -it $(getContainerId) /bin/bash
}

function check_hec(){
	"Checking HEC [$1]"
	if [ -z "$1" ]
        then
                echo "You must specify a HEC hash value"
		return
        fi
	curl -k https://$container_name:8089/services/collector/event/1.0 -H "Authorization: Splunk $1" -d '{"event": "hello world"}'
}
case $1 in
        run)
	if [ -z "$2" ]
	then
		echo "You must specify a password for the newly created splunk instance"
		echo "For example:"
		echo "# $0 run secret"
	else	
        	run $2 
	fi
        ;;
        stop)
        stop
        ;;
        stopAndRun)
        stop
        start
        ;;
        suspend)
        suspend $container_name
        ;;
        unsuspend)
        unsuspend $container_name
        ;;
        restart)
        restart $container_name
        ;;
        logs)
        logs
        ;;
        shell)
        shell
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

