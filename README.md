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

[You can download it from this link and "import the appliance" using VirtualBox](http://alpha.library.yorku.ca/releases/warcbase_workshop/Warcbase_workshop_VM.ova). Note that this is a 6.4GB download. If you do this, [skip to "Spark Notebook" below](https://github.com/web-archive-group/warcbase_workshop_vagrant#spark-notebook).

Or you can use vagrant to build it yourself, or provision it using `aws`.

## Use

You'll need to get your virtual machine running on the command line. For a basic walkthrough of how to use the command line, please consult [this lesson at the Programming Historian](http://programminghistorian.org/lessons/intro-to-bash).

From a working directory, please run the following commands.

1. `git clone https://github.com/web-archive-group/warcbase_workshop_vagrant.git` (this clones this repository)
2. `cd warcbase_workshop_vagrant` (this changes into the repository directory)
3. `vagrant up` (this builds the virtual machine - it will take a while and download a lot of data)

Once you run these three commands, you will have a running virtual machine with the latest version of warcbase installed.

## Cloud Deployment

You can also deploy this as an AWS machine. To do so, install [vagrant-aws](https://github.com/mitchellh/vagrant-aws). 

`vagrant plugin install vagrant-aws`

And then modify the `VagrantFile` to point to your AWS information. The following block will need to be changed:

```
  config.vm.provider :aws do |aws, override|
  aws.access_key_id = "KEYHERE"
  aws.secret_access_key = "SECRETKEYHERE"
  aws.region = "us-west-2"

  aws.region_config "us-west-2" do |region|
      region.ami = "ami-01f05461"
      # by default, spins up lightweight m3.medium. If want powerful, uncomment below.
      # region.instance_type = "c3.4xlarge"

      region.keypair_name = "KEYPAIRNAME"
  end

  override.ssh.username = "ubuntu"
  override.ssh.private_key_path = "PATHTOPRIVATEKEY"
```

You can then load it by typing:

`vagrant up --provider aws`

Note, you will need to change your AWS Security Group to allow for incoming connections on port 22 (SSH) and 9000 (for Spark Notebook). By default, it launches a lightweight m3.medium. To do real work, you will need a larger (and sadly more expensive instance).

## Connect

Now you need to connect to the machine. This will be done through your command line, but also through your browser through Spark Notebook.

We use three commands to connect to this virtual machine. `ssh` to connect to it via your command line. `scp` to copy a file (such as a WARC or ARC), `rsync` to sync a directory between two machines.

To get started, type `vagrant ssh` in the directory where you installed the VM. 

When prompted:
  - username: `ubuntu`
  - password: `ubuntu`

Here are some other example commands:
* `ssh -p 2222 ubuntu@localhost` - will connect to the machine using `ssh`;
* `scp -P 2222 somefile.txt ubuntu@localhost:/destination/path` - will copy `somefile.txt` to your vagrant machine. 
  - You'll need to specify the destination. For example, `scp -P 2222 WARC.warc.gz ubuntu@localhost:/home/ubuntu` will copy WARC.warc.gz to the home directory of the vagrant machine.
* `rsync --rsh='ssh -p2222' -av somedir ubuntu@localhost:/home/ubuntu` - will sync `somedir` to your home directory of the vagrant machine.

## Environment

- Ubuntu 16.04
- warcbase HEAD
- Apache Spark 1.6.1
- Spark Notebook
  - scala-2.10.5
  - spark-1.6.1
  - hadoop-2.6.0

## Spark Notebook

To run spark notebook, type the following:

* `vagrant ssh` (if on vagrant; if you downloaded the ova file and are running with VirtualBox you do not need to do this)
* `cd spark-notebook-0.6.3-scala-2.10.5-spark-1.6.1-hadoop-2.6.0/bin`
* `./spark-notebook -Dhttp.port=9000 -J-Xms1024m`
* Visit http://127.0.0.1:9000/ in your web browser. 

If you are connecting via AWS, visit the IP address of your instance (found on EC2 dashboard), port 9000 (i.e. `35.162.32.51:9000`).

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

## Spark Shell

To run spark shell:

* `vagrant ssh`
* `cd project/spark-1.6.1-bin-hadoop2.6/bin`
* `./spark-shell --jars /home/ubuntu/project/warcbase/warcbase-core/target/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar`

Example:
```bash
ubuntu@warcbase:~/project/spark-1.6.1-bin-hadoop2.6/bin$ ./spark-shell --jars /home/ubuntu/project/warcbase/warcbase-core/target/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar
2017-04-27 13:30:32,235 [main] WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2017-04-27 13:30:32,500 [main] INFO  SecurityManager - Changing view acls to: ubuntu
2017-04-27 13:30:32,501 [main] INFO  SecurityManager - Changing modify acls to: ubuntu
2017-04-27 13:30:32,502 [main] INFO  SecurityManager - SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(ubuntu); users with modify permissions: Set(ubuntu)
2017-04-27 13:30:32,746 [main] INFO  HttpServer - Starting HTTP Server
2017-04-27 13:30:32,816 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-04-27 13:30:32,834 [main] INFO  AbstractConnector - Started SocketConnector@0.0.0.0:44780
2017-04-27 13:30:32,835 [main] INFO  Utils - Successfully started service 'HTTP class server' on port 44780.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.6.1
      /_/

Using Scala version 2.10.5 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_131)
Type in expressions to have them evaluated.
Type :help for more information.
2017-04-27 13:30:36,804 [main] WARN  Utils - Your hostname, warcbase resolves to a loopback address: 127.0.0.1; using 10.0.2.15 instead (on interface enp0s3)
2017-04-27 13:30:36,809 [main] WARN  Utils - Set SPARK_LOCAL_IP if you need to bind to another address
2017-04-27 13:30:36,844 [main] INFO  SparkContext - Running Spark version 1.6.1
2017-04-27 13:30:36,888 [main] INFO  SecurityManager - Changing view acls to: ubuntu
2017-04-27 13:30:36,889 [main] INFO  SecurityManager - Changing modify acls to: ubuntu
2017-04-27 13:30:36,889 [main] INFO  SecurityManager - SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(ubuntu); users with modify permissions: Set(ubuntu)
2017-04-27 13:30:37,098 [main] INFO  Utils - Successfully started service 'sparkDriver' on port 33188.
2017-04-27 13:30:37,453 [sparkDriverActorSystem-akka.actor.default-dispatcher-4] INFO  Slf4jLogger - Slf4jLogger started
2017-04-27 13:30:37,515 [sparkDriverActorSystem-akka.actor.default-dispatcher-2] INFO  Remoting - Starting remoting
2017-04-27 13:30:37,700 [sparkDriverActorSystem-akka.actor.default-dispatcher-2] INFO  Remoting - Remoting started; listening on addresses :[akka.tcp://sparkDriverActorSystem@10.0.2.15:34832]
2017-04-27 13:30:37,705 [main] INFO  Utils - Successfully started service 'sparkDriverActorSystem' on port 34832.
2017-04-27 13:30:37,719 [main] INFO  SparkEnv - Registering MapOutputTracker
2017-04-27 13:30:37,752 [main] INFO  SparkEnv - Registering BlockManagerMaster
2017-04-27 13:30:37,778 [main] INFO  DiskBlockManager - Created local directory at /tmp/blockmgr-06e1ee34-6411-4ea5-a900-3d6a2cd45143
2017-04-27 13:30:37,793 [main] INFO  MemoryStore - MemoryStore started with capacity 511.1 MB
2017-04-27 13:30:37,866 [main] INFO  SparkEnv - Registering OutputCommitCoordinator
2017-04-27 13:30:37,988 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-04-27 13:30:38,002 [main] INFO  AbstractConnector - Started SelectChannelConnector@0.0.0.0:4040
2017-04-27 13:30:38,003 [main] INFO  Utils - Successfully started service 'SparkUI' on port 4040.
2017-04-27 13:30:38,007 [main] INFO  SparkUI - Started SparkUI at http://10.0.2.15:4040
2017-04-27 13:30:38,060 [main] INFO  HttpFileServer - HTTP File server directory is /tmp/spark-c2526bda-bb78-4fe9-9b4d-cd9a7a0be67a/httpd-d6cda718-fcd2-40ea-a919-d431bfcac180
2017-04-27 13:30:38,060 [main] INFO  HttpServer - Starting HTTP Server
2017-04-27 13:30:38,063 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-04-27 13:30:38,078 [main] INFO  AbstractConnector - Started SocketConnector@0.0.0.0:44249
2017-04-27 13:30:38,080 [main] INFO  Utils - Successfully started service 'HTTP file server' on port 44249.
2017-04-27 13:30:38,352 [main] INFO  SparkContext - Added JAR file:/home/ubuntu/project/warcbase/warcbase-core/target/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar at http://10.0.2.15:44249/jars/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar with timestamp 1493299838351
2017-04-27 13:30:38,438 [main] INFO  Executor - Starting executor ID driver on host localhost
2017-04-27 13:30:38,443 [main] INFO  Executor - Using REPL class URI: http://10.0.2.15:44780
2017-04-27 13:30:38,462 [main] INFO  Utils - Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 38124.
2017-04-27 13:30:38,463 [main] INFO  NettyBlockTransferService - Server created on 38124
2017-04-27 13:30:38,464 [main] INFO  BlockManagerMaster - Trying to register BlockManager
2017-04-27 13:30:38,466 [dispatcher-event-loop-0] INFO  BlockManagerMasterEndpoint - Registering block manager localhost:38124 with 511.1 MB RAM, BlockManagerId(driver, localhost, 38124)
2017-04-27 13:30:38,468 [main] INFO  BlockManagerMaster - Registered BlockManager
2017-04-27 13:30:38,611 [main] INFO  SparkILoop - Created spark context..
Spark context available as sc.
2017-04-27 13:30:39,770 [main] INFO  HiveContext - Initializing execution hive, version 1.2.1
2017-04-27 13:30:39,823 [main] INFO  ClientWrapper - Inspected Hadoop version: 2.6.0
2017-04-27 13:30:39,824 [main] INFO  ClientWrapper - Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
2017-04-27 13:30:40,114 [main] INFO  HiveMetaStore - 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
2017-04-27 13:30:40,149 [main] INFO  ObjectStore - ObjectStore, initialize called
2017-04-27 13:30:40,281 [main] INFO  Persistence - Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
2017-04-27 13:30:40,282 [main] INFO  Persistence - Property datanucleus.cache.level2 unknown - will be ignored
2017-04-27 13:30:42,265 [main] INFO  ObjectStore - Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
2017-04-27 13:30:43,049 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:43,050 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:44,448 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:44,457 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:44,735 [main] INFO  MetaStoreDirectSql - Using direct SQL, underlying DB is DERBY
2017-04-27 13:30:44,739 [main] INFO  ObjectStore - Initialized ObjectStore
2017-04-27 13:30:44,884 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-04-27 13:30:45,026 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-04-27 13:30:45,217 [main] INFO  HiveMetaStore - Added admin role in metastore
2017-04-27 13:30:45,220 [main] INFO  HiveMetaStore - Added public role in metastore
2017-04-27 13:30:45,306 [main] INFO  HiveMetaStore - No user is added in admin role, since config is empty
2017-04-27 13:30:45,448 [main] INFO  HiveMetaStore - 0: get_all_databases
2017-04-27 13:30:45,449 [main] INFO  audit - ugi=ubuntu	ip=unknown-ip-addr	cmd=get_all_databases	
2017-04-27 13:30:45,467 [main] INFO  HiveMetaStore - 0: get_functions: db=default pat=*
2017-04-27 13:30:45,468 [main] INFO  audit - ugi=ubuntu	ip=unknown-ip-addr	cmd=get_functions: db=default pat=*	
2017-04-27 13:30:45,469 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:45,710 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/ubuntu
2017-04-27 13:30:45,714 [main] INFO  SessionState - Created local directory: /tmp/ubuntu
2017-04-27 13:30:45,720 [main] INFO  SessionState - Created local directory: /tmp/4af7ce20-005d-4d27-9cfe-b4c91a7742d1_resources
2017-04-27 13:30:45,725 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/ubuntu/4af7ce20-005d-4d27-9cfe-b4c91a7742d1
2017-04-27 13:30:45,729 [main] INFO  SessionState - Created local directory: /tmp/ubuntu/4af7ce20-005d-4d27-9cfe-b4c91a7742d1
2017-04-27 13:30:45,732 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/ubuntu/4af7ce20-005d-4d27-9cfe-b4c91a7742d1/_tmp_space.db
2017-04-27 13:30:45,852 [main] INFO  HiveContext - default warehouse location is /user/hive/warehouse
2017-04-27 13:30:45,872 [main] INFO  HiveContext - Initializing HiveMetastoreConnection version 1.2.1 using Spark classes.
2017-04-27 13:30:45,900 [main] INFO  ClientWrapper - Inspected Hadoop version: 2.6.0
2017-04-27 13:30:45,918 [main] INFO  ClientWrapper - Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
2017-04-27 13:30:46,422 [main] INFO  HiveMetaStore - 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
2017-04-27 13:30:46,447 [main] INFO  ObjectStore - ObjectStore, initialize called
2017-04-27 13:30:46,568 [main] INFO  Persistence - Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
2017-04-27 13:30:46,568 [main] INFO  Persistence - Property datanucleus.cache.level2 unknown - will be ignored
2017-04-27 13:30:48,200 [main] INFO  ObjectStore - Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
2017-04-27 13:30:48,752 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:48,753 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:49,619 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:49,619 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:49,780 [main] INFO  MetaStoreDirectSql - Using direct SQL, underlying DB is DERBY
2017-04-27 13:30:49,783 [main] INFO  ObjectStore - Initialized ObjectStore
2017-04-27 13:30:49,893 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-04-27 13:30:50,029 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-04-27 13:30:50,143 [main] INFO  HiveMetaStore - Added admin role in metastore
2017-04-27 13:30:50,149 [main] INFO  HiveMetaStore - Added public role in metastore
2017-04-27 13:30:50,231 [main] INFO  HiveMetaStore - No user is added in admin role, since config is empty
2017-04-27 13:30:50,318 [main] INFO  HiveMetaStore - 0: get_all_databases
2017-04-27 13:30:50,319 [main] INFO  audit - ugi=ubuntu	ip=unknown-ip-addr	cmd=get_all_databases	
2017-04-27 13:30:50,336 [main] INFO  HiveMetaStore - 0: get_functions: db=default pat=*
2017-04-27 13:30:50,336 [main] INFO  audit - ugi=ubuntu	ip=unknown-ip-addr	cmd=get_functions: db=default pat=*	
2017-04-27 13:30:50,340 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
2017-04-27 13:30:50,480 [main] INFO  SessionState - Created local directory: /tmp/351f9cc7-3275-49dc-ab8e-b0800a65a3bb_resources
2017-04-27 13:30:50,484 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/ubuntu/351f9cc7-3275-49dc-ab8e-b0800a65a3bb
2017-04-27 13:30:50,489 [main] INFO  SessionState - Created local directory: /tmp/ubuntu/351f9cc7-3275-49dc-ab8e-b0800a65a3bb
2017-04-27 13:30:50,492 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/ubuntu/351f9cc7-3275-49dc-ab8e-b0800a65a3bb/_tmp_space.db
2017-04-27 13:30:50,513 [main] INFO  SparkILoop - Created sql context (with Hive support)..
SQL context available as sqlContext.

scala>
scala> :paste
// Entering paste mode (ctrl-D to finish)

import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
val r = RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
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

To quit Spark Shell, you can exit using Ctrl+C.

## Resources

This build also includes the [warcbase resources](https://github.com/lintool/warcbase-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/home/ubuntu/project/warcbase-resources/Sample-Data/`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/). 

## Authors

- [Nick Ruest](https://github.com/ruebot)
- [Ian Milligan](https://github.com/ianmilligan1)

## Acknowlegements

This research has been supported by the Social Sciences and Humanities Research Council with Insight Grant 435-2015-0011. Additional funding for student labour on this project comes from an Ontario Ministry of Research and Innovation Early Researcher Award. The idea for the AWS deployment came from the DocNow team and their [repository here](https://github.com/web-archive-group/warcbase_workshop_vagrant/tree/aws).
