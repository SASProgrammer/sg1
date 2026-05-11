"""
build_data.py -- 000_User_Guide
No data to build for the user guide. This file documents usage patterns.

SG1 Statistical Graphics Library — Python Usage
================================================

Shared utilities (sg1/python/):
  from graph import graph    # median/CI time-series plot
  from fetch import fetch, register_library  # data loader

Running any example:
  cd 001_kaplan_meier/python
  python build_data.py   # generates test_data.csv
  python graph.py        # reads test_data.csv, produces PDF/PNG

Dependencies:
  pip install pandas matplotlib scipy numpy lifelines pyreadstat

Example groups:
  Group A (001-004, 053) - Kaplan-Meier:  requires lifelines
  Group B (005-009)      - Mean/Median:   uses shared graph()
  Group C (010-013)      - Lab data:      uses shared graph()
  Group D (030)          - Disposition:   matplotlib stacked bar
  Group E (031-035)      - Scatter:       matplotlib + scipy.stats
  Group F (039, 044)     - Histograms:    matplotlib.hist
  Group G (040-043, 047) - Needle/Wfall/Bar
  Group H (045-046)      - Bar/Box panels
  Group J (048-052)      - QTcB/Cardiac PK/PD scatter
  Group K (054)          - TitleKey demo: same as 043b with titles
"""
print("SG1 User Guide — no data to generate.")
print("Run build_data.py in any example subdirectory to generate test data.")
