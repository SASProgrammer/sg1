/*****************************************************************************
***  SAVED AS:        004_kaplan-meier_increasing.sas
***  DESCRIPTION:     Example 004 - KM cumulative incidence (1 - survival).
***                   Shows increasing probability of response over time.
***  INPUT  DATA SET: rawdata.response_data  (subjid, trt, time, response)
***  OUTPUT REPORT:   004_kaplan-meier_increasing.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=response_data, library=rawdata, sortby=trt time, keep=subjid trt time response);

proc lifetest data=response_data plots=none outsurv=km_resp noprint;
    time time * response(0);
    strata trt;
run;

/* Cumulative incidence = 1 - survival */
data km_ci;
    set km_resp;
    cum_incidence_pct = (1 - survival) * 100;
run;

proc sort; by trt time; run;

/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Time (Months)") order=(0 to 24 by 4) value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Cumulative Response (%)") order=(0 to 100 by 20) value=(h=1.5 pct);
symbol1 i=steplj l=1 w=2 c=black v=none;
symbol2 i=steplj l=2 w=2 c=blue  v=none;
symbol3 i=steplj l=4 w=2 c=red   v=none;

proc gplot data=km_ci;
    plot cum_incidence_pct*time=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "Cumulative Response Rate by Treatment (1 - KM Estimator)";
run; quit;
%gout2file(file=004_kaplan-meier_increasing, extension=pdf, igout=gseg, select=_last_)
