# artemis[![DOI](https://zenodo.org/badge/12352/RamsinghLab/artemis.svg)](https://zenodo.org/badge/latestdoi/12352/RamsinghLab/artemis)[![Travis-CI Build Status](https://travis-ci.org/RamsinghLab/artemis.svg?branch=master)](https://travis-ci.org/RamsinghLab/artemis)  
RNAseq analysis, from raw reads to pathways, typically in a few minutes.  
(Mostly by wrapping [Kallisto](http://pachterlab.github.io/kallisto/) and caching everything we possibly can.)  
Also a sandbox for wacky new ideas about RNA methylation,  
functional analysis of differential transcript abundance,  
and various other sorts of related malarkey (run the demo!).  


```R
suppressPackageStartupMessages(library(artemisData))
## this assumes Kallisto is in ~/bin/
demo("example", package="artemis")
```

![repeat expression](demo/example.png "Plot generated from example code")    
