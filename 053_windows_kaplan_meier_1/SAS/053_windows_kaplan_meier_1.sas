/*****************************************************************************
***  SAVED AS:        053_windows_kaplan_meier_1.sas
***  DESCRIPTION:     Example 053 - KM curve rendered for Windows (EMF/PowerPoint).
***                   Demonstrates wantemf=Y output for PC-side pcgraph rendering.
***  INPUT  DATA SET: rawdata.surv_data
***  OUTPUT REPORT:   053_windows_kaplan_meier_1.pdf / .emf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=surv_data, library=rawdata, sortby=trt time, keep=subjid trt time event);

proc lifetest data=surv_data plots=none outsurv=km_est noprint;
    time time * event(0);
    strata trt;
run;

data km_plot;
    set km_est;
    survival_pct=survival*100;
run;

/*** GRAPH SECTION — outputs both PDF (Linux) and EMF extract (Windows PC) ***/
axis1 label=(h=2.6 pct "Time (Months)") order=(0 to 24 by 4) value=(h=2.4 pct);
axis2 label=(a=90 h=2.6 pct "Survival (%)") order=(0 to 100 by 20) value=(h=2.4 pct);
symbol1 i=steplj l=1 w=2 c=white v=none;
symbol2 i=steplj l=3 w=2 c=yellow v=none;
symbol3 i=steplj l=5 w=2 c=cyan  v=none;

goptions cback=cx0000dc ftext='Times/bold' htext=2.4 pct;

proc gplot data=km_plot gout=gseg;
    plot survival_pct*time=trt / overlay haxis=axis1 vaxis=axis2 noframe cframe=cx0000dc;
    title c=white h=3.5 pct "Kaplan-Meier Survival Estimates by Treatment";
run; quit;

/* Create PDF (black & white) */
%gout2file(file=053_windows_kaplan_meier_1, extension=pdf, igout=gseg, select=_last_)
/* Trigger EMF extract for Windows PowerPoint rendering */
/* wantemf=Y in graph() would call pcgraph on the PC side */
