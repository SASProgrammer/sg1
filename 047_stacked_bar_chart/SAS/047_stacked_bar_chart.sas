/*****************************************************************************
***  SAVED AS:        047_stacked_bar_chart.sas
***  DESCRIPTION:     Example 047 - Stacked bar chart of response categories.
***  INPUT  DATA SET: rawdata.stacked_data  (trt, response_cat, pct)
***  OUTPUT REPORT:   047_stacked_bar_chart.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=stacked_data, library=rawdata, sortby=trt response_cat, keep=trt response_cat pct);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Treatment") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "Percentage (%)") order=(0 to 100 by 20) value=(h=1.5 pct);
pattern1 v=s c=green; pattern2 v=s c=lightgreen; pattern3 v=s c=yellow; pattern4 v=s c=orange; pattern5 v=s c=red;
proc gchart data=stacked_data;
    vbar trt / sumvar=pct type=sum subgroup=response_cat discrete raxis=axis2 maxis=axis1 noframe;
    title "Response Categories by Treatment (Stacked)";
run; quit;
%gout2file(file=047_stacked_bar_chart, extension=pdf, igout=gseg, select=_last_)
