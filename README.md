# ubuntu-spark

ubuntu 16.04 hadoop 3.1.1 spark 2.4.0

```bash
$ sudo docker run -dit --name [spark-container-name] --network [network-hadoop-container-used] [image-name] /bin/bash
```
or
```bash
$ ./run_spark.sh [spark-container-name]
```
if `./run_spark.sh` fails with Permission denied error,
```bash
# chmod +x run_spark.sh
```
<br/>

### run container
```
$ docker exec -it [spark-container-name] bash
```
<br/>

spark-jars.zip이 만들어지고 hdfs로 보내는 과정에서 시간이 걸려서 docker exec하고 조금 기다린 후 run spark-shell 

### run spark-shell in client mode
```bash
# spark-shell --master yarn --deploy-mode client
```
or
```bash
# cd /usr/local/spark/
# ./run-sparkshell.sh
```
