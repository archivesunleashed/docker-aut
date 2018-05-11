# docker-aut
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Introduction

This is the Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](http://archivesunleashed.org/aut/). If you need a hand installing Docker, check out our [Docker Install Instructions](https://github.com/archivesunleashed/docker-aut/wiki/Docker-Install-Instructions), and if you want a quick tutorial, check out our [Hands on With The Archives Unleashed Toolkit](https://github.com/archivesunleashed/docker-aut/wiki/Hands-on-With-The-Archives-Unleashed-Toolkit).

The Archives Unleashed Toolkit is part of the broader [Archives Unleashed Project](http://archivesunleashed.org/).

## Requirements

Install each of the following dependencies:

1. [Docker](https://www.docker.com/get-docker)

## Use

### Docker Hub

`docker run --rm -it archivesunleashed/docker-aut:0.16.0`

If you want to mount your own data:

`docker run --rm -it -v "/path/to/your/data:/data" archivesunleashed/docker-aut:0.16.0`

### Locally

1. `git clone -b 0.16.0 https://github.com/archivesunleashed/docker-aut.git`
2. `cd docker-aut`
3. `docker build -t aut .`
4. `docker run --rm -it aut`


Once the build finishes, you should see:

```bash
$ docker run --rm -it aut
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
2017-12-08 00:28:03,803 [main] WARN  NativeCodeLoader - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
2017-12-08 00:28:10,965 [main] WARN  ObjectStore - Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
2017-12-08 00:28:11,130 [main] WARN  ObjectStore - Failed to get database default, returning NoSuchObjectException
2017-12-08 00:28:12,068 [main] WARN  ObjectStore - Failed to get database global_temp, returning NoSuchObjectException
Spark context Web UI available at http://172.17.0.2:4040
Spark context available as 'sc' (master = local[*], app id = local-1512692884451).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/

Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_151)
Type in expressions to have them evaluated.
Type :help for more information.

scala>

```

#### Example script:

```
scala> :paste
// Entering paste mode (ctrl-D to finish)

import io.archivesunleashed._
import io.archivesunleashed.matchbox._

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

## Acknowlegements

This work is primarily supported by the [Andrew W. Mellon Foundation](https://uwaterloo.ca/arts/news/multidisciplinary-project-will-help-historians-unlock). Additional funding for the Toolkit has come from the U.S. National Science Foundation, Columbia University Library's Mellon-funded Web Archiving Incentive Award, the Natural Sciences and Engineering Research Council of Canada, the Social Sciences and Humanities Research Council of Canada, and the Ontario Ministry of Research and Innovation's Early Researcher Award program. Any opinions, findings, and conclusions or recommendations expressed are those of the researchers and do not necessarily reflect the views of the sponsors.
