# ubuntu-spark

ubuntu 16.04 hadoop 3.1.1 spark 2.4.0

```bash
$ sudo docker run -dit --name [spark-container-name] --network [network-hadoop-container-used] [image-name] /bin/bash
```
or
```bash
$ ./run_spark.sh
```
if `./run_spark.sh` fails with Permission denied error,
```bash
# chmod +x run_spark.sh
```


### run container
```
$ docker exec -it [spark-container-name] bash
```

### run spark-shell in client mode
```bash
# spark-shell --master yarn --deploy-mode client
```
or
```bash
# cd /usr/local/spark/
# chmod +x run-sparkshell.sh
# ./run-sparkshell.sh
```
