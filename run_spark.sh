#! /bin/bash

sudo docker run -it --name spark-client --network spark-net --ip 10.0.2.49 -p 22006:22006 --add-host=master:10.0.2.2 --cpu-shares 1024 --memory 12g kmubigdata/ubuntu-spark /bin/bash