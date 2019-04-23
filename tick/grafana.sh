#!/bin/bash
# https://grafana.com/docs/installation/docker/
# All options defined in conf/grafana.ini can be overridden using environment variables by using the syntax GF_<SectionName>_<KeyName>
source ../lib/management_scripts.sh
default_container_name=grafana

function run(){
	echo "Running grafana instance with [$1] name, [$2] password and [$3] port number"
	docker run \
  	-d \
	-p $3:$3 \
  	--name=$1 \
  	-e "GF_SERVER_ROOT_URL=http://$1" \
  	-e "GF_SECURITY_ADMIN_PASSWORD=$2" \
  	grafana/grafana
}
echo "#####################################################"
echo "###############        GRAFANA           ############"
echo "#####################################################"
case $1 in
        run)
	if [ -z "$2" ]
	then
		echo "Can't find a name of grafana's instance. Specify the name of grafana instance in the first parameter. For example:"
		echo "# $0 run grafana_043 secret 3000"
		exit 1
	fi
	if [ -z "$3" ]
        then
                echo "Can't find a password of grafana's instance. Specify the password of grafana instance in the second parameter. For example:"
                echo "# $0 run grafana_043 secret 3000"
		exit 1
        fi
	if [ -z "$4" ]
        then
                echo "Can't find a port number of grafana's instance. Specify the port number of grafana instance in the first parameter. For example:"
                echo "# $0 run grafana_043 secret 3000"
		exit 1
        fi
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
        ;;

esac


