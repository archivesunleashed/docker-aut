#!/bin/bash

# Set apt-get for non-interactive mode
export DEBIAN_FRONTEND=noninteractive

sudo echo "LANG=en_US.UTF-8" >> /etc/environment
sudo echo "LANGUAGE=en_US.UTF-8" >> /etc/environment
sudo echo "LC_ALL=en_US.UTF-8" >> /etc/environment
sudo echo "LC_CTYPE=en_US.UTF-8" >> /etc/environment

#######################################################################
# Work around for https://bugs.launchpad.net/cloud-images/+bug/1569237
echo "ubuntu:ubuntu" | chpasswd
#######################################################################

# Update
apt-get -y update && apt-get -y upgrade

# SSH
apt-get -y install openssh-server

# Build tools
apt-get -y install build-essential automake libtool

# Git vim
apt-get -y install git vim

# Java 
apt-get install -y software-properties-common
apt-get install -y python-software-properties
add-apt-repository -y ppa:webupd8team/java
apt-get update
echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
apt-get install -y oracle-java8-installer
update-java-alternatives -s java-8-oracle
apt-get install -y oracle-java8-set-default

# Set JAVA_HOME variable both now and for when the system restarts
export JAVA_HOME
JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment

# Maven
apt-get -y install maven libmaven-enforcer-plugin-java

# Wget and curl
apt-get -y install wget curl

# Bug fix for Ubuntu 14.04 with zsh 5.0.2 -- https://bugs.launchpad.net/ubuntu/+source/zsh/+bug/1242108
export MAN_FILES
MAN_FILES=$(wget -qO- "http://sourceforge.net/projects/zsh/files/zsh/5.0.2/zsh-5.0.2.tar.gz/download" \
  | tar xvz -C /usr/share/man/man1/ --wildcards "zsh-5.0.2/Doc/*.1" --strip-components=2)
for MAN_FILE in $MAN_FILES; do gzip /usr/share/man/man1/"${MAN_FILE##*/}"; done

# More helpful packages
apt-get -y install htop tree zsh unzip
