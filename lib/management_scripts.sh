#!/bin/bash

function suspend(){
	echo "Suspending container [$1]..."
	docker container pause $1
}
function unsuspend(){
	echo "Unsuspending container [$1]..."
	docker container unpause $1
}
function restart(){
	echo "Restarting container [$1]..."
	docker container restart $1
}

function getContainerId(){
	#echo "Getting container id for [$1]..."
        pid=$(docker container ls -a | grep $1 | awk {'print $1'})
        #echo "Container id for [$1] is [$pid]
	echo $pid
}

function stop(){
	echo "Stopping container for [$1]..." 
        pid=$1
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


function logs(){
        docker logs $(getContainerId)
}


function shell(){
        docker exec -it $(getContainerId) /bin/bash
}
function status(){
	docker container ls | grep $1
}
