# fetch.R  --  R translation of bae/fetch.sas (Gilead V2015Q1)
#
# Original SAS macro: %fetch()
# Coded by: Linda Collins (29Dec1997), last modified Steve Wilson (23Mar2011)
# R translation: auto-generated from SAS source
#
# Fetches a SAS dataset (or CSV / RDS fallback) from a named library path,
# optionally applies subsetting, sorting, column keep, and executes
# hardcoding (.hc.R) / analysis-assumption (.inc.R) side-car scripts.
#
# Usage:
#   library(haven)
#   library(dplyr)
#
#   register_library("rawdata", "/path/to/sas/datasets")
#
#   ae <- fetch(
#     data    = "aevent",
#     library = "rawdata",
#     dataopt = "anyae == 1",        # dplyr-style filter string
#     keep    = c("ptid", "body", "prefterm"),
#     sortby  = c("ptid", "body", "prefterm")
#   )
#
# Side-car scripts:
#   For dataset "aevent" in library path "/data/", fetch() looks for:
#     /data/aevent.hc.R   -- dataset-specific hardcoding  (if runhc=TRUE)
#     /data/_all_.hc.R    -- universal hardcoding          (if runhc=TRUE)
#     /data/aevent.inc.R  -- dataset-specific recoding     (if runinc=TRUE)
#     /data/_all_.inc.R   -- universal recoding            (if runinc=TRUE)
#
#   Each script receives `df` (a data.frame / tibble) and must assign
#   the modified result back to `df`.
#
# Dependencies: haven, dplyr, rlang

# ---------------------------------------------------------------------------
# Package loading (warn instead of error if not installed)
# ---------------------------------------------------------------------------
.fetch_require <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop(sprintf("Package '%s' is required. Install with: install.packages('%s')", pkg, pkg))
}

# ---------------------------------------------------------------------------
# Library registry  (mirrors SAS LIBNAME)
# ---------------------------------------------------------------------------
.fetch_libraries <- new.env(hash = TRUE, parent = emptyenv())

#' Register a named library path
#'
#' @param name  Library name (case-insensitive).
#' @param path  Filesystem directory path.
#' @export
register_library <- function(name, path) {
  assign(tolower(name), normalizePath(path, mustWork = FALSE), envir = .fetch_libraries)
}

.resolve_library <- function(library) {
  key <- tolower(library)
  if (exists(key, envir = .fetch_libraries))
    return(get(key, envir = .fetch_libraries))
  if (dir.exists(library))
    return(normalizePath(library))
  stop(sprintf(
    "Library '%s' is not registered and is not a valid directory. Use register_library() first.",
    library
  ))
}

# ---------------------------------------------------------------------------
# Side-car script executor
# ---------------------------------------------------------------------------
.run_sidecar <- function(script_path, df) {
  env <- new.env(parent = baseenv())
  env$df <- df
  source(script_path, local = env)
  env$df
}

# ---------------------------------------------------------------------------
# Main fetch function
# ---------------------------------------------------------------------------

#' Fetch a dataset from a named library
#'
#' @param data     Dataset name (without extension).
#' @param library  Registered library name or filesystem path.
#' @param out      Variable name (character) to assign result in calling env.
#'                 If NULL the data.frame is only returned invisibly.
#' @param dataopt  Subsetting expression: character string passed to
#'                 \code{dplyr::filter(df, !!rlang::parse_expr(dataopt))},
#'                 or a one-argument function returning a filtered data.frame.
#' @param outopt   Not used in R (kept for API parity with SAS macro).
#' @param sortby   Character vector of column names to sort by.
#' @param keep     Character vector of columns to retain.
#' @param runhc    Execute hardcoding side-car scripts? Default TRUE.
#' @param runinc   Execute analysis-assumption side-car scripts? Default TRUE.
#' @param debug    Print diagnostic messages and 10-row samples? Default FALSE.
#'
#' @return A data.frame (tibble).
#' @export
fetch <- function(
    data,
    library  = "rawdata",
    out      = NULL,
    dataopt  = NULL,
    outopt   = NULL,
    sortby   = NULL,
    keep     = NULL,
    runhc    = TRUE,
    runinc   = TRUE,
    debug    = FALSE
) {
  .fetch_require("haven")
  .fetch_require("dplyr")

  # ------------------------------------------------------------------
  # Resolve library path
  # ------------------------------------------------------------------
  lib_path <- tryCatch(
    .resolve_library(library),
    error = function(e) stop(e$message)
  )

  if (debug) {
    message("**NOTE: Fetching dataset : ", data)
    message("**NOTE: From library     : ", library, " -> ", lib_path)
    message("**NOTE: Parm dataopt     : ", deparse(dataopt))
    message("**NOTE: Parm sortby      : ", paste(sortby, collapse = ", "))
    message("**NOTE: Parm keep        : ", paste(keep,   collapse = ", "))
    message("**NOTE: Parm runhc       : ", runhc)
    message("**NOTE: Parm runinc      : ", runinc)
  }

  # ------------------------------------------------------------------
  # Find and load the dataset  (.sas7bdat -> .csv -> .rds)
  # ------------------------------------------------------------------
  data_lc  <- tolower(data)
  sas_file <- file.path(lib_path, paste0(data_lc, ".sas7bdat"))
  csv_file <- file.path(lib_path, paste0(data_lc, ".csv"))
  rds_file <- file.path(lib_path, paste0(data_lc, ".rds"))

  if (file.exists(sas_file)) {
    df <- haven::read_sas(sas_file)
  } else if (file.exists(csv_file)) {
    df <- utils::read.csv(csv_file, stringsAsFactors = FALSE)
  } else if (file.exists(rds_file)) {
    df <- readRDS(rds_file)
  } else {
    stop(sprintf(
      "Cannot find dataset '%s' in library '%s' (%s). Expected: .sas7bdat, .csv, or .rds",
      data, library, lib_path
    ))
  }

  if (debug) {
    message("\n10 Sample Observations After Initial Retrieval:")
    print(utils::head(df, 10))
  }

  # ------------------------------------------------------------------
  # Apply dataopt subsetting
  # ------------------------------------------------------------------
  if (!is.null(dataopt)) {
    if (is.function(dataopt)) {
      df <- dataopt(df)
    } else if (is.character(dataopt)) {
      .fetch_require("rlang")
      df <- dplyr::filter(df, !!rlang::parse_expr(dataopt))
    }
  }

  # ------------------------------------------------------------------
  # Hardcoding files  (.hc.R)
  # ------------------------------------------------------------------
  hc_scripts <- c(
    file.path(lib_path, paste0(data_lc, ".hc.R")),
    file.path(lib_path, "_all_.hc.R")
  )
  for (script in hc_scripts) {
    if (runhc) {
      if (file.exists(script)) {
        message("**FETCH: Applying hardcoding file: ", script)
        if (!is.null(dataopt))
          warning("DATAOPT is in effect and a hardcoding script is being executed. ",
                  "Options are applied BEFORE hardcoding.", call. = FALSE)
        df <- .run_sidecar(script, df)
        if (debug) {
          message("10 Sample Observations After Applying Hardcoding (", basename(script), "):")
          print(utils::head(df, 10))
        }
      }
    } else {
      if (file.exists(script))
        message("**NOTE: Hardcode processing suppressed: ", script)
    }
  }

  # ------------------------------------------------------------------
  # Analysis assumption / recoding files  (.inc.R)
  # ------------------------------------------------------------------
  inc_scripts <- c(
    file.path(lib_path, paste0(data_lc, ".inc.R")),
    file.path(lib_path, "_all_.inc.R")
  )
  for (script in inc_scripts) {
    if (runinc) {
      if (file.exists(script)) {
        message("**FETCH: Applying analysis assumption file: ", script)
        if (!is.null(dataopt))
          warning("DATAOPT is in effect and an analysis-assumptions script is being executed. ",
                  "Options are applied BEFORE recoding.", call. = FALSE)
        df <- .run_sidecar(script, df)
        if (debug) {
          message("10 Sample Observations After Applying Recoding (", basename(script), "):")
          print(utils::head(df, 10))
        }
      }
    } else {
      if (file.exists(script))
        message("**NOTE: Analysis assumption processing suppressed: ", script)
    }
  }

  # ------------------------------------------------------------------
  # Sort
  # ------------------------------------------------------------------
  if (!is.null(sortby) && length(sortby) > 0) {
    df <- dplyr::arrange(df, dplyr::across(dplyr::all_of(sortby)))
  }

  # ------------------------------------------------------------------
  # Keep columns
  # ------------------------------------------------------------------
  if (!is.null(keep) && length(keep) > 0) {
    missing_cols <- setdiff(keep, colnames(df))
    if (length(missing_cols) > 0)
      warning("KEEP columns not found and will be ignored: ",
              paste(missing_cols, collapse = ", "), call. = FALSE)
    keep <- intersect(keep, colnames(df))
    df <- dplyr::select(df, dplyr::all_of(keep))
  }

  if (debug) {
    message("\n10 Sample Observations After Retrieval Completed:")
    print(utils::head(df, 10))
    message("**NOTE: Macro termination: fetch")
  }

  # ------------------------------------------------------------------
  # Optionally assign to caller's environment
  # ------------------------------------------------------------------
  if (!is.null(out) && nchar(out) > 0)
    assign(out, df, envir = parent.frame())

  invisible(df)
}
