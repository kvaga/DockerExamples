
echo "Getting ES container ID..."
elasticsearch_container_id=$(docker container ls -a | grep /elasticsearch/elasticsearch | awk {'print $1'})
if [ -z "$elasticsearch_container_id" ]
then
	echo "ES container id is not found" 
else
	echo "ES container ID [$elasticsearch_container_id]"
	#docker run --link 87368152042f:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:6.7.1
	echo "Starting Kibana for ES [$elasticsearch_container_id]"
	docker run --link $elasticsearch_container_id:elasticsearch --rm --name kibana --network elk_network -p 5601:5601 docker.elastic.co/kibana/kibana:6.7.1
fi

