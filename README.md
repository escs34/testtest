# ubuntu-spark

ubuntu 16.04 hadoop 3.1.1 spark 2.4.0

```bash
$ sudo docker run -dit --name [spark-container-name] --network [network-hadoop-container-is-connected] [image-name] /bin/bash
```
or
```bash
$ ./run_spark.sh [network-name] [spark-container-name]
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

### run spark-shell in client mode
```bash
# spark-shell --master yarn --deploy-mode client
```
or
```bash
# cd /usr/local/spark/
# ./run-sparkshell.sh
```
