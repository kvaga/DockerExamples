#!/bin/bash

container_name=elasticsearch
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
        pid=$(docker container ls -a | grep /elasticsearch/elasticsearch | awk {'print $1'})
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
        echo "Starting elasticsearch container"
        docker run --rm \
		-p 9200:9200 -p 9300:9300 \
		-e "discovery.type=single-node" \
		--name elasticsearch \
		--network elk_network \
		docker.elastic.co/elasticsearch/elasticsearch:6.7.1
        echo
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
        run
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


