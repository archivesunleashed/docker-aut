FROM ubuntu:16.04

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

# Open ports
EXPOSE 9000

## Build variables

#########################
# Tied to Altiscale
#########################
ARG HADOOP_VERSION=2.7.3
ARG SPARK_VERSION=2.1.1
ARG SCALA_VERSION=2.11.8
#########################
ARG NOTEBOOK_VERSION=master

# Java & Maven
RUN apt-get -qq update && apt-get -qq -y install wget git tar ca-certificates openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre maven \
    && sed -i '$iJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /etc/environment \
    && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git \
    && mkdir /aut /spark /notebook /data /scala

# Archives Unleashed Toolkit
RUN git clone https://github.com/archivesunleashed/aut.git aut \
    && cd aut && mvn -q clean install \
    && mv /aut/target/aut-*-fatjar.jar /aut/aut.jar \
    && export ADD_JARS=/aut/aut.jar

# Spark Notebook
RUN cd /tmp \
    && wget -q "https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz" \
    && tar -xf "/tmp/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz" -C /notebook --strip-components=1 \
    && rm "/tmp/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz"

# Spark shell
RUN cd /tmp \
    && wget -q "http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz"

# Scala
RUN wget -q "https://downloads.lightbend.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz" \
    && tar xfz scala-$SCALA_VERSION.tgz -C /scala \
    && rm scala-$SCALA_VERSION.tgz \
    && ln -s /scala/bin/scala /usr/bin/scala

# Workspace
VOLUME /notebook/notebooks /data

# Setup ENV for aut in Spark Notebook
#ENV ADD_JARS=/aut/target/aut-0.10.1-SNAPSHOT.jar \
#    SCALA_HOME=/usr/share/scala \
#    SPARK_HOME=/spark

CMD cd /notebook && bin/spark-notebook -Dhttp.port=9000 -J-Xms1024m
