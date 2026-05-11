/*****************************************************************************
***  SAVED AS:        043_barchart_geo.sas
***  DESCRIPTION:     Example 043 - Grouped bar chart (incidence by category).
***  INPUT  DATA SET: rawdata.bar_data  (trt, category, n, pct)
***  OUTPUT REPORT:   043_barchart_geo.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=bar_data, library=rawdata, sortby=category trt, keep=trt category n pct);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Category") value=(h=1.4 pct angle=30); axis2 label=(a=90 h=1.8 pct "Incidence (%)") order=(0 to 60 by 10) value=(h=1.5 pct);
pattern1 v=s c=black; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=bar_data;
    vbar category / sumvar=pct type=sum subgroup=trt group=category discrete raxis=axis2 maxis=axis1 noframe;
    title "Incidence by Category and Treatment";
run; quit;
%gout2file(file=043_barchart_geo, extension=pdf, igout=gseg, select=_last_)
