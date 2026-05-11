/*****************************************************************************
***  SAVED AS:        048_scatter_plot_qtcb.sas
***  DESCRIPTION:     Example 048 - QTcB scatter plot with threshold lines.
***  INPUT  DATA SET: rawdata.qtcb_data  (subjid, trt, visit, qtcb)
***  OUTPUT REPORT:   048_scatter_plot_qtcb.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=qtcb_data, library=rawdata, sortby=trt visit, keep=subjid trt visit qtcb);
/* Compute mean QTcB per visit and treatment */
proc summary data=qtcb_data nway; class trt visit; var qtcb; output out=qtcb_mean mean=mean_qtcb n=n; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Study Visit") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "Mean QTcB (ms)") order=(360 to 460 by 20) value=(h=1.5 pct);
symbol1 i=j l=1 w=2 c=black  v=circle h=1; symbol2 i=j l=2 w=2 c=blue   v=square h=1; symbol3 i=j l=4 w=2 c=red    v=triangle h=1;
proc gplot data=qtcb_mean;
    plot mean_qtcb*visit=trt / overlay haxis=axis1 vaxis=axis2 noframe href=450 vref=450;
    title "Mean QTcB by Treatment Over Study Visits";
run; quit;
%gout2file(file=048_scatter_plot_qtcb, extension=pdf, igout=gseg, select=_last_)
