# Bigdata on docker
This repository contains a basic setup for your first bigdata-cluster on top of docker.

It provides
* HDFS with one Name- and one Datanode
* HIVE
  * MySql-Database and Metastore are seperated into dedicated containers
  * Data is written to HDFS
  * JDBC-Service (HiveServer2)
* Administrationtool Hue
* Apache Spark

Most containers are based on alpine linux, so that they have a small footprint. All the used images are "auto built" on hub.docker.com. 

# Installation
Before you start the cluster you need to initialize the Hive-Metastore with the following command:
```
docker-compose run --entrypoint 'sh -c "while ! nc -z metastore-mysql 3306; do sleep 3; done \
  && export HADOOP_USER_CLASSPATH_FIRST=true \
  && schematool -dbType mysql -initSchema"' metastore
```

Furthermore we need to initialize the HDFS-Namenode. This is done with the following command:
```
docker-compose run --entrypoint 'sh -c "/usr/local/hadoop/bin/hdfs namenode -format"' hadoop-namenode
```

If you use windows, these commands are only executable with a "-d" flag to daemonize the commands.
Make sure you stop all running containers after the initialisation (```docker rm -f $(docker ps -a -q)```)
There will be problems with shared volumes otherwise.

# Start
The following command starts all HIVE, HDFS and Hue-Services
```
docker-compose up
```

Transient Jobs, which shouldn't be started on ```docker-compose up``` but only if they are explicitely executed, are living in the ```docker-compose-transient.yml``` file.

# Working with Apache Spark
First, we need to make our job available inside the spark container. Unfortunately docker doesn't allow us to copy files directly into a volume. 
Thats why we need to start a container with a volume and copy the file into the mounted folder in our container.
```
export LAST_CONTAINER=`docker-compose -f docker-compose-transient.yml run -d spark sh`
docker cp yourJob.jar ${LAST_CONTAINER}:/home/spark/jobs
docker rm $LAST_CONTAINER
```

To start a spark-job you can perform the following command:
```
docker-compose -f docker-compose-transient.yml run spark \
  /usr/local/spark/bin/spark-submit \
    --class ch.yourpath.yourJob \
    /home/spark/jobs/yourJob.jar
```