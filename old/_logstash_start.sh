docker run --name logstash --rm -it -v ~/DockerExamples/logstash.yml:/usr/share/logstash/config/logstash.yml -p 9600:9600 -p 5044:5044 --network elk_network docker.elastic.co/logstash/logstash:6.7.1
