# Warcbase workshop vm 

## Introduction

This is a virtual machine for Warcbase workshops. [Warcbase](http://warcbase.org) documentation can be found [here](http://docs.warcbase.org/).

The virtual machine that is built uses 2GB of RAM. Your host machine will need to be able to support that.

## Requirements

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)
3. [Git](https://git-scm.com/)

## Use

1. `git clone https://github.com/web-archive-group/warcbase_workshop`
2. `cd warcbase_workshop_vagrant`
3. `vagrant up`

## Connect

ssh, scp, rsync:
  - username: vagrant
  - password: vagrant
  - Examples
    - `vagrant ssh`
    - `ssh -p 2222 vagrant@localhost`
    - `scp -P 2222 somefile.txt vagrant@localhost:/destination/path`
    - `rsync --rsh='ssh -p2222' -av somedir vagrant@localhost:/tmp`

## Environment

- Ubuntu 14.04

## Authors

- [Nick Ruest](https://github.com/ruebot)
