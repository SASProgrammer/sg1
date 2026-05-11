/*****************************************************************************
***  SAVED AS:        042_Waterfall.sas
***  DESCRIPTION:     Example 042 - Waterfall chart of best % change per subject.
***  INPUT  DATA SET: rawdata.waterfall_data  (subjid, trt, best_pct_change)
***  OUTPUT REPORT:   042_Waterfall.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=waterfall_data, library=rawdata, sortby=trt best_pct_change, keep=subjid trt best_pct_change);
data waterfall_data; set waterfall_data; subjnum=_n_; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Subject") value=NONE; axis2 label=(a=90 h=1.8 pct "Best % Change from Baseline") order=(-100 to 100 by 20) value=(h=1.5 pct);
pattern1 v=s c=black; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=waterfall_data;
    vbar subjnum / type=sum sumvar=best_pct_change subgroup=trt noframe raxis=axis2 maxis=axis1;
    title "Waterfall Chart: Best % Change from Baseline";
run; quit;
%gout2file(file=042_Waterfall, extension=pdf, igout=gseg, select=_last_)
