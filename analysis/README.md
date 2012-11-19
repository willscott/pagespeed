## Analysis

These scripts help to summarize page load data from multiple machines and times.

#### Usage


Mathematica can quickly barchart a set of data for initial visualization via:

> nodes = FileNames["*", NotebookDirectory[] <> "data"];
> data = Map[ReadList[#, {Word, Number}]&, nodes];
> nodeMeans = Map[Mean[#[[All,2]]]&, data];
> BarChart[Sort[nodeMeans]]
