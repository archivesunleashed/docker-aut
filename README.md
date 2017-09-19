# docker-aut 
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Introduction

Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](http://docs.archivesunleashed.io/).

[Coursework can be found in the coursework subdirectory](https://github.com/archivesunleashed/docker-aut/tree/master/coursework).

## Requirements

Install each of the following dependencies:

1. [Docker](http://docs.archivesunleashed.io/)

## Use

### Docker Hub

`docker run --rm -it -p 9000:9000 -p 4040:4040 archivesunleashed/docker-aut`

### Locally

1. `git clone https://github.com/archivesunleashed/docker-aut.git`
2. `cd docker-aut`
3. `docker build -t aut .`
4. `docker run --rm -it -p 9000:9000 -p 4040:4040 aut`


Once the build finishes, you should see:

```bash
$ docker run --rm -it -p 9000:9000 -p 4040:4040 aut
Play server process ID is 6
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/notebook/lib/ch.qos.logback.logback-classic-1.1.1.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/notebook/lib/org.slf4j.slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [ch.qos.logback.classic.util.ContextSelectorStaticBinder]
[info] play - Application started (Prod)
[info] play - Listening for HTTP on /0.0.0.0:9000
```

## Spark Notebook

To run spark notebook, visit http://127.0.0.1:9000/ in your web browser. 

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

## Spark Shell

To run spark shell you will need to shell into your Docker image. For a basic walkthrough of how to use the command line, please consult [this lesson at the Programming Historian](http://programminghistorian.org/lessons/intro-to-bash).

In another terminal run `$ docker ps -a`. This should yield something like:

```
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                            NAMES
3f361fed472c        aut                 "/bin/sh -c 'cd /n..."   About a minute ago   Up About a minute   0.0.0.0:4040->4040/tcp, 0.0.0.0:9000->9000/tcp   adoring_lumiere
```

To shell into you Docker image, use the following command, which uses the "CONTAINER ID".

```
$ docker exec -it 3f361fed472c bash
```

To run Spark shell:

`$ /spark/bin/spark-shell --jars /aut/aut-0.9.0-fatjar.jar`

Example:
```bash
root@73309b4247ed:/# /spark/bin/spark-shell --jars /aut/aut-0.9.0-fatjar.jar 
2017-09-18 18:14:36,080 [main] WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2017-09-18 18:14:36,245 [main] INFO  SecurityManager - Changing view acls to: root
2017-09-18 18:14:36,245 [main] INFO  SecurityManager - Changing modify acls to: root
2017-09-18 18:14:36,246 [main] INFO  SecurityManager - SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(root); users with modify permissions: Set(root)
2017-09-18 18:14:36,339 [main] INFO  HttpServer - Starting HTTP Server
2017-09-18 18:14:36,366 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-09-18 18:14:36,377 [main] INFO  AbstractConnector - Started SocketConnector@0.0.0.0:42794
2017-09-18 18:14:36,378 [main] INFO  Utils - Successfully started service 'HTTP class server' on port 42794.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.6.1
      /_/

Using Scala version 2.10.5 (OpenJDK 64-Bit Server VM, Java 1.8.0_131)
Type in expressions to have them evaluated.
Type :help for more information.
2017-09-18 18:14:38,679 [main] INFO  SparkContext - Running Spark version 1.6.1
2017-09-18 18:14:38,697 [main] INFO  SecurityManager - Changing view acls to: root
2017-09-18 18:14:38,697 [main] INFO  SecurityManager - Changing modify acls to: root
2017-09-18 18:14:38,697 [main] INFO  SecurityManager - SecurityManager: authentication disabled; ui acls disabled; users with view permissions: Set(root); users with modify permissions: Set(root)
2017-09-18 18:14:38,796 [main] INFO  Utils - Successfully started service 'sparkDriver' on port 40120.
2017-09-18 18:14:38,989 [sparkDriverActorSystem-akka.actor.default-dispatcher-4] INFO  Slf4jLogger - Slf4jLogger started
2017-09-18 18:14:39,012 [sparkDriverActorSystem-akka.actor.default-dispatcher-4] INFO  Remoting - Starting remoting
2017-09-18 18:14:39,092 [sparkDriverActorSystem-akka.actor.default-dispatcher-4] INFO  Remoting - Remoting started; listening on addresses :[akka.tcp://sparkDriverActorSystem@172.17.0.2:40926]
2017-09-18 18:14:39,095 [main] INFO  Utils - Successfully started service 'sparkDriverActorSystem' on port 40926.
2017-09-18 18:14:39,101 [main] INFO  SparkEnv - Registering MapOutputTracker
2017-09-18 18:14:39,113 [main] INFO  SparkEnv - Registering BlockManagerMaster
2017-09-18 18:14:39,121 [main] INFO  DiskBlockManager - Created local directory at /tmp/blockmgr-22d5fba8-1f98-4261-be6e-49f4b55e3dfa
2017-09-18 18:14:39,124 [main] INFO  MemoryStore - MemoryStore started with capacity 511.1 MB
2017-09-18 18:14:39,159 [main] INFO  SparkEnv - Registering OutputCommitCoordinator
2017-09-18 18:14:39,259 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-09-18 18:14:39,268 [main] INFO  AbstractConnector - Started SelectChannelConnector@0.0.0.0:4040
2017-09-18 18:14:39,268 [main] INFO  Utils - Successfully started service 'SparkUI' on port 4040.
2017-09-18 18:14:39,269 [main] INFO  SparkUI - Started SparkUI at http://172.17.0.2:4040
2017-09-18 18:14:39,290 [main] INFO  HttpFileServer - HTTP File server directory is /tmp/spark-d7587442-adbd-4d05-9df1-ce9593dea01c/httpd-43ffdd51-c990-4482-9377-015548f3ecee
2017-09-18 18:14:39,290 [main] INFO  HttpServer - Starting HTTP Server
2017-09-18 18:14:39,291 [main] INFO  Server - jetty-8.y.z-SNAPSHOT
2017-09-18 18:14:39,292 [main] INFO  AbstractConnector - Started SocketConnector@0.0.0.0:44561
2017-09-18 18:14:39,293 [main] INFO  Utils - Successfully started service 'HTTP file server' on port 44561.
2017-09-18 18:14:39,452 [main] INFO  SparkContext - Added JAR file:/aut/aut-0.9.0-fatjar.jar at http://172.17.0.2:44561/jars/aut-0.9.0-fatjar.jar with timestamp 1505758479451
2017-09-18 18:14:39,488 [main] INFO  Executor - Starting executor ID driver on host localhost
2017-09-18 18:14:39,496 [main] INFO  Executor - Using REPL class URI: http://172.17.0.2:42794
2017-09-18 18:14:39,510 [main] INFO  Utils - Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 44249.
2017-09-18 18:14:39,511 [main] INFO  NettyBlockTransferService - Server created on 44249
2017-09-18 18:14:39,512 [main] INFO  BlockManagerMaster - Trying to register BlockManager
2017-09-18 18:14:39,514 [dispatcher-event-loop-2] INFO  BlockManagerMasterEndpoint - Registering block manager localhost:44249 with 511.1 MB RAM, BlockManagerId(driver, localhost, 44249)
2017-09-18 18:14:39,515 [main] INFO  BlockManagerMaster - Registered BlockManager
2017-09-18 18:14:39,599 [main] INFO  SparkILoop - Created spark context..
Spark context available as sc.
2017-09-18 18:14:39,909 [main] INFO  HiveContext - Initializing execution hive, version 1.2.1
2017-09-18 18:14:40,263 [main] INFO  ClientWrapper - Inspected Hadoop version: 2.6.0
2017-09-18 18:14:40,264 [main] INFO  ClientWrapper - Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
2017-09-18 18:14:40,475 [main] INFO  HiveMetaStore - 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
2017-09-18 18:14:40,492 [main] INFO  ObjectStore - ObjectStore, initialize called
2017-09-18 18:14:40,568 [main] INFO  Persistence - Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
2017-09-18 18:14:40,568 [main] INFO  Persistence - Property datanucleus.cache.level2 unknown - will be ignored
2017-09-18 18:14:41,691 [main] INFO  ObjectStore - Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
2017-09-18 18:14:42,123 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:42,124 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:42,928 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:42,928 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:43,119 [main] INFO  MetaStoreDirectSql - Using direct SQL, underlying DB is DERBY
2017-09-18 18:14:43,120 [main] INFO  ObjectStore - Initialized ObjectStore
2017-09-18 18:14:43,189 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-09-18 18:14:43,264 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-09-18 18:14:43,386 [main] INFO  HiveMetaStore - Added admin role in metastore
2017-09-18 18:14:43,388 [main] INFO  HiveMetaStore - Added public role in metastore
2017-09-18 18:14:43,442 [main] INFO  HiveMetaStore - No user is added in admin role, since config is empty
2017-09-18 18:14:43,494 [main] INFO  HiveMetaStore - 0: get_all_databases
2017-09-18 18:14:43,495 [main] INFO  audit - ugi=root	ip=unknown-ip-addr	cmd=get_all_databases	
2017-09-18 18:14:43,504 [main] INFO  HiveMetaStore - 0: get_functions: db=default pat=*
2017-09-18 18:14:43,504 [main] INFO  audit - ugi=root	ip=unknown-ip-addr	cmd=get_functions: db=default pat=*	
2017-09-18 18:14:43,505 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:43,650 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/root
2017-09-18 18:14:43,652 [main] INFO  SessionState - Created local directory: /tmp/root
2017-09-18 18:14:43,653 [main] INFO  SessionState - Created local directory: /tmp/4e60933d-40ba-4917-8a74-42d0b8173766_resources
2017-09-18 18:14:43,655 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/root/4e60933d-40ba-4917-8a74-42d0b8173766
2017-09-18 18:14:43,657 [main] INFO  SessionState - Created local directory: /tmp/root/4e60933d-40ba-4917-8a74-42d0b8173766
2017-09-18 18:14:43,659 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/root/4e60933d-40ba-4917-8a74-42d0b8173766/_tmp_space.db
2017-09-18 18:14:43,701 [main] INFO  HiveContext - default warehouse location is /user/hive/warehouse
2017-09-18 18:14:43,707 [main] INFO  HiveContext - Initializing HiveMetastoreConnection version 1.2.1 using Spark classes.
2017-09-18 18:14:43,715 [main] INFO  ClientWrapper - Inspected Hadoop version: 2.6.0
2017-09-18 18:14:43,723 [main] INFO  ClientWrapper - Loaded org.apache.hadoop.hive.shims.Hadoop23Shims for Hadoop version 2.6.0
2017-09-18 18:14:44,002 [main] INFO  HiveMetaStore - 0: Opening raw store with implemenation class:org.apache.hadoop.hive.metastore.ObjectStore
2017-09-18 18:14:44,018 [main] INFO  ObjectStore - ObjectStore, initialize called
2017-09-18 18:14:44,092 [main] INFO  Persistence - Property hive.metastore.integral.jdo.pushdown unknown - will be ignored
2017-09-18 18:14:44,092 [main] INFO  Persistence - Property datanucleus.cache.level2 unknown - will be ignored
2017-09-18 18:14:45,228 [main] INFO  ObjectStore - Setting MetaStore object pin classes with hive.metastore.cache.pinobjtypes="Table,StorageDescriptor,SerDeInfo,Partition,Database,Type,FieldSchema,Order"
2017-09-18 18:14:45,575 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:45,576 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:46,215 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MFieldSchema" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:46,215 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MOrder" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:46,375 [main] INFO  MetaStoreDirectSql - Using direct SQL, underlying DB is DERBY
2017-09-18 18:14:46,376 [main] INFO  ObjectStore - Initialized ObjectStore
2017-09-18 18:14:46,438 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-09-18 18:14:46,519 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-09-18 18:14:46,602 [main] INFO  HiveMetaStore - Added admin role in metastore
2017-09-18 18:14:46,605 [main] INFO  HiveMetaStore - Added public role in metastore
2017-09-18 18:14:46,661 [main] INFO  HiveMetaStore - No user is added in admin role, since config is empty
2017-09-18 18:14:46,731 [main] INFO  HiveMetaStore - 0: get_all_databases
2017-09-18 18:14:46,732 [main] INFO  audit - ugi=root	ip=unknown-ip-addr	cmd=get_all_databases	
2017-09-18 18:14:46,743 [main] INFO  HiveMetaStore - 0: get_functions: db=default pat=*
2017-09-18 18:14:46,743 [main] INFO  audit - ugi=root	ip=unknown-ip-addr	cmd=get_functions: db=default pat=*	
2017-09-18 18:14:46,744 [main] INFO  Datastore - The class "org.apache.hadoop.hive.metastore.model.MResourceUri" is tagged as "embedded-only" so does not have its own datastore table.
2017-09-18 18:14:46,849 [main] INFO  SessionState - Created local directory: /tmp/ebb11fbb-def6-44a0-911d-77f7024dc293_resources
2017-09-18 18:14:46,853 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/root/ebb11fbb-def6-44a0-911d-77f7024dc293
2017-09-18 18:14:46,856 [main] INFO  SessionState - Created local directory: /tmp/root/ebb11fbb-def6-44a0-911d-77f7024dc293
2017-09-18 18:14:46,858 [main] INFO  SessionState - Created HDFS directory: /tmp/hive/root/ebb11fbb-def6-44a0-911d-77f7024dc293/_tmp_space.db
2017-09-18 18:14:46,869 [main] INFO  SparkILoop - Created sql context (with Hive support)..
SQL context available as sqlContext.

scala>

```


To quit Spark Shell, you can exit using Ctrl+C.

## Resources

This build also includes the [aut resources](https://github.com/archivesunleashed/aut-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/aut-resources`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/about).

## Authors

- [Nick Ruest](https://github.com/ruebot)
- [Ian Milligan](https://github.com/ianmilligan1)

## Acknowlegements

This work is primarily supported by the [Andrew W. Mellon Foundation](https://uwaterloo.ca/arts/news/multidisciplinary-project-will-help-historians-unlock). Additional funding for the Toolkit has come from the U.S. National Science Foundation, Columbia University Library's Mellon-funded Web Archiving Incentive Award, the Natural Sciences and Engineering Research Council of Canada, the Social Sciences and Humanities Research Council of Canada, and the Ontario Ministry of Research and Innovation's Early Researcher Award program. Any opinions, findings, and conclusions or recommendations expressed are those of the researchers and do not necessarily reflect the views of the sponsors.
