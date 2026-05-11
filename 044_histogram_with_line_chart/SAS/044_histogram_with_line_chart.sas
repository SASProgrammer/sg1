/*****************************************************************************
***  SAVED AS:        044_histogram_with_line_chart.sas
***  DESCRIPTION:     Example 044 - Histogram overlaid with normal density line.
***  INPUT  DATA SET: rawdata.hist_data  (subjid, trt, value)
***  OUTPUT REPORT:   044_histogram_with_line_chart.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=hist_data, library=rawdata, sortby=trt, keep=subjid trt value);
/* Compute histogram counts and normal curve overlay */
proc univariate data=hist_data noprint; var value; output out=stats mean=mu std=sigma; run;
data norm_curve; set stats; do x=0 to 100 by 2; density=pdf('normal',x,mu,sigma)*(10*200); output; end; run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Value") order=(0 to 100 by 10) value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Frequency") order=(0 to 50 by 10) value=(h=1.5 pct);
pattern v=s c=lightsteelblue; symbol i=spline l=1 w=2 c=red v=none;
proc gplot data=norm_curve;
    plot density * x / vaxis=axis2 haxis=axis1 noframe overlay;
    title "Histogram with Normal Density Overlay";
run; quit;
%gout2file(file=044_histogram_with_line_chart, extension=pdf, igout=gseg, select=_last_)
