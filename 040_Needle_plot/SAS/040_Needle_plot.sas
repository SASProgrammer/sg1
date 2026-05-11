/*****************************************************************************
***  SAVED AS:        040_Needle_plot.sas
***  DESCRIPTION:     Example 040 - Needle (stem) plot of per-subject % change.
***  INPUT  DATA SET: rawdata.needle_data  (subjid, trt, pct_change)
***  OUTPUT REPORT:   040_Needle_plot.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=needle_data, library=rawdata, sortby=trt pct_change, keep=subjid trt pct_change);
data needle_data; set needle_data; subjnum=_n_; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Subject") value=NONE width=2;
axis2 label=(a=90 h=1.8 pct "% Change from Baseline") order=(-100 to 100 by 20) value=(h=1.5 pct);
symbol1 i=needle l=1 w=2 c=black  v=NONE;
symbol2 i=needle l=1 w=2 c=blue   v=NONE;
symbol3 i=needle l=1 w=2 c=red    v=NONE;
proc gplot data=needle_data;
    plot pct_change * subjnum = trt /
         overlay haxis=axis1 vaxis=axis2 noframe href=0;
    title "Needle Plot: % Change from Baseline by Subject";
run; quit;
%gout2file(file=040_Needle_plot, extension=pdf, igout=gseg, select=_last_)
