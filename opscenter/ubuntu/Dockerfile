# OpsCenter
#
# VERSION		1.0

FROM ubuntu:trusty
MAINTAINER nisan haramati gh:nisanharamati

# Install datastax OpsCenter
ADD src/datastax.community.list /etc/apt/sources.list.d/datastax.community.list
ADD src/debian.datastax.com.pgp /var/opscenter/debian.datastax.com.pgp
RUN apt-key add /var/opscenter/debian.datastax.com.pgp
RUN apt-get update

RUN apt-get install -y opscenter 

ADD src/start.sh /usr/local/bin/start

# See http://www.datastax.com/documentation/opscenter/4.0/opsc/reference/opscPorts_r.html
EXPOSE 8888 61620 50031
USER root 
CMD start 
