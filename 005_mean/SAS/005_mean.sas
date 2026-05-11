/*****************************************************************************
***  SAVED AS:        005_mean.sas
***
***  DESCRIPTION:     Example 005 - Mean +/- 95% CI time-series plot.
***                   Demonstrates %graph() with central=mean, cidist=t.
***
***  INPUT  DATA SET: rawdata.mean_data  (test_data.csv as SAS dataset)
***  OUTPUT REPORT:   005_mean.pdf
***
***  TOOLS CALLED:    %fetch  (bae/fetch.sas)
***                   %graph  (bae/graph.sas)
*****************************************************************************/

/*** DATA BUILD SECTION ***/

/* Point library to directory containing test data */
libname rawdata ".";

/* Fetch longitudinal analysis dataset */
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
    ylabel    = Mean Score (95% CI),
    effect    = trt,
    output    = 005_mean,
    titlekey  = 005_mean,
    central   = mean,
    cidist    = t,
    cilevel   = 95,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    annot     = Y,
    xorder    = 0 to 24 by 4,
    wantpdf   = Y,
    wantrtf   = N
);
