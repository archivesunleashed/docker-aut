# docker-aut 
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Introduction

Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](http://docs.archivesunleashed.io/).

## Requirements

Install each of the following dependencies:

1. [Docker](https://www.docker.com/get-docker)

## Use

### Docker Hub

`docker run --rm -it -p 9000:9000 archivesunleashed/docker-aut`

### Locally

1. `git clone https://github.com/archivesunleashed/docker-aut.git`
2. `cd docker-aut`
3. `docker build -t aut .`
4. `docker run --rm -it -p 9000:9000 aut`


Once the build finishes, you should see:

```bash
$ docker run --rm -it -p 9000:9000 aut
2017-10-04 18:56:36 WARN  application:111 - Logger configuration in conf files is deprecated and has no effect. Use a logback configuration file instead.
2017-10-04 18:56:37 INFO  Slf4jLogger:92 - Slf4jLogger started
2017-10-04 18:56:37 WARN  application:111 - application.langs is deprecated, use play.i18n.langs instead
2017-10-04 18:56:37 WARN  application:111 - application.conf @ file:/notebook/conf/application.conf: 8: application.secret is deprecated, use play.crypto.secret instead
2017-10-04 18:56:37 INFO  Play:92 - Application started (Prod)
2017-10-04 18:56:37 INFO  NettyServer:92 - Listening for HTTP on /0.0.0.0:9000
[DEBUG] [10/04/2017 18:56:45.287] [netty-event-loop-3] [EventStream] StandardOutLogger started
2017-10-04 18:56:45 INFO  Slf4jLogger:92 - Slf4jLogger started
[DEBUG] [10/04/2017 18:56:45.310] [netty-event-loop-3] [EventStream(akka://NotebookServer)] logger log1-Slf4jLogger started
[DEBUG] [10/04/2017 18:56:45.310] [netty-event-loop-3] [EventStream(akka://NotebookServer)] Default Loggers started
2017-10-04 18:56:45 INFO  Remoting:107 - Starting remoting
2017-10-04 18:56:45 INFO  Remoting:107 - Remoting started; listening on addresses :[akka.tcp://NotebookServer@127.0.0.1:44995]
2017-10-04 18:56:45 INFO  Remoting:107 - Remoting now listens on addresses: [akka.tcp://NotebookServer@127.0.0.1:44995]
2017-10-04 18:56:45 INFO  application:92 - io.provider_timeout: 89000 ms
2017-10-04 18:56:45 INFO  application:92 - Notebooks dir is /notebook/notebooks
2017-10-04 18:56:45 INFO  application:92 - Notebook directory is: /notebook/notebooks
```

## Spark Notebook

To run spark notebook, visit http://127.0.0.1:9000/ in your web browser. 

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

## Spark Shell

To run spark shell you will need to shell into your Docker image. For a basic walkthrough of how to use the command line, please consult [this lesson at the Programming Historian](http://programminghistorian.org/lessons/intro-to-bash).

In another terminal run `docker ps -a`. This should yield something like:

```
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                    NAMES
d4c566c24d3f        aut                 "/bin/sh -c 'cd /n..."   About a minute ago   Up About a minute   0.0.0.0:9000->9000/tcp   musing_franklin
```

To shell into you Docker image, use the following command, which uses the "CONTAINER ID".

```
$ docker exec -it d4c566c24d3f bash
```

To run Spark shell:

`$ /spark/bin/spark-shell --jars /aut/aut.jar`

Example:
```bash
root@d4c566c24d3f:/# /spark/bin/spark-shell --jars /aut/aut.jar
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
2017-10-04 18:58:32,128 [main] WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2017-10-04 18:58:36,017 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-10-04 18:58:36,093 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-10-04 18:58:36,548 [main] WARN  ObjectStore - Failed to get database global_temp, returning NoSuchObjectException
Spark context Web UI available at http://172.17.0.2:4040
Spark context available as 'sc' (master = local[*], app id = local-1507143512649).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/
         
Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_131)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 

```

Example script:

```
scala> :paste
// Entering paste mode (ctrl-D to finish)

import io.archivesunleashed.spark.matchbox._
import io.archivesunleashed.spark.rdd.RecordRDD._

val r = RecordLoader.loadArchives("/aut-resources/Sample-Data/*.gz", sc)
.keepValidPages()
.map(r => ExtractDomain(r.getUrl))
.countItems()
.take(10)

// Exiting paste mode, now interpreting.

[Stage 0:>                                                          (0 + 2) / 2]2017-10-04 18:45:44,534 [Executor task launch worker for task 1] ERROR ArcRecordUtils - Read 1235 bytes but expected 1311 bytes. Continuing...
import io.archivesunleashed.spark.matchbox._                                    
import io.archivesunleashed.spark.rdd.RecordRDD._
r: Array[(String, Int)] = Array((www.equalvoice.ca,4644), (www.liberal.ca,1968), (greenparty.ca,732), (www.policyalternatives.ca,601), (www.fairvote.ca,465), (www.ndp.ca,417), (www.davidsuzuki.org,396), (www.canadiancrc.com,90), (www.gca.ca,40), (communist-party.ca,39))
```

To quit Spark Shell, you can exit using <kbd>CTRL</kbd>+<kbd>c</kbd>.

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
