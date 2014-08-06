#!/usr/bin/env bash
cd $(dirname $0)
docker build --rm=true --force-rm=true -t cassandrad/cassandra:c209ubuntu1404 .
