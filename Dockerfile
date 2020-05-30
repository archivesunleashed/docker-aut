# Base Alpine Linux based image with OpenJDK and Maven
FROM maven:3-jdk-8-alpine

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="https://archivesunleashed.org/"

## Build variables
#########################
ARG SPARK_VERSION=2.4.5

# Need this for Parquet support in Alpine.
RUN apk update \
      && apk add --no-cache libc6-compat \
      && ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

# Git and Wget
RUN apk --no-cache --virtual build-dependencies add --update \
    git \
    wget \
    && apk add python3 \
    && ln -sf /usr/bin/python3 /usr/local/bin/python

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git /aut-resources

# Build from source; Ivy has problems with non-maven repositories.
#   - This is specifically for the Guava issues in our Tika fork
RUN git clone --branch aut-0.70.0 https://github.com/archivesunleashed/aut.git \
      && cd aut \
      && mvn clean install \
      # Yet another --packages work around
      && cd /root/.m2/repository/org/mortbay/jetty/servlet-api/2.5-20081211 \
      && wget -q "https://repo1.maven.org/maven2/org/mortbay/jetty/servlet-api/2.5-20081211/servlet-api-2.5-20081211.jar"

# Spark shell
RUN mkdir /spark \
    && cd /tmp \
    && wget -q "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz"

RUN apk del build-dependencies

CMD /spark/bin/spark-shell --packages "io.archivesunleashed:aut:0.70.0"
