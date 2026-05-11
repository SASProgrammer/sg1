/*****************************************************************************
***  SAVED AS:        031_scatter_matrix_linear.sas
***  DESCRIPTION:     Example 031 - Scatter plot matrix (multiple Y variables vs. X).
***  INPUT  DATA SET: rawdata.scatter_matrix_data
***  OUTPUT REPORT:   031_scatter_matrix_linear.pdf
*****************************************************************************/
/*** DATA BUILD SECTION ***/
libname rawdata ".";
%fetch(data=scatter_matrix_data, library=rawdata, sortby=trt, keep=subjid trt x_val y1 y2 y3);

/*** GRAPH SECTION — one panel per Y variable ***/
%macro scatter_matrix;
    %let yvars = y1 y2 y3;
    %let ylabels = %str(Endpoint 1|Endpoint 2|Endpoint 3);
    %do p=1 %to 3;
        %let yv = %scan(&yvars,&p);
        %let yl = %scan(&ylabels,&p,|);
        axis1 label=(h=1.8 pct "Baseline (x)") value=(h=1.5 pct);
        axis2 label=(a=90 h=1.8 pct "&yl") value=(h=1.5 pct);
        symbol1 i=rl v=circle h=0.8 c=black; symbol2 i=rl v=square h=0.8 c=blue; symbol3 i=rl v=triangle h=0.8 c=red;
        proc gplot data=scatter_matrix_data gout=gseg;
            plot &yv * x_val = trt / overlay haxis=axis1 vaxis=axis2 noframe;
            title "Scatter Matrix — &yl vs. Baseline";
        run;
    %end;
%mend;
%scatter_matrix;
%gout2file(file=031_scatter_matrix_linear, extension=pdf, igout=gseg, select=_all_)
