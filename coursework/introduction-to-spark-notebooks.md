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

