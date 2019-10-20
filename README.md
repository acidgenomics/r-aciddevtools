# bb8

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Trusty sidekick for [R][] package development.

## Installation

This package is intended for internal use and will not be published on [CRAN][].

```r
if (!require("BiocManager")) {
    install.packages("BiocManager")
}
BiocManager::install("remotes")
BiocManager::install("acidgenomics/bb8")
```

[cran]: https://cran.r-project.org/
[r]: https://www.r-project.org/
