#docker run --link 87368152042f:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:6.7.1
docker run --link 8b9943a50720:elasticsearch --rm --name kibana --network elk_network -p 5601:5601 docker.elastic.co/kibana/kibana:6.7.1

