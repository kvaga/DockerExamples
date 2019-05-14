#!/bin/bash
source ../lib/management_scripts.sh

function prepareYmlConfig(){
	echo "Preparing yml config file for the logstash instance..."
	if [ -z "$1" ]
        then
                echo "Yml config file name is empty for the logstash instance"
                exit 1
        fi
	if [ -z "$2" ]
        then
                echo "ES_URL is empty"
                exit 1
        fi
	YML_CONFIG=$1
	ES_URL=$2
	echo "xpack.monitoring.elasticsearch.hosts: $ES_URL" > $YML_CONFIG
	echo "xpack.monitoring.enabled: true" >> $YML_CONFIG
	echo "Yml file is ready:"
	cat $YML_CONFIG
}
prepareConfig(){
	echo "Preparing config file for the logstash instance..."
        TEMPLATE_CONFIG=logstash.conf.template; echo TEMPLATE_CONFIG=$TEMPLATE_CONFIG
	CONFIG_FILE_NAME=$1; echo CONFIG_FILE_NAME=$CONFIG_FILE_NAME
	ES_URL=$2; echo ES_URL=$ES_URL
	LOGSTASH_INPUT_BEATS_PORT=$3; echo LOGSTASH_INPUT_BEATS_PORT=$LOGSTASH_INPUT_BEATS_PORT
	if [ -z "$CONFIG_FILE_NAME" ]
        then
                echo "Config file name is empty for the logstash instance"
                exit 1
        fi
	if [ -z "$ES_URL" ]
        then
                echo "ES URL is empty. Specify ES URL instance"
                exit 1
        fi
	if [ -z "$LOGSTASH_INPUT_BEATS_PORT" ]
        then
                echo "LOGSTASH_INPUT_BEATS_PORT is empty. Specify LOGSTASH_INPUT_BEATS_PORT"
                exit 1
        fi

	echo "" > $CONFIG_FILE_NAME
	echo "input {" >> $CONFIG_FILE_NAME
  	echo "	beats {" >> $CONFIG_FILE_NAME
    	echo "		port => $LOGSTASH_INPUT_BEATS_PORT" >> $CONFIG_FILE_NAME
    	echo "		host => \"0.0.0.0\"" >> $CONFIG_FILE_NAME
  	echo "	}" >> $CONFIG_FILE_NAME
	echo "}" >> $CONFIG_FILE_NAME

	cat $TEMPLATE_CONFIG >> $CONFIG_FILE_NAME
	echo "" >> $CONFIG_FILE_NAME
	echo "output {" >> $CONFIG_FILE_NAME
  	echo "	elasticsearch {" >> $CONFIG_FILE_NAME
    	echo "		hosts => [\"$ES_URL\"]" >> $CONFIG_FILE_NAME
    	echo "		manage_template => false" >> $CONFIG_FILE_NAME
   	echo "		index => \"%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}\"" >> $CONFIG_FILE_NAME
  	echo "	}" >> $CONFIG_FILE_NAME
	echo "}" >> $CONFIG_FILE_NAME
	echo "Content of the [$CONFIG_FILE_NAME] is:"
	cat $CONFIG_FILE_NAME
	echo ""
}

function run(){
	echo "Starting logstash container..."
	echo "Parameters:"
	LOGSTASH_INSTANCE_NAME=$1; echo LOGSTASH_INSTANCE_NAME=$LOGSTASH_INSTANCE_NAME
	YML_LOGSTASH_CONFIG=$1.logstash.yml; echo YML_LOGSTASH_CONFIG=$YML_LOGSTASH_CONFIG
	LOGSTASH_CONFIG=$1.logstash.conf
	ES_URL=$4; echo ES_URL=$ES_URL
	echo 
	prepareYmlConfig $YML_LOGSTASH_CONFIG $ES_URL 
	prepareConfig $LOGSTASH_CONFIG $ES_URL $3
	docker run --name $LOGSTASH_INSTANCE_NAME \
	-i \
 	-v $(pwd)/$YML_LOGSTASH_CONFIG:/usr/share/logstash/config/logstash.yml \
    	-v $(pwd)/$LOGSTASH_CONFIG:/usr/share/logstash/config/logstash.conf \
	-p $2:$2 \
	-p $3:$3 \
	--network elk_network \
	docker.elastic.co/logstash/logstash:6.7.1 -f /usr/share/logstash/config/logstash.conf --config.reload.automatic
	echo
#       -v ~/DockerExamples/logstash-filter.conf:/usr/share/logstash/config/logstash-filter.conf \
#	 -e 'output { elasticsearch { hosts => "${ES_URL}" } }' \
#  -p $2:9600 \
#  -p $3:5044 \

}
echo "#####################################################"
echo "###############        LOGSTASH          ############"
echo "#####################################################"
case $1 in
	run)
	if [ -z "$2" ]
	then
		echo "Can't find a name of Logstash's instance. Specify the name of Logstash instance in the first parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
		exit 1
	fi
	if [ -z "$3" ]
	then
		echo "Can't find a port number of Logstash's instance. Specify the port number of Logstash's instance in the second parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
		exit 1
	fi
	if [ -z "$4" ]
	then
		echo "Can't find a management port number of Logstash's instance. Specify the management port number of Logstash's instance in the third parameter. For example:"
		echo "# $0 run logstash_043 9600 5044"
		exit 1
	fi
	if [ -z "$5" ]
        then
                echo "Can't find the URL of the ES instance. Specify the URL in the fourth parameter. For example:"
                echo "# $0 run logstash_043 9600 5044 http://elasticsearch:9200"
                exit 1
        fi
		run ${@:2}
	;;
	stop)
	stop $2
	;;
	stopAndRun)
	stop $2
	run $2
	;;
	pause)
	pause $2
	;;
	unpause)
	unpause $2
	;;
	restart)
	restart $2
	;;
	logs)
	logs $2
	;;
	shell)
	shell $2
	;;
	*)
	printf "Commands are:\n"
	printf "run - \n"
	printf "stop - \n"
	printf "stopAndRun - \n"
	printf "logs - \n"
	printf "shell - \n"
	printf "pause - \n"
	printf "unpause - \n"
	printf "restart - \n"
	;;
esac

