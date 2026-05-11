/*****************************************************************************
***  SAVED AS:        001_kaplan_meier.sas
***
***  DESCRIPTION:     Example 001 - Basic Kaplan-Meier survival curve.
***                   Uses PROC LIFETEST to estimate KM curves for 2-3
***                   treatment arms and overlays them with PROC GPLOT.
***
***  INPUT  DATA SET: rawdata.surv_data  (subjid, trt, time, event)
***  OUTPUT REPORT:   001_kaplan_meier.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/

libname rawdata ".";

%fetch(
    data    = surv_data,
    library = rawdata,
    sortby  = trt time,
    keep    = subjid trt time event
);

/*** COMPUTE KM ESTIMATES ***/

proc lifetest data=surv_data plots=none outsurv=km_est;
    time time * event(0);
    strata trt;
run;

/*** GRAPH SECTION ***/

/* Map survival function to gplot-compatible dataset */
data km_plot;
    set km_est;
    survival_pct = survival * 100;
run;

proc sort data=km_plot;
    by trt time;
run;

axis1 offset=(2 pct, 2 pct) label=(h=1.8 pct "Time (Months)")
      order=(0 to 24 by 4) value=(h=1.5 pct);
axis2 offset=(1 pct, 1 pct) label=(a=90 h=1.8 pct "Survival Probability (%)")
      order=(0 to 100 by 20) value=(h=1.5 pct);

symbol1 i=steplj l=1 w=2 c=black  v=none;
symbol2 i=steplj l=2 w=2 c=blue   v=none;
symbol3 i=steplj l=4 w=2 c=red    v=none;

proc gplot data=km_plot;
    plot survival_pct * time = trt /
         overlay haxis=axis1 vaxis=axis2 noframe;
    title "Kaplan-Meier Survival Estimates by Treatment";
run;
quit;

/* Save as PDF */
%gout2file(file=001_kaplan_meier, extension=pdf, igout=gseg, select=_last_)
