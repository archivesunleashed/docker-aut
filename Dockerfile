# Base Alpine Linux based image with OpenJDK and Maven
FROM maven:3-jdk-8-alpine

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

## Build variables
#########################
ARG SPARK_VERSION=2.1.1

# Git and Wget
RUN apk add --update \
    git \
    wget

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git /aut-resources

# Archives Unleashed Toolkit
RUN mkdir /aut \
    && cd /aut \
    && wget -q "http://central.maven.org/maven2/io/archivesunleashed/aut/0.11.0/aut-0.11.0-fatjar.jar"

# Spark shell
RUN mkdir /spark \
    && cd /tmp \
    && wget -q "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz"

CMD /spark/bin/spark-shell --jars /aut/aut-0.11.0-fatjar.jar
