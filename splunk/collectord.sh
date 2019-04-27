#!/bin/bash
# https://www.outcoldsolutions.com/docs/monitoring-docker/v5/installation/
source ../lib/management_scripts.sh
IMAGE_NAME=outcoldsolutions/collectorfordocker
function show_commandline_parameters_run(){
 	echo "Example of commandline parameters for the run command:"
        echo "# $0 run collectorfordocker <license string> splunkhost <hec token hash>"	
}
function run(){
	
	echo "Running container [$1] from image [$IMAGE_NAME] "
	container_name=$1
	license=$2
	splunk_host_name=$3
	hec_token=$4
	if [ -z "$container_name" ]
        then
                echo "Can't find collectorfordocker container name"
                show_commandline_parameters_run
                exit 1
        fi
	if [ -z "$splunk_host_name" ]
        then
                echo "Can't find splunk's host name"
                show_commandline_parameters_run
                exit 1
        fi

	if [ -z "$license" ]
	then
		echo "Can't find license of collectd"
		show_commandline_parameters_run
		exit 1
	fi
	if [ -z "$hec_token" ]
        then
                echo "Can't find hec_token of splunk"
		show_commandline_parameters_run
		exit 1
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
    		--env "COLLECTOR__SPLUNK_URL=output.splunk__url=https://$splunk_host_name:8088/services/collector/event/1.0" \
    		--env "COLLECTOR__SPLUNK_TOKEN=output.splunk__token=$hec_token"  \
    		--env "COLLECTOR__SPLUNK_INSECURE=output.splunk__insecure=true"  \
    		--env "COLLECTOR__EULA=general__acceptEULA=true" \
    		--env "COLLECTOR__LICENSE=general__license=$license" \
    		--privileged \
    		$IMAGE_NAME:5.7.220
}



case $1 in
        run)
        	run ${@:2} 
        ;;
        stop)
        stop $1
        ;;
        stopAndRun)
        stop $1
        run $1
        ;;
        suspend)
        suspend $1
        ;;
        unsuspend)
        unsuspend $1
        ;;
        restart)
        restart $1
        ;;
        logs)
        logs $1
        ;;
        shell)
        shell $1
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
	echo "run "
        ;;
esac

