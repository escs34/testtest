#! /bin/bash

sudo docker run -dit --name $2 --network $1 hadoop-spark /bin/bash
