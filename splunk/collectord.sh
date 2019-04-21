#!/bin/bash
# https://www.outcoldsolutions.com/docs/monitoring-docker/v5/installation/
source ../lib/management_scripts.sh
container_name=collectorfordocker
image_name=outcoldsolutions/collectorfordocker

function getContainerId(){
        pid=$(docker container ls -a | grep $container_name | awk {'print $1'})
        echo $pid
}

function stop(){
        pid=$(getContainerId)
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

function run(){
	
	echo "Running container [$container_name] from image [$image_name] "
	license=$1
	hec_token=$2
	if [ -z "$license" ]
	then
		echo "Can't find license of collectd. Example:"
		echo "# $0 license_value "
		return	
	else
		echo "License is [$license]"
	fi
	if [ -z "$hec_token" ]
        then
                echo "Can't find hec_token of splunk"
                return
        else
                echo "HEC token is [$hec_token]"
        fi
		docker run -d \
    		--name $container_name \
		--network common_network\
    		--volume /sys/fs/cgroup:/rootfs/sys/fs/cgroup:ro \
    		--volume /proc:/rootfs/proc:ro \
    		--volume /var/log:/rootfs/var/log:ro \
    		--volume /var/lib/docker/:/rootfs/var/lib/docker/:ro \
    		--volume /var/run/docker.sock:/rootfs/var/run/docker.sock:ro \
    		--volume collector_data:/data/ \
    		--cpus=1 \
    		--cpu-shares=204 \
    		--memory=256M \
    		--restart=always \
    		--env "COLLECTOR__SPLUNK_URL=output.splunk__url=https://splunk:8088/services/collector/event/1.0" \
    		--env "COLLECTOR__SPLUNK_TOKEN=output.splunk__token=$hec_token"  \
    		--env "COLLECTOR__SPLUNK_INSECURE=output.splunk__insecure=true"  \
    		--env "COLLECTOR__EULA=general__acceptEULA=true" \
    		--env "COLLECTOR__LICENSE=general__license=$license" \
    		--privileged \
    		$image_name:5.7.220
}

function logs(){
        docker logs $(getContainerId)
}

function shell(){
        docker exec -it $(getContainerId) /bin/bash
}

case $1 in
        run)
        	run ${@:2} 
        ;;
        stop)
        stop
        ;;
        stopAndRun)
        stop
        start
        ;;
        suspend)
        suspend $container_name
        ;;
        unsuspend)
        unsuspend $container_name
        ;;
        restart)
        restart $container_name
        ;;
        logs)
        logs
        ;;
        shell)
        shell
        ;;
        *)
        printf "Commands are:\n"
	printf "run- \n"
        printf "stopAndRun- \n"
        printf "stop - \n"
        printf "restart - \n"
        printf "logs - \n"
        printf "shell - \n"
	printf "pause - \n"
        printf "unpause - \n"
	echo "run <license> <splunk_hec_token>"
        ;;
esac

