#!/usr/bin/env bash
cd $(dirname $0)
docker build -t cassandrad/opscenter:500ubuntu1404 .
