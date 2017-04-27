# Hands on With Warcbase
# IIPC WAC 2016, Ian Milligan and Nick Ruest

The reality of any hands-on workshop is that things will break. We've tried our best to provide a robust VM that can let you walk through the basics of warcbase alongside us.

![homepage of slidedeck](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/iipc-workshop/slidedeck.png)
[Click here for our introductory slidedeck (PDF, 24MB).](http://yorkspace.library.yorku.ca/xmlui/bitstream/handle/10315/31108/hands-on-with-warcbase.key.pdf?sequence=1)

If you have any questions, let us know!

- [Nick Ruest](https://github.com/ruebot)
- [Ian Milligan](https://github.com/ianmilligan1)

## Table of Contents

* 1. [Installation](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#installation)
* 2. [Testing](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#testing)
* 3. [Spark Notebook](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#spark-notebook)
* 3.1. [Getting Started](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-one-getting-started) 
* 3.2. [Learning Spark Notebook](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-two-learning-spark-notebook) 
* 3.3. [Introductory Text Analysis](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-three-prototyping-scripts-text-analysis) 
* 3.4. [More Advanced Analysis](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-four-slightly-more-advanced-analysis)
* 3.5. [More sophisticated commands](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-five-more-sophisticated-commands) 
* 3.6. [Network Analysis](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-six-network-analysis) 
* 3.7. [Image Analysis](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-seven-image-analysis) 
* 4. [Spark Shell](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-four-spark-shell)
* 5. [Next Steps](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#next-steps)
* 6. [Acknowledgements and Final Notes](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#acknowledgements-and-final-notes)

## Installation

### Option One: VirtualBox

Download [VirtualBox from here](https://www.virtualbox.org) and install it. You also need to download the [OVA file from here](http://alpha.library.yorku.ca/releases/warcbase_workshop/Warcbase_workshop_VM.ova). Be careful, it's a 6.4GB download.

Your VirtualBox will hopefully look like this:

![VM manager](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/iipc-workshop/vm-manager.png)

Go to your File menu, select "Import Appliance," and select the OVA file. Press "continue," then "Import."

![VM load](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/iipc-workshop/vm-import.png)

Then press "Start."

If you're lucky, the terminal window will appear. If you're asked for a username or password, it is:
  - username: `ubuntu`
  - password: `ubuntu`

### Option Two: Vagrant (Local)

We're assuming you're a bit more technical if you're going this route. 

Download each of the following dependencies.

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)
3. [Git](https://git-scm.com/)

To build the machine using vagrant, you need to get your virtual machine running on the command line. For a basic walkthrough of how to use the command line, please consult [this lesson at the Programming Historian](http://programminghistorian.org/lessons/intro-to-bash).

From a working directory, please run the following commands.

1. `git clone https://github.com/web-archive-group/warcbase_workshop_vagrant.git` (this clones this repository)
2. `cd warcbase_workshop_vagrant` (this changes into the repository directory)
3. `vagrant up` (this builds the virtual machine - it will take a while and download a lot of data)

Once you run these three commands, you will have a running virtual machine with the latest version of warcbase installed.

You'll now need to connect to the machine. Now you need to connect to the machine. This will be done through your command line, but also through your browser through Spark Notebook.

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

### Option Two: Vagrant (AWS)

Download each of the following dependencies.

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)
3. [Git](https://git-scm.com/)

Install the vagrant-aws plugin by running:

`vagrant plugin install vagrant-aws`

From a working directory, please run the following commands.

1. `git clone https://github.com/web-archive-group/warcbase_workshop_vagrant.git` (this clones this repository)
2. `cd warcbase_workshop_vagrant` (this changes into the repository directory)
3. You will then have to edit your `Vagrantfile`. Pay attention to this block to add your AWS information.

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

4. You can then load it by typing: `vagrant up --provider aws`
5. You may need to override your security group settings in the EC2 dashboard. Ensure that port 22 (SSH) and 9000 (for the Spark notebook) are open.

## Testing

Let's make sure we can get spark notebook running. On vagrant, connect using `vagrant ssh`. This will also bring you into the AWS.

If you used VirtualBox, you have two options. On OS X or Linux, you can minimize your window, open your terminal, and connect to it using: `ssh -p 2222 ubuntu@localhost`.

On Windows, you'll have to use your VirtualBox terminal.

Either way, you should be at a prompt that looks like:

```
ubuntu@warcbase:~$
```

### Testing Spark Shell

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
```

If this works, things are going well.

You can exit by typing: `exit`.

Let's make our lives easier by using the Notebook.

## Spark Notebook

In our warcbase workflow, we use the notebook to often prototype on one ARC or WARC file, before running production on a directory. 

### Step One: Getting Started

To run spark notebook, type the following:

* `vagrant ssh` (if on vagrant; if you downloaded the ova file and are running with VirtualBox you do not need to do this)
* `cd spark-notebook-0.6.3-scala-2.10.5-spark-1.6.1-hadoop-2.6.0/bin`
* `./spark-notebook -Dhttp.port=9000 -J-Xms1024m`
* Visit http://127.0.0.1:9000/ in your web browser. 

If you are connecting via AWS, visit the IP address of your instance (found on EC2 dashboard), port 9000 (i.e. `35.162.32.51:9000`).

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

### Step Two: Learning Spark Notebook

Let's start a new notebook. Click the "new" button in the upper right, and then select the line beginning with `Scala [2.10.4]...`. Give it a fun name like "WARC Workshop."

First, you need to load the warcbase jar. Paste this into the first command and press the play button.

```bash
:cp /home/ubuntu/project/warcbase/warcbase-core/target/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar
```

Second, you need to import the classes.

```scala
import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
```

Third, let's run a test script. The following will load one of the ARC files from the sample data directory and count the various top-level domains that you can find in it.

```scala
val r = 
  RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", 
sc) 
  .keepValidPages() 
  .map(r => ExtractDomain(r.getUrl)) 
  .countItems() 
  .take(10) 
```

Click on the pie chart tab at bottom, and you'll see the breakdown of domains in all of its glory.

To see why notebooks are fun, change the `10` above to `20`. Press play again.

### Step Three: Prototyping Scripts: Text Analysis

As noted, we generally recommend that people use the Spark Notebook to prototype scripts that they'll later adapt and run in their Spark Shell. 

Let's give it a try by adapting some of the scripts that we might run in the Shell. For example, extracting text:

```scala
val r = 
  RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", 
sc) 
  .keepValidPages() 
  .map(r => { 
    val t = RemoveHTML(r.getContentString) 
    val len = 100 
    (r.getCrawlDate, r.getUrl, if ( t.length > len ) t.substring(0, len) else t)}) 
  .collect() 
```

Again, change a variable. Right now, we see 100 characters of each webpage. Let's change that to 200. Change `val len = 100` to `val len = 200`.

### Step Four: More Advanced Analysis

Sometimes it can get boring typing out the same thing over and over again. We can set variables to make our life easier, such as:

```scala
val warc="/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz"
```

Now instead of typing the path, we can just use `warc`. Try running that cell and replacing it in the script above. For the lazy, it looks like:

```scala
val r = 
  RecordLoader.loadArchives(warc, sc) 
  .keepValidPages() 
  .map(r => { 
    val t = RemoveHTML(r.getContentString) 
    val len = 200 
    (r.getCrawldate, r.getUrl, if ( t.length > len ) t.substring(0, len) else t)}) 
  .collect() 
```

Finally, we can do some neat tricks with browser injection. Run the following cell:

```scala
def createClickableLink(url: String, date: String): String = { 
"<a href='http://web.archive.org/web/" + date + "/" + url + "'>" + 
url + "</a>" 
} 
```

Now let's re-run a familiar command from before but with this `createClickableLink` command and our `warc` variable.

```scala
val r = 
  RecordLoader.loadArchives(warc, sc) 
  .keepValidPages() 
  .map(r => { 
    val t = RemoveHTML(r.getContentString) 
    val len = 100 
    (r.getCrawlDate, createClickableLink(r.getUrl, 
    r.getCrawlDate), if ( t.length > len ) t.substring(0, len) else t)}) 
.collect()
```

Now you should have beautiful clickable links to explore. Open in a few in a new tab!

#### Step Five: More sophisticated commands

We would normally switch to Spark Shell at this point, but given the amount of Windows machines let's learn new commands in notebook.

For example, to grab the plain text from the collection and **save it to a file**, we could use:

```scala
import org.warcbase.spark.rdd.RecordRDD._
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}

RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => (r.getCrawldate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/ubuntu/WARC-plain-text")
```

You should now have a directory in `/home/ubuntu/` with the plain text. I will show you it.

##### Text by Domain

Above, we saw that there were 34 pages belonging to `davidsuzuki.org`. Imagine we just want them. The following script adds a new command: `keepDomains`.

```scala
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}
import org.warcbase.spark.rdd.RecordRDD._

RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .keepDomains(Set("www.davidsuzuki.org"))
  .map(r => (r.getCrawlDate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/ubuntu/WARC-plain-text-David-Suzuki")
```

It should work as well. Note that your command `keepDomains(Set("www.davidsuzuki.org"))` needs to match the string you found above. 

##### Other filters

There are other filters at play here. You can filter by language, year, patterns in URLs, and beyond. Let's play for a bit.

[Consult the documentation here](http://lintool.github.io/warcbase-docs/Spark-Extracting-Domain-Level-Plain-Text/). Try a few different filters. Nick and Ian will walk around the room to make sure you're all online.

#### Step Six: Network Analysis

Let's run a basic network analysis.

```scala
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._
import StringUtils._

val links = RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .flatMap(r => ExtractLinks(r.getUrl, r.getContentString))
  .map(r => (ExtractDomain(r._1).removePrefixWWW(), ExtractDomain(r._2).removePrefixWWW()))
  .filter(r => r._1 != "" && r._2 != "")
  .countItems()
  .filter(r => r._2 > 5)

links.saveAsTextFile("/home/ubuntu/WARC-links-all/")
```

By now this should be seeming pretty straightforward. In your other window, visit the resulting file (the `part-00000` file in your `WARC-links-all` direcrory) and type:

```
head part-00000
```

You should see:

>((policyalternatives.ca,policyalternatives.ca),1072)
((ccsd.ca,ccsd.ca),367)
((conservative.ca,conservative.ca),267)
((greenparty.ca,main.greenparty.ca),220)
((ndp.ca,ndp.ca),190)
((davidsuzuki.org,davidsuzuki.org),170)
((nawl.ca,nawl.ca),168)
((greenparty.ca,contact.greenparty.ca),117)
((egale.ca,egale.ca),91)
((coat.ncf.ca,coat.ncf.ca),89)

We have other commands, which you can find on the page [here](http://lintool.github.io/warcbase-docs/Spark-Analysis-of-Site-Link-Structure/). Start playing around with this now.

##### Step Seven: Image Analysis

You may want to do work with images. The following script finds all the image URLs and displays the top 10.

```scala
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._

val links = RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .flatMap(r => ExtractImageLinks(r.getUrl, r.getContentString))
  .countItems()
  .take(10) 
```

If you wanted to work with the images, you could download them from the Internet Archive. 

Let's use the top-ranked example. [This link](http://web.archive.org/web/*/http://archive.org/images/star.png), for example, will show you the temporal distribution of the image. For a snapshot from September 2007, this URL would work:

<http://web.archive.org/web/20070913051458/http://www.archive.org/images/star.png>

To do analysis on all images, you could thus prepend `http://web.archive.org/web/20070913051458/` to each URL and `wget` them en masse.

For more information on `wget`, please consult [this lesson available on the Programming Historian website](http://programminghistorian.org/lessons/automated-downloading-with-wget). 

### Step Four: Spark Shell

We won't have much time for Spark Shell today, but we wanted to briefly show it. In our warcbase workflow, we often prototype new scripts with the Spark Notebook, before running our jobs directly with Shell.

To run, navigate to the spark-shell directory by

```bash
cd /home/ubuntu/project/spark-1.6.1-bin-hadoop2.6/bin
```

Then run with:

```bash
./spark-shell --jars /home/ubuntu/project/warcbase/warcbase-core/target/warcbase-core-0.1.0-SNAPSHOT-fatjar.jar
``` 

>On your own system, you might want to pass different variables to allocate more memory and the such (i.e. on our server, we often use `/home/i2millig/spark-1.5.1/bin/spark-shell --driver-memory 60G --jars ~/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar` to give it 60GB of memory; or on the cluster, we use `spark-shell --jars ~/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar --num-executors 75 --executor-cores 5 --executor-memory 20G --driver-memory 26G`).

Now we are ready for our first test script. To get this working, you need to first type:

```
:paste
```

Then you can paste the following script. When it's looking right, press `Ctrl` and `D` at the same time to get it running.

```scala
import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
val r = RecordLoader.loadArchives("/home/ubuntu/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => ExtractDomain(r.getUrl))
  .countItems()
  .take(10)
```

This counts the number of domains found in the collection and displays them. In the above, your result should look like:

>r: Array[(String, Int)] = Array((communist-party.ca,39), (www.gca.ca,39), (greenparty.ca,39), (www.davidsuzuki.org,34), (westernblockparty.com,26), (www.nosharia.com,24), (partimarijuana.org,22), (www.ccsd.ca,22), (canadianactionparty.ca,22), (www.nawl.ca,19))

You probably get the sense.

# Next Steps

Let's try setting it up on your own servers, or in a real production environment. We'll be around to lend hands on help.

# Acknowledgements and Final Notes

This build also includes the [warcbase resources](https://github.com/lintool/warcbase-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/home/ubuntu/project/warcbase-resources/Sample-Data/`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/). 

This research has been supported by the Social Sciences and Humanities Research Council with Insight Grant 435-2015-0011. Additional funding for student labour on this project comes from an Ontario Ministry of Research and Innovation Early Researcher Award.
