#!/bin/bash
#https://github.com/openshift/origin/blob/master/examples/sample-app/container-setup.md
#Note that this won't hold any data after a restart, so you'll need to use a data container or mount a volume at /var/lib/openshift to preserve that data. For example, create a /var/lib/openshift folder on your Docker host, and then start origin with the following:
#
#$ docker run -d --name "openshift-origin" --net=host --privileged \
#-v /var/run/docker.sock:/var/run/docker.sock \
#-v /var/lib/openshift:/var/lib/openshift \
#openshift/origin start
