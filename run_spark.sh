#! /bin/bash

STUDENT_FRONT="sudo docker run -dit --name"
SLAVE_COMMAND=""
COMMAND_LAST="kmubigdata/bigdata-platform /bin/bash"
SLAVE="node-"
ADDHOST='--add-host='
IP="10.10.10."

numOfContaiers=1
numOfAddHosts=1
numOfCores=1
coreNumber=1
portNumber=1

if [[ -z "$3" ]]; then
	echo "format is wrong"
	echo "./add_studnet network-name student-from student-to"
	echo "ex) ./add_student my-net 1 5"
	echo "network is my-net, numOfcore, student from 1, student to 5"
	exit 0
fi
	

numOfContaiers=$2
while [ $numOfContaiers != $(($3+1)) ];
do
	SLAVE_COMMAND="$STUDENT_FRONT student$numOfContaiers --network $1 --ip $IP$(($numOfContaiers+1)) --memory 6g"
	if [ $numOfContaiers -lt 10 ]; then
                SLAVE_COMMAND="$SLAVE_COMMAND -p 2210$numOfContaiers:22 -p 2220$numOfContaiers:18080"
        else
                SLAVE_COMMAND="$SLAVE_COMMAND -p 221$numOfContaiers:22 -p 222$numOfContaiers:18080"
        fi

	if [ $(($numOfContaiers % 2)) != 0 ]; then
		tempNum=$(($numOfContaiers+1))
		passwd=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
		echo "student$numOfContaiers passwd = $passwd"
	fi
	
	numOfAddHosts=0	
	while [ $numOfAddHosts != 2 ];
	do
        	SLAVE_COMMAND="$SLAVE_COMMAND $ADDHOST$SLAVE$(($numOfAddHosts + 1)):$IP$(($tempNum + $numOfAddHosts))"
       		numOfAddHosts=$(($numOfAddHosts + 1))
	done

	numOfCores=1
	

	SLAVE_COMMAND="$SLAVE_COMMAND --cpuset-cpus=$(($(($coreNumber-1))*2))"
        while [ $numOfCores != 2 ];
        do
                SLAVE_COMMAND="$SLAVE_COMMAND,$(($(($(($coreNumber-1))*2))+$numOfCores))"
                numOfCores=$(($numOfCores+1))
        done

	$SLAVE_COMMAND --storage-opt size=200G $COMMAND_LAST
	sudo docker exec student$numOfContaiers bash -c "echo 'root:$passwd' | chpasswd"
	sudo docker exec student$numOfContaiers bash -c "sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
	sudo docker exec student$numOfContaiers bash -c "service ssh restart"

	sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP=/usr/local/hadoop' >> ~/.bashrc"
	sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$HADOOP/bin:\$PATH' >> ~/.bashrc"

        sudo docker exec student$numOfContaiers bash -c "echo 'export HADOOP_HOME=\$HADOOP' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export SPARK_HOME=/usr/local/spark' >> ~/.bashrc"
        sudo docker exec student$numOfContaiers bash -c "echo 'export PATH=\$PATH:\$SPARK_HOME/bin:\$SPARK_HOME/sbin' >> ~/.bashrc"


	sudo docker exec student$numOfContaiers bash -c "source ~/.bashrc"
	SLAVE_COMMAND=''
	numOfContaiers=$(($numOfContaiers+1))
	coreNumber=$(($coreNumber+1))
	portNumber=$(($portNumber+1))
done
