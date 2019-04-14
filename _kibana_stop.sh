echo "Getting Kibana's container id..."
kibana_container_id=$(docker container ls -a | grep /kibana/kibana | awk {'print $1'})
if [ -z "$kibana_container_id" ]
then
	echo "Kibana is not found"	
else
	echo "Kibana's container id [$kibana_container_id]"
	echo "Stopping Kibana for id [$kibana_container_id]"
	docker container stop $kibana_container_id
	echo "Removing Kibana's container id [$kibana_container_id]"
	docker container rm $kibana_container_id
fi
