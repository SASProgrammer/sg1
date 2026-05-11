/*****************************************************************************
***  SAVED AS:        030_subject_disposition_with_cumulative_percent.sas
***  DESCRIPTION:     Example 030 - Subject disposition stacked bar with cumulative %.
***  INPUT  DATA SET: rawdata.disposition_data  (trt, disposition_cat, n, pct)
***  OUTPUT REPORT:   030_subject_disposition_with_cumulative_percent.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=disposition_data, library=rawdata, sortby=trt disposition_cat, keep=trt disposition_cat n pct);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Treatment") value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "Subjects (%)") order=(0 to 100 by 20) value=(h=1.5 pct);
pattern1 v=s c=green; pattern2 v=s c=yellow; pattern3 v=s c=orange; pattern4 v=s c=red;
proc gchart data=disposition_data;
    vbar trt / sumvar=pct type=sum subgroup=disposition_cat discrete raxis=axis2 maxis=axis1 noframe;
    title "Subject Disposition with Cumulative Percentage";
run; quit;
%gout2file(file=030_subject_disposition_with_cumulative_percent, extension=pdf, igout=gseg, select=_last_)
