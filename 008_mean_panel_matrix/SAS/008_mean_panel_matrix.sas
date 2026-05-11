/*****************************************************************************
***  SAVED AS:        008_mean_panel_matrix.sas
***
***  DESCRIPTION:     Example 008 - Mean panels in a 2x3 matrix layout.
***                   Demonstrates %graph() with BY variable and gsfmode=append
***                   to accumulate multiple panels into one output file.
***
***  INPUT  DATA SET: rawdata.panel_data
***  OUTPUT REPORT:   008_mean_panel_matrix.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = panel_data,
    library = rawdata,
    sortby  = labtest trt week,
    keep    = subjid labtest trt week result
);

/*** GRAPH SECTION — matrix layout (2 lab tests x 3 timepoint subsets) ***/

/* Panel 1: Hemoglobin — Weeks 0-12 */
data hgb_early;
    set panel_data;
    where labtest = "Hemoglobin" and week <= 12;
run;

%graph(
    analfile  = hgb_early,
    xvar      = week,
    yvar      = result,
    xlabel    = Week,
    ylabel    = Hemoglobin (Early),
    effect    = trt,
    output    = 008_mean_panel_matrix,
    titlekey  = 008_mean_panel_matrix,
    gsfmode   = replace,
    central   = mean,
    cidist    = t,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    xorder    = 0 to 12 by 4,
    wantpdf   = N,
    wantrtf   = N
);

/* Panel 2: Hemoglobin — Weeks 12-24 */
data hgb_late;
    set panel_data;
    where labtest = "Hemoglobin" and week >= 12;
run;

%graph(
    analfile  = hgb_late,
    xvar      = week,
    yvar      = result,
    xlabel    = Week,
    ylabel    = Hemoglobin (Late),
    effect    = trt,
    output    = 008_mean_panel_matrix,
    titlekey  = 008_mean_panel_matrix,
    gsfmode   = append,
    central   = mean,
    cidist    = t,
    vertbar   = Y,
    join      = Y,
    legend    = Y,
    corner    = UL,
    xorder    = 12 to 24 by 4,
    wantpdf   = N,
    wantrtf   = N
);

/* Panel 3: Creatinine */
data creat;
    set panel_data;
    where labtest = "Creatinine";
run;

%graph(
    analfile  = creat,
    xvar      = week,
    yvar      = result,
    xlabel    = Week,
    ylabel    = Creatinine,
    effect    = trt,
    output    = 008_mean_panel_matrix,
    titlekey  = 008_mean_panel_matrix,
    gsfmode   = append,
    central   = mean,
    cidist    = t,
    vertbar   = Y,
    join      = Y,
    legend    = N,
    xorder    = 0 to 24 by 4,
    wantpdf   = N,
    wantrtf   = N
);

/* Panel 4: ALT */
data alt;
    set panel_data;
    where labtest = "ALT";
run;

%graph(
    analfile  = alt,
    xvar      = week,
    yvar      = result,
    xlabel    = Week,
    ylabel    = ALT,
    effect    = trt,
    output    = 008_mean_panel_matrix,
    titlekey  = 008_mean_panel_matrix,
    gsfmode   = append,
    central   = mean,
    cidist    = t,
    vertbar   = Y,
    join      = Y,
    legend    = N,
    xorder    = 0 to 24 by 4,
    wantpdf   = Y,
    wantrtf   = N
);
