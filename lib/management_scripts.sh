#!/bin/bash

function pause(){
	echo "Suspending container [$1]..."
	docker container pause $1
}
function unpause(){
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

function createNetwirk(){
	NETWORK_NAME=$1
	if [ -z "$NETWORK_NAME" ]
	then
		echo "Network name is empty"
		exit 1
	fi
	docker network create $NETWORK_NAME
	docker network list
	docker network inspect $NETWORK_NAME
}
function logs(){
        docker logs $(getContainerId $1)
}


function shell(){
        docker exec -it $(getContainerId $1) /bin/bash
}
function status(){
	docker container ls | grep $1
}
function insertParameter(){
	FILE=$1
	FROM=$2
	TO=$3
	echo sed -i -e "s/$FROM/$TO/" $FILE
	sed -i -e "s,$FROM,$TO,g" $FILE
}
