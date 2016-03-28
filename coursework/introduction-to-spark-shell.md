This is a walkthrough to a basic Spark shell.

## Getting Started: Kicking the Tires

You need to run the command so that it finds the warcbase jar (unlike spark shell where you will load it in your first command there). 

To run: `./spark-shell --jars /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar`

First script. To get this working, you need to first type:

```
:paste
```

Then you can paste the following script. When it's looking right, press `Ctrl` and `D` at the same time to get it running.

```
import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
val r = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => ExtractTopLevelDomain(r.getUrl))
  .countItems()
  .take(10)
```

This counts the number of domains found in the collection and displays them. In the above, your result should look like:

>r: Array[(String, Int)] = Array((communist-party.ca,39), (www.gca.ca,39), (greenparty.ca,39), (www.davidsuzuki.org,34), (westernblockparty.com,26), (www.nosharia.com,24), (partimarijuana.org,22), (www.ccsd.ca,22), (canadianactionparty.ca,22), (www.nawl.ca,19))

Try changing the `.take(10)` to `.take(20)` to see what you can find.

## Text Analysis

### All Text

Let's extract the plain text from the collection and dump them to a CSV file.

```
import org.warcbase.spark.rdd.RecordRDD._
import org.warcbase.spark.matchbox.{RemoveHTML, RecordLoader}

RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .map(r => (r.getCrawldate, r.getDomain, r.getUrl, RemoveHTML(r.getContentString)))
  .saveAsTextFile("/home/vagrant/WARC-plain-text")
```

In another terminal window, let's check out our results. You should now have a directory at `/home/vagrant/WARC-plain-text`. In it, you'll see a file named `part-00000`. Let's check it out.

`vim part-00000`

It has worked!

### Text by Domain

Above, we saw that there were 34 pages belonging to `davidsuzuki.org`. Imagine we just want them. The following script adds a new command: `keepDomains`.

```
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

[Consult the documentation here](http://lintool.github.io/warcbase-docs/Spark-Extracting-Domain-Level-Plain-Text/). 

## Network Analysis

Let's run a basic network analysis.

```
import org.warcbase.spark.matchbox._
import org.warcbase.spark.rdd.RecordRDD._
import StringUtils._

val links = RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", sc)
  .keepValidPages()
  .flatMap(r => ExtractLinks(r.getUrl, r.getContentString))
  .map(r => (ExtractTopLevelDomain(r._1).removePrefixWWW(), ExtractTopLevelDomain(r._2).removePrefixWWW()))
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

## Network Analysis: Basic Gephi (or inbrowser D3.JS??)