#! /bin/bash

STUDENT_FRONT="sudo docker run -dit --name"
SLAVE_COMMAND=""
COMMAND_LAST="kmubigdata/ubuntu-spark:latest /bin/bash"
SLAVE="node-"
ADDHOST='--add-host'
IP="10.40.0."

numOfContaiers=1
numOfAddHosts=1
numOfSlaves=1
coreNumber=1
portNumber=1
masterIP=""

if [[ -z "$4" ]]; then
        echo "format is wrong"
        echo "./add_studnet network-name student-from student-to"
        echo "ex) ./add_student my-net 1 10 5"
        echo "network is my-net, student from 1, student to 10, 1 master 4 slaves"
        exit 0
fi


numOfContaiers=$2
sparkGroup=$4
while [ $numOfContaiers != $(($3+1)) ];
do
        SLAVE_COMMAND="$STUDENT_FRONT student$numOfContaiers --network $1 --ip $IP$(($numOfContaiers+1)) --memory 2560m"
        if [ $portNumber -lt 10 ]; then
                SLAVE_COMMAND="$SLAVE_COMMAND -p 2210$portNumber:22 -p 2220$portNumber:8080 -p 2230$portNumber:18080"
        else
                SLAVE_COMMAND="$SLAVE_COMMAND -p 221$portNumber:22 -p 222$portNumber:8080 -p 223$portNumber:18080"
        fi

        if [ $(($numOfContaiers % 6)) == 1 ]; then
                tempNum=$(($numOfContaiers+1))
                passwd=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
                echo "student$numOfContaiers passwd = $passwd"
        fi

        numOfAddHosts=0
        while [ $numOfAddHosts != $sparkGroup ];
        do
                if [ $numOfAddHosts != 0 ]; then
                        SLAVE_COMMAND="$SLAVE_COMMAND $ADDHOST $SLAVE$(($numOfAddHosts)):$IP$(($tempNum + $numOfAddHosts))"
                        numOfAddHosts=$(($numOfAddHosts + 1))
                else
                        SLAVE_COMMAND="$SLAVE_COMMAND $ADDHOST master:$IP$(($tempNum + $numOfAddHosts))"
                        masterIP=$SLAVE$(($numOfAddHosts + 1))
                        numOfAddHosts=$(($numOfAddHosts + 1))
                fi
        done

        SLAVE_COMMAND="$SLAVE_COMMAND --cpu-shares 1024"

        $SLAVE_COMMAND $COMMAND_LAST
        sudo docker exec student$numOfContaiers bash -c "echo 'root:$passwd' | chpasswd"
        sudo docker exec student$numOfContaiers bash -c "sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
        sudo docker exec student$numOfContaiers bash -c "service ssh restart"

        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP=/usr/local/hadoop' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$PATH:\$HADOOP/bin:\$HADOOP_HOME/sbin' >> ~/.bashrc"

        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_HOME=\$HADOOP' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_COMMON_HOME=\$HADOOP_HOME' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_HDFS_HOME=\$HADOOP_HOME' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_MAPRED_HOME=\$HADOOP_HOME' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_YARN_HOME=\$HADOOP_HOME' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export YARN_CONF_DIR=\$HADOOP_HOME/etc/hadoop' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/hadoop/lib/native' >> ~/.bashrc"
     
        sudo docker exec student$numOfContaiers bash -c "echo 'export SPARK_HOME=/usr/local/spark' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin' >> ~/.bashrc"

        sudo docker exec student$numOfContaiers bash -c "echo 'export JAVA_HOME=/usr/java/default' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$PATH:\$JAVA_HOME/bin' >> ~/.bashrc"
        
        sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$PATH:/usr/share/sbt/bin' >> ~/.bashrc"

        sudo docker exec student$numOfContaiers bash -c "source ~/.bashrc"

        sudo docker exec student$numOfContaiers bash -c "cp /etc/hosts ~/hosts.new ; sed -i '\$d' ~/hosts.new ; cp -f ~/hosts.new /etc/hosts ; rm ~/hosts.new"
        sudo docker exec student$numOfContaiers bash -c "sed -i '1d' /usr/local/hadoop/etc/hadoop/workers ; sed -i '1d' /usr/local/spark/conf/slaves"

        numOfSlaves=1
        while [ $numOfSlaves != $sparkGroup ];
        do
                sudo docker exec student$numOfContaiers bash -c "echo '$SLAVE$numOfSlaves' >> /usr/local/hadoop/etc/hadoop/workers"
                sudo docker exec student$numOfContaiers bash -c "echo '$SLAVE$numOfSlaves' >> /usr/local/spark/conf/slaves"
                numOfSlaves=$(($numOfSlaves + 1))
        done
        
        SLAVE_COMMAND=''
        numOfContaiers=$(($numOfContaiers+1))
        coreNumber=$(($coreNumber+1))
        portNumber=$(($portNumber+1))
        masterIP=""
done
