FROM kmubigdata/ubuntu-hadoop:worked
MAINTAINER kimjeongchul

USER root

# scala
RUN apt-get update
RUN apt-get install -y scala

# python
RUN apt-get install -y python
RUN apt-get install -y python3

# spark 2.3 without Hadoop
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-without-hadoop.tgz
RUN tar -xvzf spark-2.2.0-bin-without-hadoop.tgz -C /usr/local
RUN cd /usr/local && ln -s ./spark-2.2.0-bin-without-hadoop spark

# ENV hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH

# ENV spark
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
ADD slaves $SPARK_HOME/conf/slaves

ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
ADD slaves $HADOOP_HOME/etc/hadoop/slaves

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

EXPOSE 7077

#install sbt
RUN apt-get install apt-transport-https
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get -y install sbt

ENTRYPOINT ["/etc/bootstrap.sh"]
