/*****************************************************************************
***  SAVED AS:        010_Lab_Data.sas
***
***  DESCRIPTION:     Example 010 - Basic laboratory data time-series plot.
***                   Mean +/- 95% CI for a continuous lab analyte by treatment.
***
***  INPUT  DATA SET: rawdata.lab_data
***  OUTPUT REPORT:   010_Lab_Data.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = lab_data,
    library = rawdata,
    sortby  = trt visit,
    keep    = subjid trt visit lbresult
);

/*** GRAPH SECTION ***/

%graph(
    analfile  = lab_data,
    xvar      = visit,
    yvar      = lbresult,
    xlabel    = Study Visit,
    ylabel    = Mean Lab Result (95% CI),
    effect    = trt,
    output    = 010_Lab_Data,
    titlekey  = 010_Lab_Data,
    central   = mean,
    cidist    = t,
    cilevel   = 95,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    annot     = Y,
    wantpdf   = Y,
    wantrtf   = N
);
