#/bin/bash

cd /home/vagrant/project/warcbase
sudo mvn clean package appassembler:assemble -DskipTests
