# bb8

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

Trusty sidekick for [R][] package development.

## Installation

### [Bioconductor][] method

We recommend installing the package with [BiocManager][].

```r
if (!require("BiocManager")) {
    install.packages("BiocManager")
}
BiocManager::install("remotes")
BiocManager::install("acidgenomics/bb8")
```

[Bioconductor]: https://bioconductor.org
[BiocManager]: https://cran.r-project.org/package=BiocManager
[R]: https://www.r-project.org
