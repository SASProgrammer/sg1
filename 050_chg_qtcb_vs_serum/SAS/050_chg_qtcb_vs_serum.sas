/*****************************************************************************
***  SAVED AS:        050_chg_qtcb_vs_serum.sas
***  DESCRIPTION:     Example 050 - Change in QTcB vs drug concentration.
***  INPUT  DATA SET: rawdata.pkpd_chg_data  (subjid, trt, conc, chg_qtcb)
***  OUTPUT REPORT:   050_chg_qtcb_vs_serum.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=pkpd_chg_data, library=rawdata, sortby=trt, keep=subjid trt conc chg_qtcb);
proc reg data=pkpd_chg_data noprint; model chg_qtcb=conc; output out=reg_out p=predicted; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Drug Concentration (ng/mL)") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "Change in QTcB (ms)") order=(-20 to 60 by 10) value=(h=1.5 pct);
symbol1 i=none v=circle h=.8 c=black; symbol2 i=none v=square h=.8 c=blue; symbol3 i=none v=triangle h=.8 c=red; symbol4 i=rl l=1 w=2 v=none c=black;
proc gplot data=pkpd_chg_data;
    plot chg_qtcb*conc=trt / overlay haxis=axis1 vaxis=axis2 noframe vref=0 vref=10 vref=20;
    title "Change in QTcB vs. Drug Concentration";
run; quit;
%gout2file(file=050_chg_qtcb_vs_serum, extension=pdf, igout=gseg, select=_last_)
