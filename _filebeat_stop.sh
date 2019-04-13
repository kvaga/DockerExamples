echo "Getting container ID from the pid file..."
pid=$(cat filebeat.pid)
if [ -z "$pid" ]
then 
	echo "Couldn't find container id in the pid file"

else
	echo "Container ID: $pid"
        echo "Stopping container [$pid]..."
        docker container stop $pid
        echo "Removing container [$pid]..."
        docker container rm $pid
fi
pid=$(docker container ls -a | grep /beats/filebeat | awk {'print $1'})
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
