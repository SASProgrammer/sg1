/*****************************************************************************
***  SAVED AS:        002_kaplan_meier_panel.sas
***  DESCRIPTION:     Example 002 - Paneled KM curves (one panel per stratum).
***  INPUT  DATA SET: rawdata.surv_strata_data  (subjid, trt, stratum, time, event)
***  OUTPUT REPORT:   002_kaplan_meier_panel.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=surv_strata_data, library=rawdata, sortby=stratum trt time, keep=subjid stratum trt time event);

/*** GRAPH SECTION — one KM plot per stratum ***/
%macro km_panel;
    %let strata_list = Low High;
    %do s=1 %to 2;
        %let strat = %scan(&strata_list,&s);
        data sub; set surv_strata_data; where stratum="&strat"; run;
        proc lifetest data=sub plots=none outsurv=km_&s noprint;
            time time * event(0); strata trt;
        run;
        data km_&s; set km_&s; stratum="&strat"; survival_pct=survival*100; run;
    %end;
    data km_all; set km_1 km_2; run;
%mend;
%km_panel;

proc sort data=km_all; by stratum trt time; run;

axis1 label=(h=1.8 pct "Time (Months)") order=(0 to 24 by 4) value=(h=1.5 pct);
axis2 label=(a=90 h=1.8 pct "Survival (%)") order=(0 to 100 by 20) value=(h=1.5 pct);
symbol1 i=steplj l=1 w=2 c=black v=none;
symbol2 i=steplj l=2 w=2 c=blue  v=none;
symbol3 i=steplj l=4 w=2 c=red   v=none;

proc gplot data=km_all;
    by stratum;
    plot survival_pct*time=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "KM Survival Curves by Treatment and Stratum";
run; quit;

%gout2file(file=002_kaplan_meier_panel, extension=pdf, igout=gseg, select=_all_)
