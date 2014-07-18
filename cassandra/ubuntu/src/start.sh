#!/usr/bin/env bash

# change ownership to cassandra on the configs, volumes, and logs
chown -R cassandra:cassandra /var/lib/cassandra
chown -R cassandra:cassandra /etc/cassandra
chown -R cassandra:cassandra /var/log/cassandra


# start supervisord which will start cassandra
/usr/bin/supervisord