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
