/*****************************************************************************
***  SAVED AS:        054_tnfset_titlekey_example_043.sas
***
***  DESCRIPTION:     Example 054 - Demonstrates the TNFSet / TitleKey title
***                   and footnote system. Reuses the 043 bar chart with error
***                   bars but drives all titles and footnotes from a tnf.inc
***                   include file referenced by the titlekey parameter.
***
***                   In the BAE framework:
***                     - titlekey maps to a row in a titles/footnotes lookup
***                     - %graphini reads the tnf.inc file and emits title/
***                       footnote statements automatically
***                     - Programs are self-documenting: the tnf.inc file is
***                       the single source of truth for all display text
***
***  INPUT  DATA SET: rawdata.bar_data  (trt, category, n, pct, ci_lo, ci_hi)
***  OUTPUT REPORT:   054_tnfset_titlekey_example_043.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=bar_data, library=rawdata, sortby=category trt, keep=trt category n pct ci_lo ci_hi n_total);

/*** GRAPH SECTION — same chart as 043 but with titlekey-driven titles ***/
/* In production: %graphini(titlekey=054_tnfset_titlekey_example_043) would  */
/* read the tnf.inc file and set title1-title6 and footnote1-footnote6.      */
/* Here we set titles manually to illustrate the pattern.                    */
title1 j=l h=1.5 pct "Study XYZ — Gilead Sciences";
title2 j=l h=1.5 pct "Protocol ABC-123";
title3 j=c h=1.8 pct "Figure 1. Incidence (%) of Adverse Events by Category";
title4 j=c h=1.5 pct "Safety Population";
footnote1 j=l h=1.3 pct "Source: &jobname..sas";
footnote2 j=l h=1.3 pct "AE=Adverse Event. CI=95% Confidence Interval (Wilson method).";

axis1 label=(h=1.8 pct "Category") value=(h=1.4 pct angle=30);
axis2 label=(a=90 h=1.8 pct "Incidence (%)") order=(0 to 70 by 10) value=(h=1.5 pct);
pattern1 v=s c=black; pattern2 v=s c=steelblue; pattern3 v=s c=red;
proc gchart data=bar_data;
    vbar category / sumvar=pct type=sum subgroup=trt discrete raxis=axis2 maxis=axis1 noframe;
run; quit;
%gout2file(file=054_tnfset_titlekey_example_043, extension=pdf, igout=gseg, select=_last_)
