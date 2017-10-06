FROM ubuntu:16.04

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

# Open ports
EXPOSE 9000

## Build variables
########################################################################################
# We're not tied to Altiscale.
# See: https://github.com/archivesunleashed/docker-aut/issues/10#issuecomment-334582293
########################################################################################
ARG HADOOP_VERSION=2.6.5
ARG NOTEBOOK_VERSION=0.7.0-pre2
ARG SCALA_VERSION=2.11.7
ARG SPARK_VERSION=1.6.3

# Java & Maven
RUN apt-get -qq update && apt-get -qq -y install wget git tar ca-certificates openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre maven \
    && sed -i '$iJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /etc/environment \
    && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git \
    && mkdir /aut /spark /notebook

# Archives Unleashed Toolkit
RUN git clone https://github.com/archivesunleashed/aut.git aut \
    && cd aut && mvn -q clean install \
    && mv /aut/target/aut-*-fatjar.jar /aut/aut.jar

# Spark Notebook
RUN cd /tmp \
    && wget -q "https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz" \
    && tar -xf "/tmp/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz" -C /notebook --strip-components=1 \
    && rm "/tmp/spark-notebook-$NOTEBOOK_VERSION-scala-$SCALA_VERSION-spark-$SPARK_VERSION-hadoop-$HADOOP_VERSION.tgz"

# Spark shell
RUN cd /tmp \
    && wget -q "http://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop2.6.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.6.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.6.tgz"

CMD cd /notebook && bin/spark-notebook -Dhttp.port=9000 -J-Xms1024m
