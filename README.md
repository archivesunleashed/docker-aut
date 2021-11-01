# docker-aut
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Attention

The `main` branch aligns with the `main` branch of [The Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). It can be unstable at times. Stable [branches](https://github.com/archivesunleashed/docker-aut/branches) are available for each [AUT release](https://github.com/archivesunleashed/aut/releases).

## Introduction

This is the Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](https://aut.docs.archivesunleashed.org/docs/home). If you need a hand installing Docker, check out our [Docker Install Instructions](https://github.com/archivesunleashed/docker-aut/wiki/Docker-Install-Instructions), and if you want a quick tutorial, check out our [Toolkit Lesson](https://aut.docs.archivesunleashed.org/docs/toolkit-walkthrough).

The Archives Unleashed Toolkit is part of the broader [Archives Unleashed Project](http://archivesunleashed.org/).

## Requirements

Install the following dependencies:

1. [Docker](https://www.docker.com/get-docker)

## Use

### Docker Hub

Make sure that Docker is running. Run the following command to launch the Apache Spark shell with `aut` available:

`docker run --rm -it archivesunleashed/docker-aut`

If you want to mount your own data, replace `/path/to/your/data` in the following command with the directory where your ARC or WARC files are contained.

`docker run --rm -it -v "/path/to/your/data:/data" archivesunleashed/docker-aut`

You will be brought to a Spark shell. Skip ahead to the [example below](https://github.com/archivesunleashed/docker-aut#example).

### Locally

You can also build this Docker image locally with the following steps:

1. `git clone https://github.com/archivesunleashed/docker-aut.git`
2. `cd docker-aut`
3. `docker build -t aut .`
4. `docker run --rm -it aut`

### Overrides

You can add any Spark flags to the build if you need too.

```
docker run --rm -it archivesunleashed/docker-aut:latest /spark/bin/spark-shell --packages "io.archivesunleashed:aut:0.90.5-SNAPSHOT" --conf spark.network.timeout=100000000 --conf spark.executor.heartbeatInterval=6000s
```

Once the build finishes, you should see:

```bash
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/spark/jars/spark-unsafe_2.12-3.1.1.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
21/11/01 17:27:36 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://5f477f5dcab5:4040
Spark context available as 'sc' (master = local[*], app id = local-1635787667490).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.1.1
      /_/
         
Using Scala version 2.12.10 (OpenJDK 64-Bit Server VM, Java 11.0.13)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```

### PySpark

It is also possible to start an interactive PySpark console. This requires specifying Python bindings and the `aut` package, both of which are included in the Docker image under `/aut/target`.

To lauch an interactive PySpark console:

```
docker run --rm -it archivesunleashed/docker-aut /spark/bin/pyspark --py-files /aut/target/aut.zip --jars /aut/target/aut-0.90.5-SNAPSHOT-fatjar.jar
```

Once the build finishes you should see:

```bash
Python 3.9.2 (default, Feb 28 2021, 17:03:44) 
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/spark/jars/spark-unsafe_2.12-3.1.1.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
21/11/01 17:41:55 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.1.1
      /_/

Using Python version 3.9.2 (default, Feb 28 2021 17:03:44)
Spark context Web UI available at http://d03127085be4:4040
Spark context available as 'sc' (master = local[*], app id = local-1635788517329).
SparkSession available as 'spark'.
>>> 
```

## Example


### Spark Shell (Scala)

When the image is running, you will be brought to the Spark Shell interface. Try running the following command.

Type

```
:paste
```

And then paste the following script in:

```scala
import io.archivesunleashed._

RecordLoader.loadArchives("/aut-resources/Sample-Data/*.gz", sc).webgraph().show(10)
```

Press Ctrl+D in order to execute the script. You should then see the following:

```
+----------+--------------------+--------------------+------+
|crawl_date|                 src|                dest|anchor|
+----------+--------------------+--------------------+------+
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
+----------+--------------------+--------------------+------+
only showing top 10 rows

import io.archivesunleashed._
```

In this case, things are working! Try substituting your own data (mounted using the command above).

To quit Spark Shell, you can exit using <kbd>CTRL</kbd>+<kbd>c</kbd>.

### PySpark

When the images is running, you will be brought to the PySpark interface. Try running the following commands:

```python
from aut import *
WebArchive(sc, sqlContext, "/aut-resources/Sample-Data/*.gz").webgraph().show(10)
```

You should then see the following:

```
+----------+--------------------+--------------------+------+                   
|crawl_date|                 src|                dest|anchor|
+----------+--------------------+--------------------+------+
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
|  20060622|http://www.gca.ca...|http://www.gca.ca...|      |
+----------+--------------------+--------------------+------+
only showing top 10 rows
```

In this case, things are working! Try substituting your own data (mounted using the command above).

To quit the PySpark console, you can exit using <kbd>CTRL</kbd>+<kbd>c</kbd>.

## Resources

This build also includes the [aut resources](https://github.com/archivesunleashed/aut-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/aut-resources`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/about).

## Acknowlegements

This work is primarily supported by the [Andrew W. Mellon Foundation](https://uwaterloo.ca/arts/news/multidisciplinary-project-will-help-historians-unlock). Additional funding for the Toolkit has come from the U.S. National Science Foundation, Columbia University Library's Mellon-funded Web Archiving Incentive Award, the Natural Sciences and Engineering Research Council of Canada, the Social Sciences and Humanities Research Council of Canada, and the Ontario Ministry of Research and Innovation's Early Researcher Award program. Any opinions, findings, and conclusions or recommendations expressed are those of the researchers and do not necessarily reflect the views of the sponsors.
