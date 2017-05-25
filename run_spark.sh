#! /bin/bash

sudo docker run -dit --name spark-client --network spark-net -p 22006:22 --add-host=master:10.0.2.2 --cpu-shares 1024 --memory 12g kmubigdata/ubuntu-spark /bin/bash
