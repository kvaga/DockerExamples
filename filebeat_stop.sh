echo "Getting container ID..."
pid=$(cat filebeat.pid)

echo "Container ID: $pid"
echo "Stopping container [$pid]..."
docker container stop $pid

echo "Removing container [$pid]..."
docker container rm $pid 
