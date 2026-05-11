/*****************************************************************************
***  SAVED AS:        006_median_q1q3.sas
***
***  DESCRIPTION:     Example 006 - Median + Q1/Q3 (IQR) time-series plot.
***                   Demonstrates %graph() with central=median, vertbar=Y.
***
***  INPUT  DATA SET: rawdata.mean_data
***  OUTPUT REPORT:   006_median_q1q3.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = mean_data,
    library = rawdata,
    sortby  = trt week,
    keep    = subjid trt week score
);

/*** GRAPH SECTION ***/

%graph(
    analfile  = mean_data,
    xvar      = week,
    yvar      = score,
    xlabel    = Study Week,
    ylabel    = Median Score (Q1-Q3),
    effect    = trt,
    output    = 006_median_q1q3,
    titlekey  = 006_median_q1q3,
    central   = median,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    annot     = Y,
    xorder    = 0 to 24 by 4,
    wantpdf   = Y,
    wantrtf   = N
);
