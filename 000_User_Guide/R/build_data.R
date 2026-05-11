# build_data.R -- 000_User_Guide
# No data to build. Documents R usage patterns.
#
# SG1 Statistical Graphics Library — R Usage
# ===========================================
#
# Shared utilities (sg1/R/):
#   source("../../R/graph.R")  # median/CI time-series plot
#   source("../../R/fetch.R")  # data loader
#
# Running any example:
#   setwd("001_kaplan_meier/R")
#   source("build_data.R")  # generates test_data.csv
#   source("graph.R")       # reads test_data.csv, produces PDF/PNG
#
# Dependencies:
#   install.packages(c("ggplot2","dplyr","haven","survival","survminer","patchwork"))
#
# Example groups:
#   Group A (001-004, 053) - Kaplan-Meier:  requires survival + survminer
#   Group B (005-009)      - Mean/Median:   uses shared graph()
#   Group C (010-013)      - Lab data:      uses shared graph()
#   Group D (030)          - Disposition:   ggplot2 stacked bar
#   Group E (031-035)      - Scatter:       ggplot2 + geom_smooth
#   Group F (039, 044)     - Histograms:    ggplot2 geom_histogram
#   Group G (040-043, 047) - Needle/Waterfall/Bar
#   Group H (045-046)      - Bar/Box panels
#   Group J (048-052)      - QTcB/Cardiac PK/PD scatter
#   Group K (054)          - TitleKey demo

message("SG1 User Guide — navigate to any numbered example to run charts.")
