# Spark Shell: Basic Introduction

This is a walkthrough to a basic Spark shell. In our warcbase workflow, we often prototype new scripts with the Spark Notebook, before running our jobs directly with Shell. You can [find our earlier Spark Notebook lesson here](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/introduction-to-spark-notebooks.md). 

## Step One: Getting Started

You need to run the command so that it finds the warcbase jar (unlike spark shell where you will load it in your first command there). 

To run, navigate to the spark-shell directory by

```bash
cd /home/vagrant/project/spark-1.5.1-bin-hadoop2.6/bin
```

Then run with:

```bash
./spark-shell --jars /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar
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
val r = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => ExtractDomain(r.getUrl))
  .countItems()
  .take(10)
```

This counts the number of domains found in the collection and displays them. In the above, your result should look like:

>r: Array[(String, Int)] = Array((communist-party.ca,39), (www.gca.ca,39), (greenparty.ca,39), (www.davidsuzuki.org,34), (westernblockparty.com,26), (www.nosharia.com,24), (partimarijuana.org,22), (www.ccsd.ca,22), (canadianactionparty.ca,22), (www.nawl.ca,19))

Try changing the `.take(10)` to `.take(20)` to see what you can find.

## Step Two: Textual Analysis

### All Text

Let's extract the plain text from the collection and dump it to a file.

```scala
import org.warcbase.spark.rdd.RecordRDD._
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}

RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => (r.getCrawldate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/vagrant/WARC-plain-text")
```

In another terminal window, let's check out our results. You should now have a directory at `/home/vagrant/WARC-plain-text`. In it, you'll see a file named `part-00000`. Let's check it out.

`vim part-00000`

It has worked! Note that if you run this script again, it will fail immediately: there cannot be a directory with the same name as the one you are attempting to create.

### Text by Domain

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

### Other filters

There are other filters at play here. You can filter by language, year, patterns in URLs, and beyond. Let's play for a bit.

[Consult the documentation here](http://lintool.github.io/warcbase-docs/Spark-Extracting-Domain-Level-Plain-Text/). Try a few different filters. Nick and Ian will walk around the room to make sure you're all online.

## Step Three: Network Analysis

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

Let's say you wanted to do some more substantial network analysis with this collection. We can actually generate a file format that can be loaded directly by Gephi.

```scala
import org.warcbase.spark.matchbox.{ExtractDomain, ExtractLinks, RecordLoader, WriteGDF}
import org.warcbase.spark.rdd.RecordRDD._

val links = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => (r.getCrawldate, ExtractLinks(r.getUrl, r.getContentString)))
  .flatMap(r => r._2.map(f => (r._1, ExtractDomain(f._1).replaceAll("^\\s*www\\.", ""), ExtractDomain(f._2).replaceAll("^\\s*www\\.", ""))))
  .filter(r => r._2 != "" && r._3 != "")
  .countItems()
  .filter(r => r._2 > 5)

WriteGDF(links, "/home/vagrant/all-links.gdf")
```

We may return to Gephi if we have time or you can consult the [Gephi lesson available here in our documentation](http://lintool.github.io/warcbase-docs/Gephi-Converting-Site-Link-Structure-into-Dynamic-Visualization/).

## Step Four: Image Analysis

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

## Next Steps

Let's try setting it up on your own servers, or in a real production environment. We'll be around to lend hands on help.
