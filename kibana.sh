#!/bin/bash


function getContainerId(){
        pid=$(docker container ls -a | grep /kibana/kibana | awk {'print $1'})
        echo $pid
}
 function getESContainerId(){
	pidES=$(docker container ls -a | grep /elasticsearch/elasticsearch | awk {'print $1'})
	echo $pidES
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
	elasticsearch_container_id=$(getESContainerId)
        echo "Starting Kibana for ES [$elasticsearch_container_id]"
        docker run \
		--link $elasticsearch_container_id:elasticsearch \
		--rm \
		--name kibana \
		--network elk_network \
		-p 5601:5601 \
		docker.elastic.co/kibana/kibana:6.7.1
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


