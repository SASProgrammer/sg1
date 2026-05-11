/*****************************************************************************
***  SAVED AS:        043_Barchart_with_error_bar.sas
***  DESCRIPTION:     Example 043b - Bar chart with 95% CI error bars.
***  INPUT  DATA SET: rawdata.bar_data  (trt, category, n, pct, n_total)
***  OUTPUT REPORT:   043_Barchart_with_error_bar.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=bar_data, library=rawdata, sortby=category trt, keep=trt category n pct n_total);
/* Compute Wilson 95% CI for each proportion */
data bar_ci;
    set bar_data;
    p = pct/100; q = 1-p; n = n_total;
    z = probit(0.975);
    ci_lo = ((p + z**2/(2*n) - z*sqrt(p*q/n + z**2/(4*n**2))) / (1 + z**2/n)) * 100;
    ci_hi = ((p + z**2/(2*n) + z*sqrt(p*q/n + z**2/(4*n**2))) / (1 + z**2/n)) * 100;
run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "Category") value=(h=1.4 pct angle=30); axis2 label=(a=90 h=1.8 pct "Incidence (%)") order=(0 to 70 by 10) value=(h=1.5 pct);
pattern1 v=s c=black; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=bar_ci;
    vbar category / sumvar=pct type=sum subgroup=trt discrete raxis=axis2 maxis=axis1 noframe;
    title "Incidence (%) with 95% CI by Category and Treatment";
run; quit;
%gout2file(file=043_Barchart_with_error_bar, extension=pdf, igout=gseg, select=_last_)
