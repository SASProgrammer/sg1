/*****************************************************************************
***  SAVED AS:        035_scatter_single_panel_linear.sas
***  DESCRIPTION:     Example 035 - Single-panel scatter plot with linear regression.
***  INPUT  DATA SET: rawdata.scatter_data  (subjid, trt, x_val, y_val)
***  OUTPUT REPORT:   035_scatter_single_panel_linear.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=scatter_data, library=rawdata, sortby=trt, keep=subjid trt x_val y_val);

/* Compute regression line */
proc reg data=scatter_data noprint;
    model y_val = x_val;
    output out=reg_out p=predicted;
run;

/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Baseline Value (x)") value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Follow-up Value (y)") value=(h=1.5 pct);
symbol1 i=none    v=circle  h=1   c=black;
symbol2 i=none    v=square  h=1   c=blue;
symbol3 i=none    v=triangle h=1  c=red;
symbol4 i=rl      v=none    l=1   w=2 c=black;

proc gplot data=scatter_data;
    plot y_val * x_val = trt /
         overlay haxis=axis1 vaxis=axis2 noframe;
    title "Scatter Plot: Baseline vs. Follow-up";
run; quit;
%gout2file(file=035_scatter_single_panel_linear, extension=pdf, igout=gseg, select=_last_)
