/*****************************************************************************
***  SAVED AS:        039_histogram.sas
***  DESCRIPTION:     Example 039 - Single histogram of a continuous variable.
***  INPUT  DATA SET: rawdata.hist_data  (subjid, trt, value)
***  OUTPUT REPORT:   039_histogram.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=hist_data, library=rawdata, sortby=trt, keep=subjid trt value);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Value") value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Frequency") value=(h=1.5 pct);
pattern1 v=s c=gray; pattern2 v=s c=blue; pattern3 v=s c=red;
proc gchart data=hist_data;
    vbar value / subgroup=trt midpoints=(0 10 20 30 40 50 60 70 80 90 100)
                 raxis=axis2 maxis=axis1 noframe;
    title "Histogram of Value by Treatment";
run; quit;
%gout2file(file=039_histogram, extension=pdf, igout=gseg, select=_last_)
