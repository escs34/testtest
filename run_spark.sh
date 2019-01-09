#! /bin/bash

sudo docker run -dit --name $1 --network test-net hadoop-spark /bin/bash
