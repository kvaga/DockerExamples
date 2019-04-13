# Pull image 
# docker pull docker.elastic.co/beats/filebeat:6.7.1

# run container
#docker run \
#--rm --name filebeat --network elk_network \
#docker.elastic.co/beats/filebeat:6.7.1 \
#setup -E setup.kibana.host=kibana:5601 \
#-E output.elasticsearch.hosts=["elasticsearch:9200"]

echo "Starting filebeat container"
docker run -d \
  --name=filebeat \
  --user=root \
  --network elk_network \
  --volume="$(pwd)/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml:ro" \
  --volume="/var/lib/docker/containers:/var/lib/docker/containers:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --mount type=volume,dst=/opt/elk_filebeat_vol,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=/opt/docker_volumes/filebeat_vol/ \
  docker.elastic.co/beats/filebeat:6.7.1 filebeat -e -strict.perms=false \
  -E output.elasticsearch.hosts=["elasticsearch:9200"] > filebeat.pid
echo 
