/*****************************************************************************
***  SAVED AS:        045_vertical_bar_chart_panel.sas
***  DESCRIPTION:     Example 045 - Vertical bar chart panels by visit.
***  INPUT  DATA SET: rawdata.bar_panel_data  (trt, visit, pct)
***  OUTPUT REPORT:   045_vertical_bar_chart_panel.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=bar_panel_data, library=rawdata, sortby=visit trt, keep=trt visit pct);
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Treatment") value=(h=1.4 pct); axis2 label=(a=90 h=1.8 pct "Response Rate (%)") order=(0 to 70 by 10) value=(h=1.5 pct);
pattern1 v=s c=black; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=bar_panel_data;
    by visit; vbar trt / sumvar=pct type=sum raxis=axis2 maxis=axis1 noframe discrete;
    title "Response Rate by Treatment — Visit #byval1";
run; quit;
%gout2file(file=045_vertical_bar_chart_panel, extension=pdf, igout=gseg, select=_all_)
