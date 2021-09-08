## AcidDevTools 0.4.1 (2021-09-08)

### Minor changes

- `coverage`: Default coverage threshold bumped from 80% to 95%.
- `installRecommendedPackages`: Added spatialreg package.
- `test`: Improved error message on unit test failure. Now using named argument
  in `stopifnot` call, which is supported in R 4.0.

## AcidDevTools 0.4.0 (2021-08-23)

### Major changes

- Finally added code coverage for the package, using testthat.
- Added working examples when feasible for all functions.
- `install`, `installGitHub`, `installedPackages`, `updatePackages` now
  support a `lib` argument.
- `installGitHub`: Switched `release` argument to `tag` argument. User must now
  declare a specific tag instead of supporting install from default branch.

### Minor changes

- Consolidated alias functions: `cd`, `clear`, `d`, `la`.
- `check`: Added support for `lints` and `urls` overrides. Still enabled by
  default (non-breaking change), and calls lintr, urlchecker packages
  internally.
- `dev`: Reduced the number of packages loaded. Now calls magrittr, testthat,
  goalie, and basejump.
- `findAndReplace`: Reworked internal code using BiocParallel instead of
  parallel package, and switched from readr to base R for line import/export.
- `getCurrentGitHubVersion`: Now supports multiple version checks in a single
  call, defined by the `repo` argument.
- `installRecommendedPackages`: Updated default list.
- Bioconductor validity with `valid` now passes `lib` argument (see above).
- Default path in formal arguments has been changed from `"."` to `getwd()`.
- `load_all`: Simplified default alias.

## AcidDevTools 0.3.16 (2021-07-19)

- Reworked `check`, `dev`, and `test` functions.
- Tweaked `test` to call `testthat::test_dir` directly again.
- Reworked default handling of code coverage. Disabled automatic code
  coverage report checking when calling `test`.
- Simplified the number of default packages loaded in `dev`.
- Cleaned up internal comments for `load_all`.

## AcidDevTools 0.3.15 (2021-07-06)

- Reorganized internal functions.
- `check`: Now always runs `test` internally, since `rcmdcheck` in some cases
  doesn't run unit tests in R 4.1.
- Migrated from using pryr to lobstr.
- Removed unused `memfree` function.

## AcidDevTools 0.3.14 (2021-06-04)

- `check`: Added `biocCheck` and `coverage` arguments.
  Now checking package coverage for at least 80% coverage by default.

## AcidDevTools 0.3.13 (2021-05-19)

- `installRecommendedPackages`: Added GRmetrics and dr4pl, for
  IC50 calculations.

## AcidDevTools 0.3.12 (2021-05-18)

- Fix for BiocManager / install.packages handling in R 4.1

## AcidDevTools 0.3.11 (2021-05-18)

- Removed magrittr as an import, now that base R supports pipe in 4.1.

## AcidDevTools 0.3.10 (2021-05-18)

- `check`: Made lintr, urlchecker, and BiocCheck checks optional if these
  packages are not installed. This can be the case inside Docker images.

## AcidDevTools 0.3.9 (2021-05-18)

- Removed `clearWarnings` from exports, which doesn't seem to be compatible
  with R 4.1 due to inability to assign `last.warning` to base environment.
- `memfree`: Now using `%s` instead of `%d` internally in `sprintf` call,
  due to hardened change in R 4.1.

## AcidDevTools 0.3.8 (2021-05-12)

- `installRecommendedPackages`: Made this function more modular, allowing for
  the user to specify which types of extra packages should be installed.
  Applies primarily to Bioconductor (i.e. next-generation sequencing) analysis
  packages, which can often be quite large and inappropriate for a compact
  virtual machine instance.

## AcidDevTools 0.3.7 (2021-05-10)

- `install`: Bug fix for `stopifnot` check on `makevarsFile`.
- Updated references to available and urlchecker packages.

## AcidDevTools 0.3.6 (2021-05-03)

- `install`: Improved `autoconf` handling for data.table, now using
  `~/.R/Makevars` dynamically to define gfortran GCC compiler options used
  to enable OpenMP support for parallel threads on macOS.

## AcidDevTools 0.3.5 (2021-04-30)

- `install`: Improved `autoconf` handling for data.table, geos, rgl, and sf
  packages. Refer to internal `.autoconf` code for details.

## AcidDevTools 0.3.4 (2021-04-27)

- `install` now ensures data.table gets built from source automatically.
  Currently on macOS, the prebuilt CRAN binaries don't enable parallel threading
  by default due to improper OpenMP configuration, which is annoying. Since
  we install the fxcoudert GCC compiler by default, let's use this instead
  to enable OpenMP and parallel processing support. May want to consider a
  similar approach in the future for Rcpp, etc.

## AcidDevtools 0.3.3 (2021-04-27)

- Increased verbosity of `dyn.load` calls during `load_all`, which is very
  useful for debugging package load time and dependency chain.

## AcidDevTools 0.3.2 (2021-04-23)

- `install`: Added new `autoconf` option, which will automatically set internal
  configuration overrides automatically for some problematic packages
  (e.g. rgl on macOS).

## AcidDevTools 0.3.1 (2021-03-04)

- `load_all` alias now has `helpers = FALSE` set by default, to speed up
  package loads significantly.

## AcidDevTools 0.3.0 (2021-02-04)

- Renamed package from "bb8" to "AcidDevTools".

## bb8 0.2.50 (2021-01-31)

- Added veloviz and liger to recommended packages.

## bb8 0.2.49 (2021-01-15)

- `check`: Improved package name detection, which doesn't always correspond
  to the directory name. Using desc package to harden this. Also a couple of
  bug fixes related to checking outside of package working directory.
- `printComment`: Bug fix to better set the width.
- Removed `pc` alias, which can get masked by Bioconductor.

## bb8 0.2.48 (2020-12-16)

- Added `pc` alias for `printComment`, to reduce the amount of typing required
  during an interactive scripting session.

## bb8 0.2.47 (2020-12-09)

- `check`: Hardened against lintr check failure.

## bb8 0.2.46 (2020-12-07)

- Fix for packages with dependency issues: Seurat and dendsort.

## bb8 0.2.45 (2020-12-03)

- `install`: Improved automatic definition of `type` internally for manual
  local package installs.

## bb8 0.2.44 (2020-11-25)

- `updatePackages`: Improved error message handling when internal BiocManager
  validity checks fail. Wrapped using `tryCatch` call to better show which
  packages are responsible for the check failure.

## bb8 0.2.43 (2020-11-24)

- `installRecommendedPackages`: Install all packages by default.

## bb8 0.2.42 (2020-11-11)

- Added `currentBiocVersion`, which checks for current Bioconductor release
  version.
- `updatePackages` now automatically upgrades the Bioconductor release, when
  applicable.

## bb8 0.2.41 (2020-11-06)

- Renamed `installDefaultPackages` to `installRecommendedPackages`.
- Fixed internal Bioconductor installation code.

## bb8 0.2.40 (2020-11-05)

- `install`: Attempt to improve internal repository handling.
- `updatePackages`: Attempt to improve internal repository handling.

## bb8 0.2.39 (2020-11-04)

- Migrated `installBioconductor` code into koopa package.
- Hardened `uninstall` and `updatePackages` against warnings.

## bb8 0.2.38 (2020-11-04)

- `installBioconductor`: Also include automatic installation of BiocCheck.

## bb8 0.2.37 (2020-11-04)

- `install`: Set `dependencies` argument to `TRUE` by default instead of `NA`,
  which will automatically install suggested packages.

## bb8 0.2.36 (2020-11-03)

Migrated some install functions from koopa R package:

- `installAcidverse`: Install all Acid Genomics packages.
- `installBioconductor`: Wrapper for `BiocManager::install`.
- `installDefaultPackages`: Install default recommended R packages.

## bb8 0.2.35 (2020-10-29)

- `install`: Improve support for direct installation from a local file.

## bb8 0.2.34 (2020-10-29)

- `install`: Added support for automatic installation from a Git repository.
  Calls `remotes::install_git` internally.

## bb8 0.2.33 (2020-10-28)

- Bug fix, ensuring tibble `view` is reexported.

## bb8 0.2.32 (2020-10-23)

- Draft update adding `view` as a reexport, from tibble package.

## bb8 0.2.31 (2020-10-20)

- `updateDeps`: Hardened against missing packages.

## bb8 0.2.30 (2020-10-12)

- `updatePackages`: Only attempt to update GitHub packages if `GITHUB_PAT`
  environment variable is set.

## bb8 0.2.29 (2020-10-07)

- Renamed acidbase package to AcidBase, and updated import here.
- Removed GitHub remotes to Acid Genomics packages.

## bb8 0.2.28 (2020-08-25)

- `updatePackages`: Don't attempt to remove brio, as it's now on CRAN.

## bb8 0.2.27 (2020-08-18)

- Bug fix for Bioconductor and CRAN/RSPM package detection.

## bb8 0.2.26 (2020-08-18)

- `installedPackages`: Improved detection of Acid Genomics packages installed
  from `r.acidgenomics.com` instead of GitHub.

## bb8 0.2.25 (2020-08-17)

- `install`: Don't attempt to update old packages by default.

## bb8 0.2.24 (2020-08-11)

- `updatePackages`: Migrated automatic CRAN and GitHub removals here from
  code previously defined in koopa.
- Migrated `isCleanSystemLibrary` to goalie package.

## bb8 0.2.23 (2020-08-11)

### Minor changes

- Renamed `cleanSystemLibrary` to `isCleanSystemLibrary.`

## bb8 0.2.22 (2020-08-11)

### Minor changes

- `install`: Bug fix for skipping install from tarball URLs if the package
  is already installed. Can override with `reinstall = TRUE`.

## bb8 0.2.21 (2020-08-05)

### Minor changes

- `install` now supports direct installation of package tarballs from URLs.

## bb8 0.2.20 (2020-08-05)

### Minor changes

- `install` now internally treats all warnings as errors.

## bb8 0.2.19 (2020-08-03)

### Minor changes

- Removed reexport of `export` and `import` from pipette package.
  The `export` function doesn't detect `sym` class correctly.
- Switched magrittr from Depends to Imports.

## bb8 0.2.18 (2020-07-28)

### Minor changes

- Removed internal references to patrick package, which provides parameterized
  unit testing. Now falling back to simply using `for` or `mapply` loops instead
  inside of packages.

## bb8 0.2.17 (2020-07-23)

### Minor changes

- `updateDeps`: Now calling `install` internally rather than handing off to
  `BiocManager::install` call.

## bb8 0.2.16 (2020-07-22)

### Major changes

- `install` and `installGitHub` now default to `reinstall = TRUE`.

## bb8 0.2.15 (2020-07-01)

### Minor changes

- Renamed `getCurrentVersion` function to `getCurrentGitHubVersion`.

## bb8 0.2.14 (2020-06-21)

## bb8 0.2.13 (2020-05-12)

### Minor changes

- `printComment`: Added `width` parameter. This allows for improved automatic
  return of comments at a desired width. Currently defaults to 80 characters.

## bb8 0.2.12 (2020-04-13)

### Minor changes

- `install`: Another bug fix. Switching from `vapply` to `lapply` internally to
  capture return from BiocManager, as this output can vary.

## bb8 0.2.11 (2020-04-13)

### Minor changes

- `install`: Bug fix for systems lacking BiocManager or remotes packages.
  These dependencies are now installed in the fly if missing.

## bb8 0.2.10 (2020-04-12)

### Minor changes

- `installGitHub`: Bug fix for JSON parsing compability across Linux and macOS.

## bb8 0.2.9 (2020-04-12)

### Major changes

- Revert back to approach where package doesn't import any dependencies via
  `Imports`, instead only using `Suggests`. This allows for package update calls
  inside Travis CI checks and Docker images to work more consistently.

## bb8 0.2.8 (2020-04-12)

### New functions

- `installGitHub`: Install function that allows for versioned package installs
  without requiring `GITHUB_PAT` variable to be set. Intended for use inside
  Docker images. Otherwise, use `remotes::install_github` for interactive
  installs.

### Major changes

- Attempted to rework and simplify internal code, using acidbase and goalie
  as dependnecies. May revert back to no import approach.

## bb8 0.2.7 (2020-01-31)

- `rcmdcheck` now uses `--as-cran` flag automatically.
- Updated import to use pipette instead of brio.

## bb8 0.2.6 (2020-01-18)

- Updated `BiocCheck` reexport to not require biocViews in DESCRIPTION by
  default. This makes CI checks on non-Bioconductor packages destined for
  CRAN not error.

## bb8 0.2.5 (2020-01-07)

- Removed lookup package from reexports, to avoid accidental installation of
  GitHub versions that cause `BiocManager::valid()` check to fail.

## bb8 0.2.4 (2019-12-04)

- `install` and `updatePackages` no longer attempt to install and/or update
  suggested packages by default. I ran into some dependency issues with Seurat
  (SDMTools and adehabitat). See Seurat issue #2377
  (https://github.com/satijalab/seurat/issues/2377).

## bb8 0.2.3 (2019-11-19)

- Updated package documentation to support roxygen2 7.0 update.
- Added useful gh, locate, and remotes reexports.

## bb8 0.2.2 (2019-10-30)

- Added more useful interactive reexports, including pipes.

## bb8 0.2.1 (2019-10-23)

- Added `killAll` function, which calls `pkill rsession` internally.
- `updateDeps`: Now attempts to update "Enhances", "LinkingTo", and "Suggests"
  by default.
- Consistently using `system2` instead of `system` internally.
- Added `getPackageVersion`, which gets current version of a GitHub package.
- Added `isInstalled`, which checks against `installed.packages` return.

## bb8 0.2.0 (2019-10-20)

- Added `install`, which wraps `BiocManager::install` with some improved
  defaults for Mike's usage.
- Added `updatePackages`, which wraps `BiocManager::install` and
  `remotes::update_packages` with some improved defaults.
- Rexporting additional useful functions that get loaded by default in an
  interactive R session. See Mike's corresponding `Rprofile` dotfile.
- Package doesn't load any other additional packages as dependencies, to keep
  loading super fast in a new R session.

## bb8 0.1.4 (2019-10-17)

- Removed `lint_dir`, which is now exported in lintr package.
- Added `installedPackages`, which returns a camelCase formatted `data.frame`
  containing a "source" column. This column includes whether the package was
  installed from CRAN, Biocondcutor, GitHub, GitLab, or `NA` (if system, or is
  a local build).

## bb8 0.1.3 (2019-08-27)

- Updated R dependency to 3.6.

## bb8 0.1.2 (2019-08-22)

- Improved `updateDeps` handling for Rcheck on Travis CI.

## bb8 0.1.1 (2019-08-13)

- Removed goalie dependency.
- Fixed `updateDeps` so it can run on Travis CI.

## bb8 0.1.0 (2019-08-13)

Initial stable release.
