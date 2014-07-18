#!/usr/bin/env bash
cd $(dirname $0)
docker build -t cassandrad/cassandra:c209ubuntu1404 .
