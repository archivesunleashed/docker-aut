FROM ubuntu:16.04

LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

EXPOSE 9000
EXPOSE 4040

RUN apt-get update && apt-get install -y wget git tar ca-certificates openjdk-8-jdk openjdk-8-jdk-headless openjdk-8-jre \
    && sed -i '$iJAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' /etc/environment \
    && export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN git clone https://github.com/archivesunleashed/aut-resources.git \
    && mkdir /aut /spark /notebook

RUN cd /aut && wget -q "http://central.maven.org/maven2/io/archivesunleashed/aut/0.9.0/aut-0.9.0-fatjar.jar"

RUN cd /tmp \
    && wget -q "https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-0.7.0-pre2-scala-2.10.5-spark-1.6.2-hadoop-2.7.3.tgz" \
    && tar -xf "/tmp/spark-notebook-0.7.0-pre2-scala-2.10.5-spark-1.6.2-hadoop-2.7.3.tgz" -C /notebook --strip-components=1 \
    && rm "/tmp/spark-notebook-0.7.0-pre2-scala-2.10.5-spark-1.6.2-hadoop-2.7.3.tgz" \
    && cd /notebook && bin/spark-notebook -Dhttp.port=9000 -J-Xms1024m &

RUN cd /tmp \
    && wget -q "http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz" \
    && tar -xf "/tmp/spark-1.6.1-bin-hadoop2.6.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-1.6.1-bin-hadoop2.6.tgz"
