#!/bin/bash
mkdir /usr/lib/jvm
tar -zxvf jre-7u51-linux-x64.gz -C /usr/lib/jvm
update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jre1.7.0_51/bin/java" 1
update-alternatives --set java /usr/lib/jvm/jre1.7.0_51/bin/java
java -version

# get Java Native Access (JNA)
apt-get -y -f install libjna-java
