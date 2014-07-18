# Cassandra 
#
# VERSION               1.0

FROM ubuntu:trusty
MAINTAINER Nisan Haramati hanisan@gmail.com

# Install nano and locate because I don't want to have to manually install it.
RUN apt-get -y -f install nano locate

ADD src /tmp/src
RUN mkdir -p /usr/lib/jvm
RUN tar -zxvf /tmp/src/jre-7u51-linux-x64.gz -C /usr/lib/jvm
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.7.0_51/bin/java" 1
RUN update-alternatives --set java /usr/lib/jvm/jre1.7.0_51/bin/java

# get Java Native Access (JNA)
RUN apt-get -y -f install libjna-java

# Install datastax repo
RUN cp /tmp/src/datastax.community.list /etc/apt/sources.list.d/datastax.community.list
RUN apt-key add /tmp/src/debian.datastax.com.pgp
RUN apt-get update

# install cassandra in stopped state
RUN apt-get -y -f install cassandra=2.0.9
RUN service cassandra stop

# install agent in stopped state
RUN apt-get -y -f install datastax-agent=4.1.4
RUN service datastax-agent stop

# install supervisord & sysstat & openssh-server
RUN apt-get -y -f install supervisor
RUN mkdir -p /var/log/supervisor
RUN apt-get -y -f install sysstat
RUN apt-get -y -f install openssh-server
RUN mkdir -p /var/run/sshd

# Configure SSH server
RUN mkdir -p /var/run/sshd && chmod -rx /var/run/sshd
# remove old hosts file if its there
RUN rm -fr /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t rsa -N '' -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Create OpsCenter account
RUN useradd -m -G users,root -s /bin/bash opscenter
RUN echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Configure supervisord
ADD src/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Deploy startup script
ADD src/start.sh /usr/local/bin/start

# Necessary since cassandra try to override the system limitations
# See https://groups.google.com/forum/#!msg/docker-dev/8TM_jLGpRKU/dewIQhcs7oAJ
RUN rm -f /etc/security/limits.d/cassandra.conf
# Necassary to make df tool run correctly
# See https://groups.google.com/d/msg/docker-user/zC_wX1Uyl_U/Q5Ex5kg1VQ0J
#RUN ln -s /proc/mounts /etc/mtab

## Cassandra ports
# JMX: 7199 cassandra-env.sh
EXPOSE 7199
# storage_port: 7000 cassandra.yaml
EXPOSE 7000
# ssl_storage_port: 7001 cassandra.yaml
EXPOSE 7001
# rpc_port: 9160 cassandra.yaml
EXPOSE 9160
# native_transport_port: 9042 cassandra.yaml
EXPOSE 9042
## datastax-agent (opscenter agent)
# ssh port: 22 opscenerd.conf
EXPOSE 22
# hadoop job tracker thrift port: 8012
EXPOSE 8012
# datastax agent port: 61621
EXPOSE 61621

## start sequence
USER root 
CMD start
