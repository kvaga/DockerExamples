#!/bin/bash


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

function start(){
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
        start)
        start
        ;;

        stop)
        stop
        ;;

        restart)
        stop
        start
        ;;

        logs)
        logs
        ;;
        shell)
        shell
        ;;
        *)
	printf "Commands are:\n"
        printf "start - \n"
        printf "stop - \n"
        printf "restart - \n"
        printf "logs - \n "
        printf "shell - \n"

        ;;

esac


