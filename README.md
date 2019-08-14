# docker-aut
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Introduction

This is the Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](http://archivesunleashed.org/aut/). If you need a hand installing Docker, check out our [Docker Install Instructions](https://github.com/archivesunleashed/docker-aut/wiki/Docker-Install-Instructions), and if you want a quick tutorial, check out our [Hands on With The Archives Unleashed Toolkit](https://github.com/archivesunleashed/docker-aut/wiki/Hands-on-With-The-Archives-Unleashed-Toolkit).

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

You will be brought to a Spark shell. Skip ahead to the [example below](https://github.com/archivesunleashed/docker-aut/tree/README#example).

### Locally

You can also build this Docker image locally with the following steps:

1. `git clone https://github.com/archivesunleashed/docker-aut.git`
2. `cd docker-aut`
3. `docker build -t aut .`
4. `docker run --rm -it aut`

### Overrides

You can add any Spark flags to the build if you need too.

```
$ docker run --rm -it archivesunleashed/docker-aut:0.17.0 /spark/bin/spark-shell --packages "io.archivesunleashed:aut:0.17.0" --conf spark.network.timeout=100000000 --conf spark.executor.heartbeatInterval=6000s
```

Once the build finishes, you should see:

```bash
$ docker run --rm -it aut
Spark context Web UI available at http://c1c9c5ad6970:4040
Spark context available as 'sc' (master = local[*], app id = local-1565792045935).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.4.3
      /_/
         
Using Scala version 2.11.12 (OpenJDK 64-Bit Server VM, Java 1.8.0_212)
Type in expressions to have them evaluated.
Type :help for more information.

scala>

```

## Example

When the image is running, you will be brought to the Spark Shell interface. Try running the following command.

Type

```
:paste
```

And then paste the following script in:

```

import io.archivesunleashed._
import io.archivesunleashed.matchbox._

val r = RecordLoader.loadArchives("/aut-resources/Sample-Data/*.gz", sc)
.keepValidPages()
.map(r => ExtractDomain(r.getUrl))
.countItems()
.take(10)
```

Press Ctrl+D in order to execute the script. You should then see the following:

```
// Exiting paste mode, now interpreting.

import io.archivesunleashed.spark.matchbox._
import io.archivesunleashed.spark.rdd.RecordRDD._
r: Array[(String, Int)] = Array((www.equalvoice.ca,4644), (www.liberal.ca,1968), (greenparty.ca,732), (www.policyalternatives.ca,601), (www.fairvote.ca,465), (www.ndp.ca,417), (www.davidsuzuki.org,396), (www.canadiancrc.com,90), (www.gca.ca,40), (communist-party.ca,39))

scala>

```

In this case, things are working! Try substituting your own data (mounted using the command above).

To quit Spark Shell, you can exit using <kbd>CTRL</kbd>+<kbd>c</kbd>.

## Resources

This build also includes the [aut resources](https://github.com/archivesunleashed/aut-resources) repository, which contains NER libraries as well as sample data from the University of Toronto (located in `/aut-resources`).

The ARC and WARC file are drawn from the [Canadian Political Parties & Political Interest Groups Archive-It Collection](https://archive-it.org/collections/227), collected by the University of Toronto. We are grateful that they've provided this material to us.

If you use their material, please cite it along the following lines:

- University of Toronto Libraries, Canadian Political Parties and Interest Groups, Archive-It Collection 227, Canadian Action Party, http://wayback.archive-it.org/227/20051004191340/http://canadianactionparty.ca/Default2.asp

You can find more information about this collection at [WebArchives.ca](http://webarchives.ca/about).

## Acknowlegements

This work is primarily supported by the [Andrew W. Mellon Foundation](https://uwaterloo.ca/arts/news/multidisciplinary-project-will-help-historians-unlock). Additional funding for the Toolkit has come from the U.S. National Science Foundation, Columbia University Library's Mellon-funded Web Archiving Incentive Award, the Natural Sciences and Engineering Research Council of Canada, the Social Sciences and Humanities Research Council of Canada, and the Ontario Ministry of Research and Innovation's Early Researcher Award program. Any opinions, findings, and conclusions or recommendations expressed are those of the researchers and do not necessarily reflect the views of the sponsors.
