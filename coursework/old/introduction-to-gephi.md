# Quick Walkthrough with Gephi

In this repository, you'll find a file – [all-links.gdf](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/all-links.gdf). This is the output from the GDF extractor script that you ran in the [Spark Shell lesson](https://github.com/web-archive-group/warcbase_workshop_vagrant/blob/master/coursework/introduction-to-spark-shell.md).

We can use this to quickly see some of the basics of Gephi.

## Step One: Open Gephi and Open All-Links.gdf

This is pretty straightforward. When you open Gephi, you'll see a prompt that allows you to open a file. Select the file, and then at this window, create a "new graph."

![Figure 1](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/1.import.png)
**Figure 1: Importing a new graph.**

## Step Two: Create Labels

This is a bit counterintuitive. You'll need to click "Copy data to other column," and copy data from 'Id' to Label. 

![Figure 2](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/2.copy-label.png)
**Figure 2: Setting up labels.**

## Step Three: Overview

Click on "overview" and you should see this. A not too shabby network diagram. Note that this example is conceptual, because the actual web archive we're working with is so small.

![Figure 3](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/3.lay-out.png)
**Figure 3: Your first layout!**

## Step Four: Resizing Nodes

Let's resize the nodes so that the more inbound links there are, the bigger it is. In the upper left, select "Nodes," then "InDegree." Click the "diamond" logo and use a Min Size of 2 and a Max size of 50. See the Figure below.

![Figure 4](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/4.in-degree.png)
**Figure 4: Resizing nodes based on in-degree.**

## Step Five: Layout

Let's play with layouts. Select "Fruchterman Reingold." There are generally better ones to use, but with this layout it's so simple. Select it and click "run." You should see as below:

![Figure 5](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/5.layout-change.png)
**Figure 5: Changing layouts.**

## Step Six: Modularity

Let's see if there are any modularity classes (a rough community detection algorithm). Select "statistics" in the upper left, then "run" next to modularity.

Then in the upper left, select "partition," then "nodes," then click the green refresh button. You'll then be able to select "Modularity Class" and finally, "apply."

![Figure 6](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/6.modularity.png)
**Figure 6: Searching for community.**

## Step Seven: Profit?

Voila! You're done for now. click on the "Preview" button and try out a few different visualization options. Bask in the glory of your chart.

![Figure 7](https://raw.githubusercontent.com/web-archive-group/WAHR/master/images/gephi-walkthrough/7.preview.png)
**Figure 7: Previewing a visualization.**
