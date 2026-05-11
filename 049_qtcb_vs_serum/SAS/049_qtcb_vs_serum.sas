/*****************************************************************************
***  SAVED AS:        049_qtcb_vs_serum.sas
***  DESCRIPTION:     Example 049 - QTcB vs. serum drug concentration scatter.
***  INPUT  DATA SET: rawdata.pkpd_data  (subjid, trt, conc, qtcb)
***  OUTPUT REPORT:   049_qtcb_vs_serum.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=pkpd_data, library=rawdata, sortby=trt, keep=subjid trt conc qtcb);
proc reg data=pkpd_data noprint; model qtcb=conc; output out=reg_out p=predicted; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Drug Concentration (ng/mL)") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "QTcB (ms)") order=(360 to 470 by 20) value=(h=1.5 pct);
symbol1 i=none v=circle  h=0.8 c=black; symbol2 i=none v=square  h=0.8 c=blue; symbol3 i=none v=triangle h=0.8 c=red;
symbol4 i=rl l=1 w=2 v=none c=black;
proc gplot data=pkpd_data;
    plot qtcb * conc = trt / overlay haxis=axis1 vaxis=axis2 noframe href=2 vref=450;
    title "QTcB vs. Drug Concentration";
run; quit;
%gout2file(file=049_qtcb_vs_serum, extension=pdf, igout=gseg, select=_last_)
