# docker-aut
[![Docker Stars](https://img.shields.io/docker/stars/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![Docker Pulls](https://img.shields.io/docker/pulls/archivesunleashed/docker-aut.svg)](https://hub.docker.com/r/archivesunleashed/docker-aut/)
[![LICENSE](https://img.shields.io/badge/license-Apache-blue.svg?style=flat-square)](./LICENSE)
[![Contribution Guidelines](http://img.shields.io/badge/CONTRIBUTING-Guidelines-blue.svg)](./CONTRIBUTING.md)

## Attention

The `master` branch aligns with the `master` branch of [The Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). It can be unstable at times. Stable [branches](https://github.com/archivesunleashed/docker-aut/branches) are available for each [AUT release](https://github.com/archivesunleashed/aut/releases).

## Introduction

This is the Docker image for [Archives Unleashed Toolkit](https://github.com/archivesunleashed/aut). [AUT](https://github.com/archivesunleashed/aut) documentation can be found [here](https://github.com/archivesunleashed/aut-docs/tree/master/current). If you need a hand installing Docker, check out our [Docker Install Instructions](https://github.com/archivesunleashed/aut/wiki/Docker-Install), and if you want a quick tutorial, check out our [Toolkit Lesson](https://github.com/archivesunleashed/aut-docs/blob/master/current/toolkit-walkthrough.md).

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
docker run --rm -it archivesunleashed/docker-aut:latest /spark/bin/spark-shell --packages "io.archivesunleashed:aut:0.80.1-SNAPSHOT" --conf spark.network.timeout=100000000 --conf spark.executor.heartbeatInterval=6000s
```

Once the build finishes, you should see:

```bash
20/06/18 09:43:08 WARN Utils: Your hostname, bomba resolves to a loopback address: 127.0.1.1; using 192.168.4.94 instead (on interface wlp2s0)
20/06/18 09:43:08 WARN Utils: Set SPARK_LOCAL_IP if you need to bind to another address
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/home/nruest/bin/spark-3.0.0-bin-hadoop2.7/jars/spark-unsafe_2.12-3.0.0.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
20/06/18 09:43:08 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Spark context Web UI available at http://192.168.4.94:4040
Spark context available as 'sc' (master = local[*], app id = local-1592487792942).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.0.0
      /_/

Using Scala version 2.12.10 (OpenJDK 64-Bit Server VM, Java 11.0.7)
Type in expressions to have them evaluated.
Type :help for more information.

scala>
```

### PySpark

It is also possible to start an interactive PySpark console. This requires specifying Python bindings and the `aut` package, both of which are included in the Docker image under `/aut/target`.

To lauch an interactive PySpark console:

```
docker run --rm -it archivesunleashed/docker-aut /spark/bin/pyspark --py-files /aut/target/aut.zip --jars /aut/target/aut-0.80.1-SNAPSHOT-fatjar.jar
```

Once the build finishes you should see:

```bash
Python 3.7.3 (default, Dec 20 2019, 18:57:59)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.apache.spark.unsafe.Platform (file:/spark/jars/spark-unsafe_2.12-3.0.0.jar) to constructor java.nio.DirectByteBuffer(long,int)
WARNING: Please consider reporting this to the maintainers of org.apache.spark.unsafe.Platform
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
20/06/18 14:02:05 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /__ / .__/\_,_/_/ /_/\_\   version 3.0.0
      /_/

Using Python version 3.7.3 (default, Dec 20 2019 18:57:59)
SparkSession available as 'spark'.
>>>
```

For more information, see the [Archives Unleashed Toolkit with PySpark](https://github.com/archivesunleashed/aut#archives-unleashed-toolkit-with-pyspark) of the Toolkit README.

Specifying Java/Scala packages with `--jars` will use local (inside the container) JAR files.
It is also possible to download these packages from maven central by specifying `--packages` instead of `--jars`.

_Note: downloading packages is taking a while and must be done every time the container starts;
using `--jars` is faster!_

```bash
$ docker run -it --rm archivesunleashed/docker-aut \
  /spark/bin/pyspark \
  --py-files /aut/target/aut.zip \
  --packages "io.archivesunleashed:aut:0.70" # Download Java/Scala packages from maven central
```
### Running Python Scripts through `spark-submit`

Using the Shell it is, for example, not possible to save a script and run it again, at a later time.
To run a Python script which exists in a separate file pass it to `spark-submit`, which is also part of the AUT Docker container.
Running a Python script through `spark-submit` requires modifications to `docker run` and the creation of a `SparkContext` and an `SQLContext` inside the script.

First, make sure your script imports and creates both a `SparkContext` and an `SQLContext`, as shown below.

```python
from pyspark import SparkContext, SQLContext   # required!
from aut import *

sc = SparkContext.getOrCreate()                # create SparkContext...
sqlContext = SQLContext(sc)                    # and SQLContext, based on SparkContext

# now use WebArchive as usual
WebArchive(sc, sqlContext, "/in").all() \      # process WARCs residing in /in, see below.
  .select("url") \
  .write.text("/out/result/")
```

## Example

The Python script to pass `spark-submit` exists outside the Docker container, the same holds for WARC files to be processed by that script;
finally, the results generated by the script must be retained after the Docker container exists and gets removed.
Therefore, it is required to bind several local directories to directories inside the Docker, supplying `-v` to `docker run`.
Using `-v`, a host file or directory (local machine) is bound to a container file or directory (inside the container).

On the local machine, it is assumed that the WARCs to process have been placed inside `in-local`, the script `process.py` has been put into `script-local` and the output generated is expected inside the directory `out-local`. _Note: the suffix `-local` has been appended for clarity, to distinguish host directories from container directories._

```
in-local
  archive1.warc.gz
  archive2.warc.gz
  archive3.warc.gz
out-local
  # (no output yet)
script-local
  process.py
```

With everything in place, submit the Python script to `spark-submit` with the following invocation of `docker run`. The host directories `in-local`, `out-local` and `script-local` will be mounted to the container directories `/in`, `/out` and `/script`, respectively.

```shell
docker run --rm -it \
       -v $(pwd)/in-local/:/in \
       -v $(pwd)/out-local/:/out \
       -v $(pwd)/script-local/:/script \
       archivesunleashed/docker-aut \
       /spark/bin/spark-submit \
       --driver-memory 4G \
       --py-files /aut/target/aut.zip \
       --jars /aut/target/aut-0.80.1-SNAPSHOT-fatjar.jar \
       /script/process.py
```

All flags after `/spark/bin/spark-submit` will be passed to Spark.
The `--driver-memory` flag is optional; when processing large amounts of data, it may be necessary to allow more memory to Spark. See [here](https://aut.docs.archivesunleashed.org/docs/aut-at-scale) for details.

Inside the script, which is running inside the container, the WARC files can be found in `/in`, results should be written into `/out` and the script itself resides in `/script`.

After executing the script, the results produced can be found inside `out-local`.

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
+----------+--------------------+--------------------+--------------------+
>>>>>>> 16b1756... Updates for aut-0.80.0 release.
|crawl_date|                 src|                dest|              anchor|
+----------+--------------------+--------------------+--------------------+
|  20060622|http://www.gca.ca...|http://www.cleann...|                    |
|  20060622|http://www.gca.ca...|http://www.quidno...|Quid Novis Intern...|
|  20060622|http://www.ppforu...|http://www.adobe....|                    |
|  20060622|http://www.ppforu...|mailto:kelly.cyr@...|           Kelly Cyr|
|  20060622|http://www.ppforu...|http://www.renouf...|   Renouf Publishing|
|  20060622|http://www.ppforu...|http://bayteksyst...|   bayteksystems.com|
|  20060622|http://communist-...|http://www.calend...|  www.calendarix.com|
|  20060622|http://communist-...|http://www.calend...|                    |
|  20060622|http://communist-...|mailto:webmaster@...|webmaster@calenda...|
|  20060622|http://www.ccsd.c...|http://www.ccsd.c...|                    |
+----------+--------------------+--------------------+--------------------+
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
+----------+--------------------+--------------------+--------------------+
|crawl_date|                 src|                dest|              anchor|
+----------+--------------------+--------------------+--------------------+
|  20060622|http://www.gca.ca...|http://www.cleann...|                    |
|  20060622|http://www.gca.ca...|http://www.quidno...|Quid Novis Intern...|
|  20060622|http://www.ppforu...|http://www.adobe....|                    |
|  20060622|http://www.ppforu...|mailto:kelly.cyr@...|           Kelly Cyr|
|  20060622|http://www.ppforu...|http://www.renouf...|   Renouf Publishing|
|  20060622|http://www.ppforu...|http://bayteksyst...|   bayteksystems.com|
|  20060622|http://communist-...|http://www.calend...|  www.calendarix.com|
|  20060622|http://communist-...|http://www.calend...|                    |
|  20060622|http://communist-...|mailto:webmaster@...|webmaster@calenda...|
|  20060622|http://www.ccsd.c...|http://www.ccsd.c...|                    |
+----------+--------------------+--------------------+--------------------+
only showing top 10 rows

>>>
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
