## https://stackoverflow.com/questions/53324885
stopifnot(
    requireNamespace("AcidBase", quietly = TRUE),
    requireNamespace("koopa", quietly = TRUE)
)
optPrefix <- koopa::koopaOptPrefix()
realpath <- AcidBase::realpath
apps <- c(
    "freetype",
    "libpng",
    "libtiff",
    "libjpeg-turbo",
    "zstd"
)
libDirs <- realpath(file.path(optPrefix, apps, "lib"))
includeDirs <- realpath(file.path(optPrefix, apps, "include"))
names(includeDirs) <- apps
includeDirs[["freetype"]] <-
    file.path(includeDirs[["freetype"]], "freetype2")
unname(includeDirs)
install.packages(
    pkgs = "ragg",
    type = "source",
    configure.vars = c(
        paste0(
            "LIB_DIR='",
            paste(libDirs, collapse = " -L"),
            "'"
        ),
        paste0(
            "INCLUDE_DIR='",
            paste(includeDirs, collapse = " -I"),
            "'"
        )
    )
)
