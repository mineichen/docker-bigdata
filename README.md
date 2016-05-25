# Bigdata on docker
This repository contains a basic setup for your first bigdata-cluster in the form of docker containers.

It provides
* HDFS with one Name- and one Datanode
* HIVE with MySql and Metastore in dedicated containers writing to HDFS
* Administrationtool hue

Most containers are based on alpine linux, so that they have a small footprint. All the used images are "auto built" on hub.docker.com. 

# Installation
´´´
docker-compose run --entrypoint 'sh -c "while ! nc -z metastore-mysql 3306; do sleep 3; done \
  && export HADOOP_USER_CLASSPATH_FIRST=true \
  && schematool -dbType mysql -initSchema"' metastore
´´´

