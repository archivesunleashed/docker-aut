# Base Alpine Linux based image with OpenJDK and Maven
FROM maven:3-jdk-11

# Metadata
LABEL maintainer="Nick Ruest <ruestn@gmail.com>"
LABEL description="Docker image for the Archives Unleashed Toolkit."
LABEL website="http://archivesunleashed.org/"

## Build variables
#######################
ARG SPARK_VERSION=3.1.1

# Install Python3
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		python3

# Set Python3 as default Python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2 1 \
      && update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# Sample resources
RUN git clone https://github.com/archivesunleashed/aut-resources.git

# Archives Unleashed Toolkit
RUN git clone https://github.com/archivesunleashed/aut.git /aut \
    && cd /aut \
    && export JAVA_OPTS=-Xmx512m \
    && mvn clean install

# Spark shell
RUN mkdir /spark \
    && cd /tmp \
    && wget -q "https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" \
    && tar -xf "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz" -C /spark --strip-components=1 \
    && rm "/tmp/spark-$SPARK_VERSION-bin-hadoop2.7.tgz"

CMD /spark/bin/spark-shell --jars /aut/target/aut-0.90.3-SNAPSHOT-fatjar.jar
