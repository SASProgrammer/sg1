/*****************************************************************************
***  SAVED AS:        007_mean_panel_consistent_Y.sas
***
***  DESCRIPTION:     Example 007 - Mean panels with consistent Y-axis scale.
***                   Uses %graph() with BY variable; all panels share the same
***                   Y-axis range to allow visual comparison across panels.
***
***  INPUT  DATA SET: rawdata.panel_data
***  OUTPUT REPORT:   007_mean_panel_consistent_Y.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = panel_data,
    library = rawdata,
    sortby  = labtest trt week,
    keep    = subjid labtest trt week result
);

/* Determine common Y axis range across all lab tests */
proc univariate data=panel_data noprint;
    var result;
    output out=yrange min=ymin max=ymax;
run;

data _null_;
    set yrange;
    call symput('ymin', put(floor(ymin/10)*10, best.));
    call symput('ymax', put(ceil(ymax/10)*10,  best.));
run;

/*** GRAPH SECTION — one panel per lab test, consistent Y axis ***/

%graph(
    analfile  = panel_data,
    byvar     = labtest,
    xvar      = week,
    yvar      = result,
    xlabel    = Study Week,
    ylabel    = Mean Result (95% CI),
    effect    = trt,
    output    = 007_mean_panel_consistent_Y,
    titlekey  = 007_mean_panel_consistent_Y,
    central   = mean,
    cidist    = t,
    cilevel   = 95,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    annot     = Y,
    xorder    = 0 to 24 by 4,
    yorder    = &ymin to &ymax by 10,
    gsfmode   = replace,
    wantpdf   = Y,
    wantrtf   = N
);
