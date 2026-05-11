/*****************************************************************************
***  SAVED AS:        041_Needle_panel.sas
***  DESCRIPTION:     Example 041 - Paneled needle plots (one panel per treatment).
***  INPUT  DATA SET: rawdata.needle_data
***  OUTPUT REPORT:   041_Needle_panel.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=needle_data, library=rawdata, sortby=trt pct_change, keep=subjid trt pct_change);
data needle_data; set needle_data; by trt; if first.trt then subjnum=0; subjnum+1; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Subject") value=NONE; axis2 label=(a=90 h=1.8 pct "% Change") order=(-100 to 100 by 20) value=(h=1.5 pct);
symbol1 i=needle l=1 w=2 c=steelblue v=NONE;
proc gplot data=needle_data;
    by trt; plot pct_change*subjnum / haxis=axis1 vaxis=axis2 noframe href=0;
    title "Needle Plot: % Change — #byval1";
run; quit;
%gout2file(file=041_Needle_panel, extension=pdf, igout=gseg, select=_all_)
