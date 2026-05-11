/*****************************************************************************
***  SAVED AS:        051_rr_vs_serum.sas
***  DESCRIPTION:     Example 051 - RR interval vs drug serum concentration.
***  INPUT  DATA SET: rawdata.pkpd_rr_data  (subjid, trt, conc, rr_interval)
***  OUTPUT REPORT:   051_rr_vs_serum.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=pkpd_rr_data, library=rawdata, sortby=trt, keep=subjid trt conc rr_interval);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Drug Concentration (ng/mL)") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "RR Interval (ms)") order=(700 to 1100 by 50) value=(h=1.5 pct);
symbol1 i=rl v=circle h=.8 c=black; symbol2 i=rl v=square h=.8 c=blue; symbol3 i=rl v=triangle h=.8 c=red;
proc gplot data=pkpd_rr_data;
    plot rr_interval*conc=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "RR Interval vs. Drug Concentration";
run; quit;
%gout2file(file=051_rr_vs_serum, extension=pdf, igout=gseg, select=_last_)
