/*****************************************************************************
***  SAVED AS:        003_kaplan-meier_sidak.sas
***  DESCRIPTION:     Example 003 - KM curve with Sidak simultaneous CI bands.
***                   PROC LIFETEST alpha= and conftype=ep produce EP CIs;
***                   Sidak adjustment: alpha* = 1 - (1-alpha)^(1/k) for k arms.
***  INPUT  DATA SET: rawdata.surv_data
***  OUTPUT REPORT:   003_kaplan-meier_sidak.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=surv_data, library=rawdata, sortby=trt time, keep=subjid trt time event);

/* Count number of strata for Sidak correction */
proc sql noprint;
    select count(distinct trt) into :k_strata from surv_data;
quit;

/* Compute Sidak-adjusted alpha */
data _null_;
    alpha_sidak = 1 - (1 - 0.05)**(1/&k_strata);
    call symput('alpha_sidak', put(alpha_sidak, best12.));
run;

/*** COMPUTE KM WITH SIDAK-ADJUSTED CI ***/
proc lifetest data=surv_data plots=none outsurv=km_sidak alpha=&alpha_sidak conftype=log;
    time time * event(0);
    strata trt;
run;

data km_plot;
    set km_sidak;
    survival_pct = survival * 100;
    surv_lcl_pct = sdf_lcl * 100;
    surv_ucl_pct = sdf_ucl * 100;
run;

/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Time (Months)") order=(0 to 24 by 4) value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Survival (%)") order=(0 to 100 by 20) value=(h=1.5 pct);
symbol1 i=steplj l=1 w=2 c=black v=none;
symbol2 i=steplj l=2 w=2 c=blue  v=none;
symbol3 i=steplj l=4 w=2 c=red   v=none;

proc gplot data=km_plot;
    plot survival_pct*time=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "KM Survival Curves with Sidak-Adjusted CI";
run; quit;
%gout2file(file=003_kaplan-meier_sidak, extension=pdf, igout=gseg, select=_last_)
