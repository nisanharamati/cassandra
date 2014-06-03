# Cassandra 
#
# VERSION               1.0

FROM ubuntu:trust
MAINTAINER Nisan Haramati hanisan@gmail.com

ADD src/jre-7u51-linux-x64.gz /tmp/jre-7u51-linux-x64.gz
RUN mkdir /usr/lib/jvm
RUN tar -zxvf /tmp/jre-7u51-linux-x64.gz -C /usr/lib/jvm
RUN update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.7.0_51/bin/java" 1
RUN update-alternatives --set java /usr/lib/jvm/jre1.7.0_51/bin/java

# get Java Native Access (JNA)
apt-get -y -f install libjna-java

# Install datastax OpsCenter
ADD src/datastax.community.list /etc/apt/sources.list.d/datastax.community.list
ADD src/debian.datastax.com.pgp /var/datastax/debian.datastax.com.pgp
RUN apt-key add /var/datastax/debian.datastax.com.pgp
RUN apt-get update

# install supervisord
RUN apt-get -y -f install supervisor

# install monitoring tools
RUN apt-get -y -f install dsc20
RUN apt-get -y -f install sysstat

# Configure SSH server
RUN mkdir -p /var/run/sshd && chmod -rx /var/run/sshd
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
