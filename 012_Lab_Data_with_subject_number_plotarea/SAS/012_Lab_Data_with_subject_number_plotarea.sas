/*****************************************************************************
***  SAVED AS:        012_Lab_Data_with_subject_number_plotarea.sas
***
***  DESCRIPTION:     Example 012 - Lab data with N= annotation placed inside
***                   the plot area (bottom of plot) at every visit.
***
***  INPUT  DATA SET: rawdata.lab_data
***  OUTPUT REPORT:   012_Lab_Data_with_subject_number_plotarea.pdf
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
    output    = 012_Lab_Data_with_subject_number_plotarea,
    titlekey  = 012_Lab_Data_with_subject_number_plotarea,
    central   = mean,
    cidist    = t,
    cilevel   = 95,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    annot     = Y,
    nlabel    = %str((N=),
    yorigin   = 22,
    wantpdf   = Y,
    wantrtf   = N
);
