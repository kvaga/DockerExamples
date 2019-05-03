#!/bin/bash
source ../lib/management_scripts.sh
SPLUNK_CONTAINER_NAME=splunk
SPLUNK_PWD=$(cat /tmp/splunk.pwd)
SPLUNK_PORT=8000
SPLUNK_HEC=$(cat /tmp/splunk_HEC.token)
COLLECTORD_CONTAINER_NAME=collectorfordocker
COLLECTORD_LICENSE=$(cat /tmp/collectord.license)

function runAll(){
	../network_common_setup.sh 	
	./splunk.sh run $SPLUNK_CONTAINER_NAME $SPLUNK_PWD $SPLUNK_PORT&
	./collectord.sh run $COLLECTORD_CONTAINER_NAME $COLLECTORD_LICENSE $SPLUNK_CONTAINER_NAME $SPLUNK_HEC&
}
function stopAll(){
	stop $SPLUNK_CONTAINER_NAME 
	stop $COLLECTORD_CONTAINER_NAME
}	
case $1 in
        runAll)
        runAll
        ;;
        stopAll)
        stopAll
        ;;
        suspendAll)
        suspend $COLLECTORD_CONTAINER_NAME
	suspend $SPLUNK_CONTAINER_NAME
        ;;
        unsuspendAll)
        unsuspend $COLLECTORD_CONTAINER_NAME
	unsuspend $SPLUNK_CONTAINER_NAME
        ;;
        restartAll)
        restart $SPLUNK_CONTAINER_NAME
	restart $COLLECTORD_CONTAINER_NAME
        ;;
	statusAll)
	status $SPLUNK_CONTAINER_NAME
	status $COLLECTORD_CONTAINER_NAME
	;;
        *)
        printf "Commands are:\n"
        printf "runAll- \n"
        printf "stopAll - \n"
        printf "restartAll - \n"
	echo "suspendAll -"
	echo "unsuspendAll -"
	echo "statusAll - "


esac
