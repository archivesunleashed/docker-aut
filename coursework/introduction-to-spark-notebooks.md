This is a walkthrough to a basic Spark notebook.

First, you need to load the warcbase jar. Paste this into the first command and press the play button.

```
:cp /home/vagrant/project/warcbase/target/warcbase-0.1.0-SNAPSHOT-fatjar.jar
```

Second, you need to import the classes.

```
import org.warcbase.spark.matchbox._ 
import org.warcbase.spark.rdd.RecordRDD._ 
```

Third, let's run a test script. The following will load one of the ARC files from the sample data directory and count the various top-level domains that you can find in it.

```
val r = 
RecordLoader.loadArchives("/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz", 
sc) 
.keepValidPages() 
.map(r => ExtractTopLevelDomain(r.getUrl)) 
.countItems() 
.take(10) 
```

Click on the pie chart tab at bottom, and you'll see the breakdown of domains in all of its glory.

Now we can do scripts that we ran in the shell. For example, extracting text:

```
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

We can set variables to make our life easier, such as:

```
val warc="/home/vagrant/project/warcbase-resources/Sample-Data/ARCHIVEIT-227-UOFTORONTO-CANPOLPINT-20060622205612-00009-crawling025.archive.org.arc.gz"
```

Now instead of typing the path, we can just use `warc`. Try running that cell and replacing it in the script above.

Finally, we can do some neat tricks with browser injection. Run the following cell:

```
def createClickableLink(url: String, date: String): String = { 
"<a href='http://web.archive.org/web/" + date + "/" + url + "'>" + 
url + "</a>" 
} 
```

Now let's re-run a familiar command from before but with this `createClickableLink` command and our `warc` variable.

```
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