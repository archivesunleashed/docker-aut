#/bin/bash

# warcbase
cd /home/vagrant
mkdir project

# Apache Spark
cd /home/vagrant/project
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.5.1-bin-hadoop2.6.tgz
tar -xvf spark-1.5.1-bin-hadoop2.6.tgz
rm spark-1.5.1-bin-hadoop2.6.tgz

# Spark Notebook
cd /home/vagrant/project
wget https://s3.eu-central-1.amazonaws.com/spark-notebook/tgz/spark-notebook-master-scala-2.10.4-spark-1.5.1-hadoop-2.6.0-cdh5.4.2.tgz
tar -xvf spark-notebook-master-scala-2.10.4-spark-1.5.1-hadoop-2.6.0-cdh5.4.2.tgz
rm spark-notebook-master-scala-2.10.4-spark-1.5.1-hadoop-2.6.0-cdh5.4.2.tgz

# warcbase dependencies (vagrant isn't playing nice with maven, or I don't have paths setup right)
cd /tmp
wget http://central.maven.org/maven2/commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.pom
wget http://central.maven.org/maven2/commons-logging/commons-logging-api/1.1/commons-logging-api-1.1.jar
wget http://central.maven.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.jar
wget http://central.maven.org/maven2/com/google/code/findbugs/jsr305/1.3.9/jsr305-1.3.9.pom
wget http://central.maven.org/maven2/oro/oro/2.0.8/oro-2.0.8.jar
wget http://central.maven.org/maven2/oro/oro/2.0.8/oro-2.0.8.pom
wget http://central.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar
wget http://central.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.pom
wget http://central.maven.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.jar
wget http://central.maven.org/maven2/commons-collections/commons-collections/3.2.1/commons-collections-3.2.1.pom
wget http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
wget http://central.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.pom
wget http://central.maven.org/maven2/org/apache/commons/commons-compress/1.9/commons-compress-1.9.jar
wget http://central.maven.org/maven2/org/apache/commons/commons-compress/1.9/commons-compress-1.9.pom

# warcbase
cd /home/vagrant/project
git clone http://github.com/lintool/warcbase.git
cd /home/vagrant/project/warcbase
mvn install:install-file -Dfile=/usr/share/java/bsh-2.0b4.jar -DpomFile=/usr/share/maven-repo/org/beanshell/bsh/2.0b4/bsh-2.0b4.pom
mvn install:install-file -Dfile=/usr/share/java/commons-cli-1.2.jar -DpomFile=/usr/share/maven-repo/commons-cli/commons-cli/1.2/commons-cli-1.2.pom
mvn install:install-file -Dfile=/tmp/commons-logging-api-1.1.jar -DpomFile=/tmp/commons-logging-api-1.1.pom
mvn install:install-file -Dfile=/tmp/jsr305-1.3.9.jar -DpomFile=/tmp/jsr305-1.3.9.pom
mvn install:install-file -Dfile=/tmp/oro-2.0.8.jar -DpomFile=/tmp/oro-2.0.8.pom
mvn install:install-file -Dfile=/tmp/commons-lang-2.6.jar -DpomFile=/tmp/commons-lang-2.6.pom
mvn install:install-file -Dfile=/tmp/commons-collections-3.2.1.jar -DpomFile=/tmp/commons-collections-3.2.1.pom
mvn install:install-file -Dfile=/tmp/hamcrest-core-1.3.jar -DpomFile=/tmp/hamcrest-core-1.3.pom
mvn install:install-file -Dfile=/tmp/commons-compress-1.9.jar -DpomFile=/tmp/commons-compress-1.9.pom
mvn clean package appassembler:assemble -DskipTests

# sample files
cd /home/vagrant/project
git clone https://github.com/lintool/warcbase-resources.git

# make sure permissions are fine
cd /home/vagrant
chown -hR vagrant:vagrant *
