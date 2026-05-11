# graph.R  --  R translation of bae/graph.sas (Gilead V2015Q1)
#
# Original SAS macro: %graph()
# Coded by: Bryan Selby (May 1998), last modified Steve Wilson (03Nov2010)
# R translation: auto-generated from SAS source
#
# Creates median/IQR or mean/CI (or mean/SD) time-series plots across
# treatment groups, with optional sample-size annotations and flexible
# axis/legend control.
#
# Usage:
#   source("graph.R")
#   library(ggplot2)
#
#   graph(
#     analfile = df,
#     xvar     = "week",
#     yvar     = "value",
#     xlabel   = "Study Week",
#     ylabel   = "Mean Score",
#     effect   = "treatment",
#     output   = "my_graph",
#     central  = "mean",
#     cidist   = "t",
#     cilevel  = 95
#   )
#
# Dependencies: ggplot2, dplyr, rlang, stats

# ---------------------------------------------------------------------------
# Package loading
# ---------------------------------------------------------------------------
.graph_require <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop(sprintf("Package '%s' is required. Install with: install.packages('%s')", pkg, pkg))
}

# ---------------------------------------------------------------------------
# Statistics helper
# ---------------------------------------------------------------------------
.compute_stats <- function(df, group_cols, yvar, central, cidist, cilevel, lbzero) {
  .graph_require("dplyr")
  alpha <- 1.0 - cilevel / 100.0

  stats_df <- df |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group_cols))) |>
    dplyr::summarise(
      n      = dplyr::n(),
      center = if (toupper(central) == "MEDIAN") stats::median(.data[[yvar]], na.rm = TRUE)
               else mean(.data[[yvar]], na.rm = TRUE),
      sd_val = if (toupper(central) == "MEDIAN") stats::IQR(.data[[yvar]], na.rm = TRUE) / 1.35
               else stats::sd(.data[[yvar]], na.rm = TRUE),
      q1_raw = if (toupper(central) == "MEDIAN") stats::quantile(.data[[yvar]], 0.25, na.rm = TRUE)
               else NA_real_,
      q3_raw = if (toupper(central) == "MEDIAN") stats::quantile(.data[[yvar]], 0.75, na.rm = TRUE)
               else NA_real_,
      .groups = "drop"
    ) |>
    dplyr::mutate(
      sem = sd_val / sqrt(pmax(n, 1)),
      q1  = dplyr::case_when(
        toupper(central) == "MEDIAN" ~ q1_raw,
        toupper(cidist)  == "SD"     ~ if (lbzero) pmax(center - sd_val, 0) else center - sd_val,
        toupper(cidist)  == "STDERR" ~ if (lbzero) pmax(center - sem,    0) else center - sem,
        toupper(cidist)  == "Z"      ~ center - sem * stats::qnorm(1 - alpha / 2),
        TRUE                         ~ dplyr::if_else(
                                          n > 1,
                                          center - sem * stats::qt(1 - alpha / 2, df = n - 1),
                                          center)
      ),
      q3  = dplyr::case_when(
        toupper(central) == "MEDIAN" ~ q3_raw,
        toupper(cidist)  == "SD"     ~ dplyr::if_else(lbzero & center <= 0, 0, center + sd_val),
        toupper(cidist)  == "STDERR" ~ center + sem,
        toupper(cidist)  == "Z"      ~ center + sem * stats::qnorm(1 - alpha / 2),
        TRUE                         ~ dplyr::if_else(
                                          n > 1,
                                          center + sem * stats::qt(1 - alpha / 2, df = n - 1),
                                          center)
      )
    ) |>
    dplyr::select(-sd_val, -sem, -q1_raw, -q3_raw)

  stats_df
}

# ---------------------------------------------------------------------------
# Corner → legend.position mapping
# ---------------------------------------------------------------------------
.corner_pos <- list(
  UL = c(0.02, 0.98), UR = c(0.98, 0.98),
  LL = c(0.02, 0.02), LR = c(0.98, 0.02)
)
.corner_just <- list(
  UL = c("left",  "top"),
  UR = c("right", "top"),
  LL = c("left",  "bottom"),
  LR = c("right", "bottom")
)

# Default symbols (ggplot2 shape codes)
.DEFAULT_SHAPES <- c(16, 21, 17, 15, 18, 25, 3, 4)  # filled/open circles, triangles, etc.
.DEFAULT_COLORS <- c("black","#377EB8","#E41A1C","#4DAF4A","#FF7F00","#984EA3","#A65628","#F781BF")
.DEFAULT_LTYS   <- c("solid","dashed","dotdash","dotted","longdash","twodash","solid","dashed")

# ---------------------------------------------------------------------------
# Main graph function
# ---------------------------------------------------------------------------

#' Create a median/IQR or mean/CI time-series plot
#'
#' @param analfile   data.frame input dataset
#' @param xvar       column name for X axis
#' @param yvar       column name for Y axis
#' @param xlabel     X axis label text
#' @param ylabel     Y axis label text
#' @param effect     column name for treatment/grouping variable
#' @param output     base filename (without extension) for saved output
#' @param central    "median" or "mean"
#' @param cidist     "t", "Z", "SD", or "STDERR"
#' @param cilevel    confidence level percentage (default 95)
#' @param lbzero     force lower bound to 0 when cidist="SD"
#' @param spread     horizontal stagger between groups (default 1)
#' @param vertbar    draw vertical error bars
#' @param join       connect central points with lines
#' @param legend     show legend
#' @param corner     legend corner: "UL","UR","LL","LR"
#' @param annot      annotate N= counts below plot
#' @param log        use log10 Y scale
#' @param xorder     numeric vector of X tick values
#' @param yorder     numeric vector of Y tick values
#' @param href       numeric vector of horizontal reference line values
#' @param vref       numeric vector of vertical reference line values
#' @param scond      character string, eval'd as dplyr filter expression
#' @param efffmt     optional function to format effect level labels
#' @param byvar      character vector of by-variable column names
#' @param plttitle   additional plot title text
#' @param nlabel     text appended to N= annotation labels
#' @param annosize   font size for N= annotations
#' @param solidln    make all lines solid (ignore linetype cycling)
#' @param symsame    use same symbol for all groups
#' @param wantpdf    save PDF output
#' @param wantpng    save PNG output
#' @param figwidth   figure width in inches
#' @param figheight  figure height in inches
#' @param ...        additional arguments (ignored, for API parity)
#'
#' @return A ggplot object
#' @export
graph <- function(
    analfile,
    xvar,
    yvar,
    xlabel,
    ylabel,
    effect,
    output    = "graph",
    titlekey  = NULL,
    central   = "median",
    cilevel   = 95,
    cidist    = "t",
    lbzero    = TRUE,
    spread    = 1,
    vertbar   = TRUE,
    join      = TRUE,
    legend    = TRUE,
    corner    = "UL",
    annot     = TRUE,
    annosel   = NULL,
    annosize  = 3,
    nlabel    = "(n=)",
    log       = FALSE,
    xorder    = NULL,
    yorder    = NULL,
    href      = NULL,
    vref      = NULL,
    xfmt      = NULL,
    efffmt    = NULL,
    scond     = NULL,
    byvar     = NULL,
    plttitle  = NULL,
    solidln   = FALSE,
    symsame   = FALSE,
    wantpdf   = TRUE,
    wantpng   = TRUE,
    figwidth  = 10,
    figheight = 7,
    ...
) {
  .graph_require("ggplot2")
  .graph_require("dplyr")

  # ------------------------------------------------------------------
  # 1. Subset
  # ------------------------------------------------------------------
  df <- analfile
  if (!is.null(scond) && nchar(trimws(scond)) > 0) {
    .graph_require("rlang")
    df <- dplyr::filter(df, !!rlang::parse_expr(scond))
  }
  df <- df[!is.na(df[[xvar]]) & !is.na(df[[yvar]]), ]

  if (nrow(df) == 0) {
    warning("No data remain after subsetting — nothing to plot.")
    return(ggplot2::ggplot())
  }

  # ------------------------------------------------------------------
  # 2. Staggering adjustment
  # ------------------------------------------------------------------
  effect_levels <- sort(unique(df[[effect]]))
  adj_n <- length(effect_levels)

  stagger_offset <- function(idx) {
    center <- adj_n / 2.0 + 0.5
    ((idx) - center) * (0.6 / adj_n) * spread
  }
  stagger_map <- stats::setNames(
    sapply(seq_along(effect_levels), stagger_offset),
    as.character(effect_levels)
  )
  df[["newx"]] <- df[[xvar]] + stagger_map[as.character(df[[effect]])]

  # ------------------------------------------------------------------
  # 3. Statistics
  # ------------------------------------------------------------------
  group_cols <- c(
    if (!is.null(byvar)) byvar,
    "newx", effect, xvar
  )
  stats_df <- .compute_stats(df, group_cols, yvar, central, cidist, cilevel, lbzero)

  # Format effect labels
  if (!is.null(efffmt)) {
    stats_df[["eff_label"]] <- sapply(stats_df[[effect]], efffmt)
  } else {
    stats_df[["eff_label"]] <- as.character(stats_df[[effect]])
  }
  stats_df[["eff_label"]] <- factor(stats_df[["eff_label"]],
                                    levels = unique(stats_df[["eff_label"]]))

  # ------------------------------------------------------------------
  # 4. Build ggplot
  # ------------------------------------------------------------------
  shapes_use <- if (symsame) rep(.DEFAULT_SHAPES[1], adj_n)
                else .DEFAULT_SHAPES[seq_len(adj_n)]
  colors_use <- .DEFAULT_COLORS[seq_len(adj_n)]
  ltys_use   <- if (solidln) rep("solid", adj_n)
                else .DEFAULT_LTYS[seq_len(adj_n)]

  p <- ggplot2::ggplot(
    stats_df,
    ggplot2::aes(
      x      = .data[["newx"]],
      y      = .data[["center"]],
      color  = .data[["eff_label"]],
      shape  = .data[["eff_label"]],
      group  = .data[["eff_label"]],
      linetype = .data[["eff_label"]]
    )
  )

  # Error bars
  if (vertbar) {
    p <- p + ggplot2::geom_errorbar(
      ggplot2::aes(ymin = .data[["q1"]], ymax = .data[["q3"]]),
      width = 0, linewidth = 0.8
    )
  }

  # Center line or points
  if (join) {
    p <- p + ggplot2::geom_line(linewidth = 0.8)
  }
  p <- p + ggplot2::geom_point(size = 3)

  # Scales
  p <- p +
    ggplot2::scale_color_manual(values = colors_use) +
    ggplot2::scale_shape_manual(values = shapes_use) +
    ggplot2::scale_linetype_manual(values = ltys_use)

  # ------------------------------------------------------------------
  # 5. Log scale
  # ------------------------------------------------------------------
  if (log) {
    p <- p + ggplot2::scale_y_log10()
  }

  # ------------------------------------------------------------------
  # 6. Reference lines
  # ------------------------------------------------------------------
  if (!is.null(href)) {
    for (h in href) {
      p <- p + ggplot2::geom_hline(yintercept = h, color = "gray50",
                                    linewidth = 0.5, linetype = "dashed")
    }
  }
  if (!is.null(vref)) {
    for (v in vref) {
      p <- p + ggplot2::geom_vline(xintercept = v, color = "gray50",
                                    linewidth = 0.5, linetype = "dashed")
    }
  }

  # ------------------------------------------------------------------
  # 7. Axes and labels
  # ------------------------------------------------------------------
  x_scale <- if (!is.null(xorder)) {
    ggplot2::scale_x_continuous(
      breaks = xorder,
      limits = range(xorder),
      labels = if (!is.null(xfmt)) xfmt else ggplot2::waiver()
    )
  } else {
    ggplot2::scale_x_continuous(
      labels = if (!is.null(xfmt)) xfmt else ggplot2::waiver()
    )
  }

  y_scale <- if (!is.null(yorder) && !log) {
    ggplot2::scale_y_continuous(breaks = yorder, limits = range(yorder))
  } else {
    ggplot2::scale_y_continuous()
  }

  p <- p + x_scale + y_scale +
    ggplot2::labs(
      x        = xlabel,
      y        = ylabel,
      title    = plttitle,
      color    = NULL,
      shape    = NULL,
      linetype = NULL
    ) +
    ggplot2::theme_classic(base_size = 12) +
    ggplot2::theme(
      axis.title   = ggplot2::element_text(face = "bold"),
      plot.title   = ggplot2::element_text(face = "bold", hjust = 0.5)
    )

  # ------------------------------------------------------------------
  # 8. Legend position
  # ------------------------------------------------------------------
  corner_key <- toupper(corner)
  if (!legend) {
    p <- p + ggplot2::theme(legend.position = "none")
  } else if (corner_key %in% names(.corner_pos)) {
    p <- p + ggplot2::theme(
      legend.position         = .corner_pos[[corner_key]],
      legend.justification    = .corner_just[[corner_key]],
      legend.background       = ggplot2::element_blank(),
      legend.key              = ggplot2::element_blank()
    )
  }

  # ------------------------------------------------------------------
  # 9. N= annotations
  # ------------------------------------------------------------------
  if (annot) {
    anno_df <- stats_df
    if (!is.null(annosel)) {
      anno_df <- anno_df[sapply(anno_df[[xvar]], annosel), ]
    }

    # Compute y position below plot minimum
    y_range  <- diff(range(c(stats_df$q1, stats_df$q3, stats_df$center), na.rm = TRUE))
    y_min    <- min(stats_df$q1, na.rm = TRUE)
    step     <- y_range * 0.06

    for (idx in seq_along(effect_levels)) {
      lvl  <- effect_levels[idx]
      grp  <- anno_df[anno_df[[effect]] == lvl, ]
      lbl  <- if (!is.null(efffmt)) efffmt(lvl) else as.character(lvl)
      y_pos <- y_min - step * idx

      if (nrow(grp) > 0) {
        p <- p + ggplot2::annotate(
          "text",
          x     = grp[["newx"]],
          y     = y_pos,
          label = paste0(lbl, " ", nlabel, ": ", grp[["n"]]),
          size  = annosize,
          hjust = 0.5,
          vjust = 1,
          color = colors_use[idx],
          clip  = "off"
        )
      }
    }
    p <- p + ggplot2::theme(plot.margin = ggplot2::margin(t = 5, r = 5, b = 30 + 15 * adj_n, l = 5))
  }

  # ------------------------------------------------------------------
  # 10. Save output
  # ------------------------------------------------------------------
  out_dir <- dirname(output)
  if (!dir.exists(out_dir) && out_dir != ".") dir.create(out_dir, recursive = TRUE)

  if (wantpdf) {
    ggplot2::ggsave(paste0(output, ".pdf"), plot = p,
                    width = figwidth, height = figheight, device = "pdf")
    message("NOTE: Saved ", output, ".pdf")
  }
  if (wantpng) {
    ggplot2::ggsave(paste0(output, ".png"), plot = p,
                    width = figwidth, height = figheight, dpi = 150, device = "png")
    message("NOTE: Saved ", output, ".png")
  }

  invisible(p)
}
