# Introduction to Spark Notebooks

This is a walkthrough to a basic Spark notebook. **In our warcbase workflow, we use the notebook to often prototype on one ARC or WARC file, before running production on a directory.**

## Step One: Getting Started 
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

## Step Two: Prototyping Scripts: Text Analysis

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

## Step Three: Slightly More Advanced Analysis

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
RecordLoader.loadArchives(warc, 
sc) 
.keepValidPages() 
.map(r => { 
val t = RemoveHTML(r.getContentString) 
val len = 100 
(r.getCrawldate, createClickableLink(r.getUrl, 
r.getCrawldate), if ( t.length > len ) t.substring(0, len) else t)}) 
.collect()
```

Now you should have beautiful clickable links to explore.

## Step Four: Switching to Shell

Now that we have seen the basics of the Spark Notebook, [let's continue to the basics of the Spark Shell](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/introduction-to-spark-shell.md).