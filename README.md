# Warcbase workshop vm 

## Introduction

This is a virtual machine for Warcbase workshops. [Warcbase](http://warcbase.org) documentation can be found [here](http://docs.warcbase.org/).

The virtual machine that is built uses 2GB of RAM. Your host machine will need to be able to support that.

## Requirements

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)
3. [Git](https://git-scm.com/)

## Use

1. `git clone https://github.com/web-archive-group/warcbase_workshop_vagrant.git`
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
- warcbase HEAD
- Apache Spark 1.5.1 
- Spark Notebook
  - scala-2.10.4
  - spark-1.5.1
  - hadoop-2.6.0
  - cdh5.4.2

## Spark Shell

To run spark shell:

* `cd project/spark-1.5.1-bin-hadoop2.6/bin`
* `./spark-shell --jars /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar`

Example:
```bash
vagrant@warcbase:~/project/spark-1.5.1-bin-hadoop2.6/bin$ ./spark-shell --jars /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar
WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.5.1
      /_/

Using Scala version 2.10.4 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_74)
Type in expressions to have them evaluated.
Type :help for more information.
WARN  Utils - Your hostname, warcbase resolves to a loopback address: 127.0.1.1; using 10.0.2.15 instead (on interface eth0)
WARN  Utils - Set SPARK_LOCAL_IP if you need to bind to another address
WARN  MetricsSystem - Using default name DAGScheduler for source because spark.app.id is not set.
Spark context available as sc.
WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
SQL context available as sqlContext.

scala> :paste
// Entering paste mode (ctrl-D to finish)

import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
val r = RecordLoader.loadArc("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => ExtractTopLevelDomain(r.getUrl))
  .countItems()
  .take(10)

// Exiting paste mode, now interpreting.

ERROR ArcRecordUtils - Read 1235 bytes but expected 1311 bytes. Continuing...
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._
r: Array[(String, Int)] = Array((communist-party.ca,39), (www.gca.ca,39), (greenparty.ca,39), (www.davidsuzuki.org,34), (westernblockparty.com,26), (www.nosharia.com,24), (partimarijuana.org,22), (www.ccsd.ca,22), (canadianactionparty.ca,22), (www.nawl.ca,19))
```

## Resources

This build also includes the [warcbase resources](https://github.com/lintool/warcbase-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/home/vagrant/project/warcbase-resources/Sample-Data/`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/). 

## Authors

- [Nick Ruest](https://github.com/ruebot)
