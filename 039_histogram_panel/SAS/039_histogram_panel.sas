/*****************************************************************************
***  SAVED AS:        039_histogram_panel.sas
***  DESCRIPTION:     Example 039_panel - Paneled histograms (one per treatment).
***  INPUT  DATA SET: rawdata.hist_data
***  OUTPUT REPORT:   039_histogram_panel.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=hist_data, library=rawdata, sortby=trt, keep=subjid trt value);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Value") value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Frequency") value=(h=1.5 pct);
pattern v=s c=steelblue;
proc gchart data=hist_data;
    by trt;
    vbar value / midpoints=(0 10 20 30 40 50 60 70 80 90 100)
                 raxis=axis2 maxis=axis1 noframe;
    title "Histogram of Value — #byval1";
run; quit;
%gout2file(file=039_histogram_panel, extension=pdf, igout=gseg, select=_all_)
