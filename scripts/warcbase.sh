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

# warcbase
cd /home/vagrant/project
git clone http://github.com/lintool/warcbase.git
#su vagrant -l -c 'cd /home/vagrant/project/warcbase && sudo mvn clean package appassembler:assemble -DskipTests'
cd /home/vagrant/project/warcbase

cd /home/vagrant/project
git clone https://github.com/lintool/warcbase-resources.git

cd /home/vagrant
chown -hR vagrant:vagrant *
