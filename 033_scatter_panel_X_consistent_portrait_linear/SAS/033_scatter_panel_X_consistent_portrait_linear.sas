/*****************************************************************************
***  SAVED AS:        033_scatter_panel_X_consistent_portrait_linear.sas
***  DESCRIPTION:     Example 033 - Scatter panels, consistent X, portrait (tall).
***  INPUT  DATA SET: rawdata.scatter_panel_data
***  OUTPUT REPORT:   033_scatter_panel_X_consistent_portrait_linear.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=scatter_panel_data, library=rawdata, sortby=panel trt, keep=subjid panel trt x_val y_val);
proc univariate data=scatter_panel_data noprint; var x_val;
    output out=xr min=xmin max=xmax; run;
data _null_; set xr; call symput('xmin',put(floor(xmin/10)*10,best.)); call symput('xmax',put(ceil(xmax/10)*10,best.)); run;
/*** GRAPH SECTION — portrait: panels stacked vertically ***/
axis1 label=(h=1.8 pct "Baseline (x)") order=(&xmin to &xmax by 10) value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Endpoint (y)") value=(h=1.5 pct);
symbol1 i=rl v=circle h=.8 l=1 c=black; symbol2 i=rl v=square h=.8 l=2 c=blue; symbol3 i=rl v=triangle h=.8 l=4 c=red;
proc gplot data=scatter_panel_data;
    by panel; plot y_val*x_val=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "Scatter Panels — Consistent X Axis (Portrait)";
run; quit;
%gout2file(file=033_scatter_panel_X_consistent_portrait_linear, extension=pdf, igout=gseg, select=_all_)
