docker run --rm -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" --rm --name elasticsearch --network elk_network docker.elastic.co/elasticsearch/elasticsearch:6.7.1

