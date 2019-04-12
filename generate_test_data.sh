while [ 1=1 ]; 
	do _time=$(date '+%Y:%m:%d %H:%M:%S'); 
	echo "$_time test sentence T=$RANDOM" >> /opt/docker_volumes/filebeat_vol/log_for_filebeat.log; 
	sleep 1; 
done;
