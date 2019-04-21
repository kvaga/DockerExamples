#!/bin/bash
# https://grafana.com/docs/installation/docker/
# All options defined in conf/grafana.ini can be overridden using environment variables by using the syntax GF_<SectionName>_<KeyName>
source ../lib/management_scripts.sh
container_name=grafana

function getContainerId(){
        pid=$(docker container ls -a | grep /$container_name/$container_name | awk {'print $1'})
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
	docker run \
  	-d \
  	-p 3000:3000 \
  	--name=$container_name \
  	-e "GF_SERVER_ROOT_URL=http://$container_name" \
  	-e "GF_SECURITY_ADMIN_PASSWORD=$1" \
  	grafana/grafana
}


function logs(){
        docker logs $(getContainerId)
}


function shell(){
        docker exec -it $(getContainerId) /bin/bash
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


