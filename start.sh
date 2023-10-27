#!/bin/bash

pid=$(cat skynet.pid);

if [[ $pid != "" ]]; then
   	kill -2 $pid
	while kill -0 "$pid" 2>/dev/null; do
	    sleep 0.1
	done
fi;

# start
export ROOT=$(cd `dirname $0`;pwd)

export DAEMON=false

echo $ROOT

cd `dirname $0`
./skynet/skynet config