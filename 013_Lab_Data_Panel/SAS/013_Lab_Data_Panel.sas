/*****************************************************************************
***  SAVED AS:        013_Lab_Data_Panel.sas
***  DESCRIPTION:     Example 013 - Paneled lab data plot (one panel per test).
***  INPUT  DATA SET: rawdata.multi_lab_data
***  OUTPUT REPORT:   013_Lab_Data_Panel.pdf
*****************************************************************************/

/*** DATA BUILD SECTION ***/
libname rawdata ".";

%fetch(data=multi_lab_data, library=rawdata,
       sortby=labtest trt visit, keep=subjid labtest trt visit lbresult);

/*** GRAPH SECTION ***/
%graph(
    analfile=multi_lab_data, byvar=labtest,
    xvar=visit, yvar=lbresult,
    xlabel=Study Visit, ylabel=Mean Result (95% CI),
    effect=trt, output=013_Lab_Data_Panel, titlekey=013_Lab_Data_Panel,
    central=mean, cidist=t, cilevel=95,
    vertbar=Y, join=Y, legend=Y, corner=UL, annot=Y,
    wantpdf=Y, wantrtf=N
);
