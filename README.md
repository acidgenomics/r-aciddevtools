# bb8

[![Build Status](https://travis-ci.org/steinbaugh/bb8.svg?branch=master)](https://travis-ci.org/steinbaugh/bb8)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![codecov](https://codecov.io/gh/steinbaugh/bb8/branch/master/graph/badge.svg)](https://codecov.io/gh/steinbaugh/bb8)

Trusty sidekick for [R][] package development.


## Installation

This is an [R][] package.

### [Bioconductor][] method

```{r}
source("https://bioconductor.org/biocLite.R")
biocLite("devtools")
biocLite(
    "steinbaugh/bb8",
    dependencies = c("Depends", "Imports", "Suggests")
)
```


[Bioconductor]: https://bioconductor.org
[R]: https://www.r-project.org
