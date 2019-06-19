# ubuntu-spark

ubuntu 16.04 hadoop 3.1.1 spark 2.4.0

### run spark

`run_spark.sh` is a shell script for creating groups of spark clusters.
each group is consist of 1 master and N workers.
container names are `student${Number}`.

```bash
$ ./run_spark.sh [network-name] [spark-container-start-number] [spark-container-end-number] [number of containers among the cluster group]
```
for example if you want make 10 containers and 5 groups of clusters. 
each cluster is consist of 1 master node and 1 worker node.
```
$ ./run_spark.sh test-network 1 10 2
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

### quit spark-shell
`:quit` or ctrl+D

---

Check if master and slaves are connected.
Lists all running nodes.
```bash
# yarn node -list
```


if spark-shell gets stuck, check running applications and kill unnecessary ones.
```bash
# yarn application -list
# yarn application -kill [application-id]
```


