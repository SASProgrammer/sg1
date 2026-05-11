/*****************************************************************************
***  SAVED AS:        000_User_Guide.sas
***
***  DESCRIPTION:     SG1 Statistical Graphics Library — User Guide
***
***  PURPOSE:         Documents the structure and usage of the sg1 gallery.
***                   No executable code — comments only.
***
***  CONTENTS:
***
***  sg1/
***    python/graph.py      -- Shared %graph() translation (median/mean CI plots)
***    python/fetch.py      -- Shared %fetch() translation (data loading)
***    R/graph.R            -- Shared %graph() translation for R
***    R/fetch.R            -- Shared %fetch() translation for R
***
***  Each example subdirectory (NNN_example_name/) contains:
***    SAS/NNN_example_name.sas   -- Source SAS program
***                                  Section 1: DATA BUILD (fetch + prep)
***                                  Section 2: GRAPH (plot call)
***    python/build_data.py       -- Python data build translation
***    python/graph.py            -- Python graph translation
***    R/build_data.R             -- R data build translation
***    R/graph.R                  -- R graph translation
***
***  EXAMPLE GROUPS:
***    Group A (001-004, 053) - Kaplan-Meier survival curves
***    Group B (005-009)      - Mean/Median time-series plots
***    Group C (010-013)      - Laboratory data plots
***    Group D (030)          - Subject disposition
***    Group E (031-035)      - Scatter plots with regression
***    Group F (039, 044)     - Histograms
***    Group G (040-043, 047) - Needle, Waterfall, Bar charts
***    Group H (045-046)      - Vertical bar / Box plots
***    Group I (047)          - Stacked bar charts
***    Group J (048-052)      - QTcB / Cardiac safety
***    Group K (054)          - TitleKey / TNFSet demonstration
***
***  RUNNING AN EXAMPLE:
***    Python: cd NNN_example_name/python && python build_data.py && python graph.py
***    R:      setwd("NNN_example_name/R"); source("build_data.R"); source("graph.R")
***    SAS:    %include "&bae/fetch.sas"; %include "&bae/graph.sas";
***            %include "NNN_example_name/SAS/NNN_example_name.sas";
***
***  DEPENDENCIES:
***    Python: pandas, matplotlib, scipy, numpy, lifelines (KM only)
***    R:      ggplot2, dplyr, haven, survival, survminer (KM only), patchwork (008)
*****************************************************************************/

/* This file is documentation only — no executable SAS code. */
%put NOTE: SG1 User Guide loaded. See comments for library structure.;
