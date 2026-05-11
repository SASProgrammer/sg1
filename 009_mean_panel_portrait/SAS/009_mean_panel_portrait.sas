/*****************************************************************************
***  SAVED AS:        009_mean_panel_portrait.sas
***
***  DESCRIPTION:     Example 009 - Mean panels in portrait (vertical) layout.
***                   Each lab test appears as a stacked panel.
***
***  INPUT  DATA SET: rawdata.panel_data
***  OUTPUT REPORT:   009_mean_panel_portrait.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = panel_data,
    library = rawdata,
    sortby  = labtest trt week,
    keep    = subjid labtest trt week result
);

/*** GRAPH SECTION — one panel per lab test, stacked vertically ***/

%graph(
    analfile  = panel_data,
    byvar     = labtest,
    xvar      = week,
    yvar      = result,
    xlabel    = Study Week,
    ylabel    = Mean Result (95% CI),
    effect    = trt,
    output    = 009_mean_panel_portrait,
    titlekey  = 009_mean_panel_portrait,
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
