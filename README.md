# AcidDevTools

![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)

Trusty sidekick for [R][] package development.

## Installation

This is an [R][] package.

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
install.packages(
    pkgs = "AcidDevTools",
    repos = c(
        "https://r.acidgenomics.com",
        BiocManager::repositories()
    ),
    dependencies = TRUE
)
```

[r]: https://www.r-project.org/
