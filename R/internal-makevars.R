#' macOS clang Makevars
#'
#' @note Updated 2022-04-28.
#' @noRd
#'
#' @section Hardening against Homebrew:
#'
#' Keeping references to `/usr/local` disabled to avoid potential collision with
#' compilers managed by Homebrew.
#'
#' @return `character`.
.macosClangMakevars <- function() {
    dict <- list()
    dict[["gccPrefix"]] <-
        file.path(
            "",
            "usr",
            "local",
            "gfortran"
        )
    dict[["sdkPrefix"]] <-
        file.path(
            "",
            "Library",
            "Developer",
            "CommandLineTools",
            "SDKs",
            "MacOSX.sdk",
            "usr"
        )
    dict[["cc"]] <-
        file.path(
            "",
            "usr",
            "bin",
            "clang"
        )
    dict[["cxx"]] <-
        file.path(
            "",
            "usr",
            "bin",
            "clang++"
        )
    dict[["fc"]] <-
        file.path(
            dict[["gccPrefix"]],
            "bin",
            "gfortran"
        )
    stopifnot(
        dir.exists(dict[["gccPrefix"]]),
        dir.exists(dict[["sdkPrefix"]]),
        file.exists(dict[["cc"]]),
        file.exists(dict[["cxx"]]),
        file.exists(dict[["fc"]])
    )
    dict[["cflags"]] <-
        paste(
            "-Wall",
            "-g",
            "-O2",
            "$(LTO)"
        )
    ## These settings are required to build data.table with OpenMP support.
    ## https://mac.r-project.org/openmp/
    dict[["cppflags"]] <-
        paste(
            "-Xclang",
            "-fopenmp"
        )
    dict[["ldflags"]] <- "-lomp"
    ## Locate R CRAN GCC / gfortran compiler.
    ## [1] "/usr/local/gfortran/lib/gcc/x86_64-apple-darwin18/8.2.0"
    ## [2] "/usr/local/gfortran/lib"
    dict[["flibs"]] <-
        unique(dirname(sort(list.files(
            path = dict[["gccPrefix"]],
            pattern = "^libgcc.*\\.(a|dylib)$",
            full.names = TRUE,
            recursive = TRUE
        ))))
    dict[["flibs"]] <-
        paste(
            append(
                x = paste0("-L", dict[["flibs"]]),
                values = c(
                    "-lgfortran",
                    "-lquadmath",
                    "-lm"
                )
            ),
            collapse = " "
        )
    out <- c(
        "CC" = dict[["cc"]],
        "CFLAGS" = dict[["cflags"]],
        "CPPFLAGS" = dict[["cppflags"]],
        "CXX" = dict[["cxx"]],
        "CXXFLAGS" = dict[["cflags"]],
        "CXX11" = dict[["cxx"]],
        "CXX11FLAGS" = dict[["cflags"]],
        "CXX14" = dict[["cxx"]],
        "CXX14FLAGS" = dict[["cflags"]],
        "CXX17" = dict[["cxx"]],
        "CXX17FLAGS" = dict[["cflags"]],
        "CXX20" = dict[["cxx"]],
        "CXX20FLAGS" = dict[["cflags"]],
        "FC" = dict[["fc"]],
        "FCFLAGS" = dict[["cflags"]],
        "FLIBS" = dict[["flibs"]],
        "LDFLAGS" = dict[["ldflags"]]
    )
    out
}



#' macOS GCC / fortran Makevars
#'
#' @note Updated 2022-04-28.
#' @noRd
#'
#' @return `character`.
.macosGccMakevars <- function() {
    dict <- list()
    dict[["gccPrefix"]] <-
        file.path(
            "",
            "usr",
            "local",
            "gfortran"
        )
    dict[["sdkPrefix"]] <-
        file.path(
            "",
            "Library",
            "Developer",
            "CommandLineTools",
            "SDKs",
            "MacOSX.sdk",
            "usr"
        )
    dict[["cc"]] <-
        file.path(dict[["gccPrefix"]], "bin", "gcc")
    dict[["cxx"]] <-
        file.path(dict[["gccPrefix"]], "bin", "g++")
    dict[["fc"]] <-
        file.path(dict[["gccPrefix"]], "bin", "gfortran")
    stopifnot(
        dir.exists(dict[["gccPrefix"]]),
        dir.exists(dict[["sdkPrefix"]]),
        file.exists(dict[["cc"]]),
        file.exists(dict[["cxx"]]),
        file.exists(dict[["fc"]])
    )
    ## These are shared (common) between 'CFLAGS' and 'CXXFLAGS'.
    dict[["sharedCflags"]] <-
        c(
            "-O3",
            "-Wall",
            "-g",
            "-pedantic",
            "-pipe",
            "-mtune=native",
            "$(LTO)"
        )
    dict[["cflags"]] <-
        paste(
            append(
                x = "-std=gnu99",
                values = dict[["sharedCflags"]]
            ),
            collapse = " "
        )
    dict[["cxxflags"]] <-
        paste(
            append(
                x = "-Wno-unused",
                values = dict[["sharedCflags"]]
            ),
            collapse = " "
        )
    dict[["cppflags"]] <-
        paste(
            paste0(
                "-I",
                file.path(
                    c(
                        dict[["gccPrefix"]],
                        dict[["sdkPrefix"]]
                    ),
                    "include"
                )
            ),
            collapse = " "
        )
    dict[["fcflags"]] <-
        paste(
            "-O3",
            "-Wall",
            "-g",
            "$(LTO_FC)"
        )
    ## Locate R CRAN GCC / gfortran compiler.
    ## [1] "/usr/local/gfortran/lib/gcc/x86_64-apple-darwin18/8.2.0"
    ## [2] "/usr/local/gfortran/lib"
    dict[["flibs"]] <-
        unique(dirname(sort(list.files(
            path = dict[["gccPrefix"]],
            pattern = "^libgcc.*\\.(a|dylib)$",
            full.names = TRUE,
            recursive = TRUE
        ))))
    dict[["flibs"]] <-
        paste(
            append(
                x = paste0("-L", dict[["flibs"]]),
                values = c(
                    "-lgfortran",
                    "-lquadmath",
                    "-lm"
                )
            ),
            collapse = " "
        )
    dict[["ldflags"]] <-
        paste(
            paste0(
                "-L",
                file.path(dict[["gccPrefix"]], "lib")
            ),
            paste(
                "-Wl",
                "-rpath",
                file.path(dict[["gccPrefix"]], "lib"),
                sep = ","
            )
        )
    ## This is required to build data.table with OpenMP support.
    dict[["shlibOpenmpCflags"]] <- "-fopenmp"
    out <- c(
        "CC" = dict[["cc"]],
        "CFLAGS" = dict[["cflags"]],
        "CPPFLAGS" = dict[["cppflags"]],
        "CXX" = dict[["cxx"]],
        "CXXFLAGS" = dict[["cxxflags"]],
        "CXX11" = dict[["cxx"]],
        "CXX11FLAGS" = dict[["cxxflags"]],
        "CXX14" = dict[["cxx"]],
        "CXX14FLAGS" = dict[["cxxflags"]],
        "CXX17" = dict[["cxx"]],
        "CXX17FLAGS" = dict[["cxxflags"]],
        "CXX20" = dict[["cxx"]],
        "CXX20FLAGS" = dict[["cxxflags"]],
        "FC" = dict[["fc"]],
        "FCFLAGS" = dict[["fcflags"]],
        "FLIBS" = dict[["flibs"]],
        "LDFLAGS" = dict[["ldflags"]],
        "SHLIB_OPENMP_CFLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_CXXFLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_CXX11FLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_CXX14FLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_CXX17FLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_CXX20FLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_FCFLAGS" = dict[["shlibOpenmpCflags"]],
        "SHLIB_OPENMP_FFLAGS" = dict[["shlibOpenmpCflags"]]
    )
    out
}
