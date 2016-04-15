# Hands on With Warcbase
# IIPC WAC 2016, Ian Milligan and Nick Ruest

## Table of Contents

1. [Installation](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#installation)
2. [Testing](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#testing)
3. [Spark Notebook](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#spark-notebook)
3.1. [Getting Started](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-one-getting-started)
3.2. [Learning Spark Notebook](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/lessonplan.md#step-two-learning-spark-notebook)
3.3. [Text Analysis]

## Installation

### Option One: VirtualBox

Download [VirtualBox from here](https://www.virtualbox.org) and install it. You also need to download the [OVA file from here](http://alpha.library.yorku.ca/releases/warcbase_workshop/Warcbase_workshop_VM.ova). Be careful, it's a 6.4GB download.

Your VirtualBox will hopefully look like this:

![VM manager](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/iipc-workshop/vm-manager.png)

Go to your File menu, select "Import Appliance," and select the OVA file. Press "continue," then "Import."

![VM load](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/iipc-workshop/vm-import.png)

Then press "Start."

If you're lucky, the terminal window will appear.

### Option Two: Vagrant

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
  - username: `vagrant`
  - password: `vagrant`

Here are some other example commands:
* `ssh -p 2222 vagrant@localhost` - will connect to the machine using `ssh`;
* `scp -P 2222 somefile.txt vagrant@localhost:/destination/path` - will copy `somefile.txt` to your vagrant machine. 
  - You'll need to specify the destination. For example, `scp -P 2222 WARC.warc.gz vagrant@localhost:/home/vagrant` will copy WARC.warc.gz to the home directory of the vagrant machine.
* `rsync --rsh='ssh -p2222' -av somedir vagrant@localhost:/home/vagrant` - will sync `somedir` to your home directory of the vagrant machine.

## Testing

Let's make sure we can get spark notebook running. On vagrant, connect using `vagrant ssh`. 

If you used VirtualBox, you have two options. On OS X or Linux, you can minimize your window, open your terminal, and connect to it using: `ssh -p 2222 vagrant@localhost`.

On Windows, you'll have to use your VirtualBox terminal.

Either way, you should be at a prompt that looks like:

```
vagrant@warcbase:~$
```

### Testing Spark Shell

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

scala>
```

If this works, things are going well.

## Spark Notebook

In our warcbase workflow, we use the notebook to often prototype on one ARC or WARC file, before running production on a directory. 

### Step One: Getting Started

To run spark notebook, type the following:

* `vagrant ssh` (if on vagrant; if you downloaded the ova file and are running with VirtualBox you do not need to do this)
* `cd project/spark-notebook-0.6.2-SNAPSHOT-scala-2.10.4-spark-1.5.1-hadoop-2.6.0-cdh5.4.2/bin`
* `./spark-notebook -Dhttp.port=9000 -J-Xms1024m`
* Visit http://127.0.0.1:9000/ in your web browser.

![Spark Notebook](https://cloud.githubusercontent.com/assets/218561/14062458/f8c6a842-f375-11e5-991b-c5d6a80c6f1a.png)

### Step Two: Learning Spark Notebook

First, you need to load the warcbase jar. Paste this into the first command and press the play button.

```bash
:cp /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar
```

Second, you need to import the classes.

```scala
import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
```

Third, let's run a test script. The following will load one of the ARC files from the sample data directory and count the various top-level domains that you can find in it.

```scala
val r = 
  RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", 
sc) 
  .keepValidPages() 
  .map(r => ExtractDomain(r.getUrl)) 
  .countItems() 
  .take(10) 
```

Click on the pie chart tab at bottom, and you'll see the breakdown of domains in all of its glory.

### Step Three: Prototyping Scripts: Text Analysis

As noted, we generally recommend that people use the Spark Notebook to prototype scripts that they'll later adapt and run in their Spark Shell. 

Let's give it a try by adapting some of the scripts that we might run in the Shell. For example, extracting text:

```scala
val r = 
  RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", 
sc) 
  .keepValidPages() 
  .map(r => { 
    val t = RemoveHTML(r.getContentString) 
    val len = 100 
    (r.getCrawldate, r.getUrl, if ( t.length > len ) t.substring(0, len) else t)}) 
  .collect() 
```

### Step Four: Slightly More Advanced Analysis

We can set variables to make our life easier, such as:

```scala
val warc="/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz"
```

Now instead of typing the path, we can just use `warc`. Try running that cell and replacing it in the script above.

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
    (r.getCrawldate, createClickableLink(r.getUrl, 
    r.getCrawldate), if ( t.length > len ) t.substring(0, len) else t)}) 
.collect()
```

Now you should have beautiful clickable links to explore.

#### Step Five: More sophisticated commands

We would normally switch to Spark Shell at this point, but given the amount of Windows machine let's learn new commands in notebook.

For example, to grab the plain text from the collection and save it to a file, we could use:

```scala
import org.warcbase.spark.rdd.RecordRDD._
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}

RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => (r.getCrawldate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/vagrant/WARC-plain-text")
```

You should now have a directory in `/home/vagrant/` with the plain text. I will show you it.

##### Text by Domain

Above, we saw that there were 34 pages belonging to `davidsuzuki.org`. Imagine we just want them. The following script adds a new command: `keepDomains`.

```scala
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}
import org.warcbase.spark.rdd.RecordRDD._

RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .keepDomains(Set("www.davidsuzuki.org"))
  .map(r => (r.getCrawldate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/vagrant/WARC-plain-text-David-Suzuki")
```

It should work as well. Note that your command `keepDomains(Set("www.davidsuzuki.org"))` needs to match the string you found above. 

##### Other filters

There are other filters at play here. You can filter by language, year, patterns in URLs, and beyond. Let's play for a bit.

[Consult the documentation here](http://lintool.github.io/warcbase-docs/Spark-Extracting-Domain-Level-Plain-Text/). Try a few different filters. Nick and Ian will walk around the room to make sure you're all online.

### Step Five: Network Analysis

Let's run a basic network analysis.

```scala
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._
import StringUtils._

val links = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .flatMap(r => ExtractLinks(r.getUrl, r.getContentString))
  .map(r => (ExtractDomain(r._1).removePrefixWWW(), ExtractDomain(r._2).removePrefixWWW()))
  .filter(r => r._1 != "" && r._2 != "")
  .countItems()
  .filter(r => r._2 > 5)

links.saveAsTextFile("/home/vagrant/WARC-links-all/")
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

### Step Six: Image Analysis

You may want to do work with images. The following script finds all the image URLs and displays the top 10.

```scala
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._

val links = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
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

# Next Steps

Let's try setting it up on your own servers, or in a real production environment. We'll be around to lend hands on help.