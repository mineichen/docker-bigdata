# Bigdata on docker
This repository contains a basic setup for your first bigdata-cluster on top of docker.

It provides
* HDFS with one Name- and one Datanode
* HIVE
  * MySql-Database and Metastore are seperated into dedicated containers
  * Data is written to HDFS
  * JDBC-Service (HiveServer2)
* Administrationtool Hue

Most containers are based on alpine linux, so that they have a small footprint. All the used images are "auto built" on hub.docker.com. 

# Installation
Before you start the cluster you need to initialize the Hive-Metastore with the following command:
```
docker-compose run --entrypoint 'sh -c "while ! nc -z metastore-mysql 3306; do sleep 3; done \
  && export HADOOP_USER_CLASSPATH_FIRST=true \
  && schematool -dbType mysql -initSchema"' metastore
```

The HDFS is initialized automatically if the folder ```/hdfs``` is empty. Your cluster is ready to run now.

```docker-compose up```


