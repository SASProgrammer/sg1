/*****************************************************************************
***  SAVED AS:        052_qt_relation_rr.sas
***  DESCRIPTION:     Example 052 - QT interval vs RR interval (QT-RR relationship).
***  INPUT  DATA SET: rawdata.qtcb_rr_data  (subjid, trt, rr_interval, qt_interval)
***  OUTPUT REPORT:   052_qt_relation_rr.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata "."; %fetch(data=qtcb_rr_data, library=rawdata, sortby=trt, keep=subjid trt rr_interval qt_interval);
/* Compute Bazett correction line: QTc = QT / sqrt(RR/1000) */
data qtcb_rr_data; set qtcb_rr_data;
    qtcb_calc = qt_interval / sqrt(rr_interval/1000);
run;
/*** GRAPH SECTION ***/
axis1 label=(h=1.8 pct "RR Interval (ms)") order=(600 to 1200 by 100) value=(h=1.5 pct); axis2 label=(a=90 h=1.8 pct "QT Interval (ms)") order=(300 to 550 by 50) value=(h=1.5 pct);
symbol1 i=none v=circle h=.8 c=black; symbol2 i=none v=square h=.8 c=blue; symbol3 i=none v=triangle h=.8 c=red;
proc gplot data=qtcb_rr_data;
    plot qt_interval*rr_interval=trt / overlay haxis=axis1 vaxis=axis2 noframe;
    title "QT vs. RR Interval (Fridericia Correction Reference)";
run; quit;
%gout2file(file=052_qt_relation_rr, extension=pdf, igout=gseg, select=_last_)
