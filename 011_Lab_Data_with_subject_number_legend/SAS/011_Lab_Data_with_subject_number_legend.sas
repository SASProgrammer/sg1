/*****************************************************************************
***  SAVED AS:        011_Lab_Data_with_subject_number_legend.sas
***
***  DESCRIPTION:     Example 011 - Lab data plot with N= in legend area.
***                   Same as 010 but N= annotation appears next to legend
***                   symbols rather than below the X axis.
***
***  INPUT  DATA SET: rawdata.lab_data
***  OUTPUT REPORT:   011_Lab_Data_with_subject_number_legend.pdf
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
    output    = 011_Lab_Data_with_subject_number_legend,
    titlekey  = 011_Lab_Data_with_subject_number_legend,
    central   = mean,
    cidist    = t,
    cilevel   = 95,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UR,
    annot     = Y,
    nlabel    = %str(N =),
    annosel   = %str(visit in (1, 4, 8)),
    wantpdf   = Y,
    wantrtf   = N
);
