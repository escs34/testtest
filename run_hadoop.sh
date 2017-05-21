#! /bin/bash
NETWORK=$1

MASTER_COMMAND="sudo docker run -it --name spark-client --network $1 --ip 10.0.2.48 -p 22022:22 --add-host=master:10.0.2.2 --cpu-shares 1024 --memory 12g"
COMMAND_LAST="kmubigdata/ubuntu-spark /bin/bash"

MASTER_COMMAND="$MASTER_COMMAND $COMMAND_LAST"

$MASTER_COMMAND