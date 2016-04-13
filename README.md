# Warcbase workshop vm 

## Introduction

This is a virtual machine for Warcbase workshops. [Warcbase](http://warcbase.org) documentation can be found [here](http://docs.warcbase.org/).

The virtual machine that is built uses 2GB of RAM. Your host machine will need to be able to support that.

It requires a lot of data. If you are attending a workshop at a conference, we strongly recommend downloading everything beforehand.

[Coursework can be found in the coursework subdirectory](https://github.com/web-archive-group/warcbase_workshop_vagrant/tree/master/coursework). 

## Requirements

Download each of the following dependencies.

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)
3. [Git](https://git-scm.com/)

## Virtual Machine

To install this virtual machine, you have two options. 

[You can download it from this link and load it using VirtualBox](http://alpha.library.yorku.ca/releases/warcbase_workshop/Warcbase_workshop_VM.ova). Note that this is a 6.4GB download. If you do this, [skip to "Spark Notebook" below](https://github.com/web-archive-group/warcbase_workshop_vagrant#spark-notebook).

Or you can use vagrant to build it yourself.

## Use

You'll need to get your virtual machine running on the command line. For a basic walkthrough of how to use the command line, please consult [this lesson at the Programming Historian](http://programminghistorian.org/lessons/intro-to-bash).

From a working directory, please run the following commands.

1. `git clone https://github.com/web-archive-group/warcbase_workshop_vagrant.git` (this clones this repository)
2. `cd warcbase_workshop_vagrant` (this changes into the repository directory)
3. `vagrant up` (this builds the virtual machine - it will take a while and download a lot of data)

Once you run these three commands, you will have a running virtual machine with the latest version of warcbase installed.

## Connect

Now you need to connect to the machine. This will be done through your command line, but also through your browser through Spark Notebook.

We use three commands to connect to this virtual machine. `ssh` to connect to it via your command line. `scp` to copy a file (such as a WARC or ARC), `rsync` to sync a directory between two machines.

To get started, type `vagrant ssh` in the directory where you installed the VM. 

When prompted:
  - username: `vagrant`
  - password: `vagrant`

Here are some other example commands:
* `ssh -p 2222 vagrant@localhost` - will connect to the machine using `ssh`;
* `scp -P 2222 somefile.txt vagrant@localhost:/destination/path` - will copy `somefile.txt` to your vagrant machine. 
  - You'll need to specify the destination. For example, `scp -P 2222 WARC.warc.gz vagrant@localhost:/home/vagrant` will copy WARC.warc.gz to the home directory of the vagrant machine.
* `rsync --rsh='ssh -p2222' -av somedir vagrant@localhost:/home/vagrant` - will sync `somedir` to your home directory of the vagrant machine.

## Environment

- Ubuntu 14.04
- warcbase HEAD
- Apache Spark 1.5.1 
- Spark Notebook
  - scala-2.10.4
  - spark-1.5.1
  - hadoop-2.6.0
  - cdh5.4.2

## Spark Notebook

To run spark notebook, type the following:

* `vagrant ssh` (if on vagrant; if you downloaded the ova file and are running with VirtualBox you do not need to do this)
* `cd project/spark-notebook-0.6.2-SNAPSHOT-scala-2.10.4-spark-1.5.1-hadoop-2.6.0-cdh5.4.2/bin`
* `./spark-notebook -Dhttp.port=9000 -J-Xms1024m`
* Visit http://127.0.0.1:9000/ in your web browser.

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

## Spark Shell

To run spark shell:

* `vagrant ssh`
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
val r = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => ExtractDomain(r.getUrl))
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
- [Ian Milligan](https://github.com/ianmilligan1)

## Acknowlegements

This research has been supported by the Social Sciences and Humanities Research Council with Insight Grant 435-2015-0011. Additional funding for student labour on this project comes from an Ontario Ministry of Research and Innovation Early Researcher Award.