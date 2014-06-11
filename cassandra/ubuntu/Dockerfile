# Cassandra 
#
# VERSION               1.0

FROM ubuntu:trusty
MAINTAINER Nisan Haramati hanisan@gmail.com

ADD src /tmp/src
RUN mkdir -p /usr/lib/jvm
RUN tar -zxvf /tmp/src/jre-7u51-linux-x64.gz -C /usr/lib/jvm
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.7.0_51/bin/java" 1
RUN update-alternatives --set java /usr/lib/jvm/jre1.7.0_51/bin/java

# get Java Native Access (JNA)
RUN apt-get -y -f install libjna-java

# Install datastax OpsCenter
RUN cp /tmp/src/datastax.community.list /etc/apt/sources.list.d/datastax.community.list
RUN apt-key add /tmp/src/debian.datastax.com.pgp
RUN apt-get update

# install cassandra in stopped state
RUN apt-get -y -f install dsc20
RUN service cassandra stop

# install agent in stopped state
RUN apt-get -y -f install datastax-agent
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
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Create OpsCenter account
RUN useradd -m -G users,root -p $(openssl passwd -1 "opscenter") opscenter
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
RUN ln -s /proc/mounts /etc/mtab

EXPOSE 7199 7000 7001 9160 9042
EXPOSE 22 8012 61621
USER root 
CMD start
