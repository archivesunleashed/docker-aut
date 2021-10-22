# Base Alpine Linux based image with OpenJDK and Maven
FROM maven:3-jdk-11

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

## Build variables
#######################
ARG SPARK_VERSION=3.1.1

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git

# Archives Unleashed Toolkit
RUN mkdir /aut \
    && cd /aut \
    && wget https://github.com/archivesunleashed/aut/releases/download/aut-0.90.3/aut-0.90.3-fatjar.jar \
    && wget https://github.com/archivesunleashed/aut/releases/download/aut-0.90.3/aut-0.90.3.zip

# Spark shell
RUN mkdir /spark \
    && cd /tmp \
    && wget -q "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz"


CMD /spark/bin/spark-shell --jars /aut/aut-0.90.3-fatjar.jar
