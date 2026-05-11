/*****************************************************************************
***  SAVED AS:        034_scatter_panel_Y_consistent_linear.sas
***  DESCRIPTION:     Example 034 - Scatter panels with consistent Y axis.
***  INPUT  DATA SET: rawdata.scatter_panel_data
***  OUTPUT REPORT:   034_scatter_panel_Y_consistent_linear.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=scatter_panel_data, library=rawdata, sortby=panel trt, keep=subjid panel trt x_val y_val);
proc univariate data=scatter_panel_data noprint; var y_val;
    output out=yr min=ymin max=ymax; run;
data _null_; set yr; call symput('ymin',put(floor(ymin/10)*10,best.)); call symput('ymax',put(ceil(ymax/10)*10,best.)); run;
/*** GRAPH SECTION — consistent Y across all panels ***/
axis1 label=(h=1.8 pct "Baseline (x)") value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Endpoint (y)") order=(&ymin to &ymax by 10) value=(h=1.5 pct);
symbol1 i=rl v=circle h=.8 l=1 c=black; symbol2 i=rl v=square h=.8 l=2 c=blue; symbol3 i=rl v=triangle h=.8 l=4 c=red;
proc gplot data=scatter_panel_data;
    by panel; plot y_val*x_val=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "Scatter Panels — Consistent Y Axis";
run; quit;
%gout2file(file=034_scatter_panel_Y_consistent_linear, extension=pdf, igout=gseg, select=_all_)
