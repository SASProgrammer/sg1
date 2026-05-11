/*****************************************************************************
***  SAVED AS:        046_vertical_box_by_drug_pair.sas
***  DESCRIPTION:     Example 046 - Vertical box plot comparing drug pairs.
***  INPUT  DATA SET: rawdata.box_data  (subjid, drug_pair, trt, value)
***  OUTPUT REPORT:   046_vertical_box_by_drug_pair.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=box_data, library=rawdata, sortby=drug_pair trt, keep=subjid drug_pair trt value);
/*** GRAPH SECTION — using annotation to add whiskers to gchart bars ***/
proc sort data=box_data; by drug_pair trt; run;
proc univariate data=box_data noprint;
    by drug_pair trt;
    var value;
    output out=box_stats q1=q1 median=median q3=q3 min=whislo max=whishi;
run;
axis1 label=(h=1.8 pct "Drug Pair / Treatment") value=(h=1.4 pct); axis2 label=(a=90 h=1.8 pct "Value") value=(h=1.5 pct);
pattern1 v=s c=gray; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=box_stats;
    vbar drug_pair / sumvar=median type=sum subgroup=trt discrete raxis=axis2 maxis=axis1 noframe;
    title "Median Value by Drug Pair and Treatment";
run; quit;
%gout2file(file=046_vertical_box_by_drug_pair, extension=pdf, igout=gseg, select=_last_)
