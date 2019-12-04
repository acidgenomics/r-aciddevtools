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
