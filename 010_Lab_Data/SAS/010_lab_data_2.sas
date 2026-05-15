/*********************************************************************************

Program Name           : lab_data_2.sas

Path                   : sg1\010_lab_data

Purpose                : To demonstrate the use of SAS 9.2 to generate quick plots:
                          1) Output Requirements:
                             a) Series plots plotted by subject
                          2) Environmental Factors:
                             a) N/A

Input Datasets/Views   : included-indata

Macro calls external   : N/A

Production Outputs     : &Program..rtf  
                         &Program..pdf

Qualification Outputs  : None.

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Pre-process the data 
                          7) Define macro to generate the SGPLOT call to produce 
                             the series plots with reference lines
                          8) Set ODS graphics on and specify required ODS graphics 
                             parameters for PDF                    
                          9) Run the SG code with the macro. Close graphic output PDF
                             and SGE file and write to disk.   
                         10) Reset  ODS graphics options and set RTF file options.  
                         11) Run the SG code with the macro. Close RTF graphic output and
                             write to disk. 
                         12) Delete temporary PNG file. 

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ------------------------------------
001     1.00    05/14/26        dgianneschi     Create.
************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ 'sg1\000_style_templates' access=readonly;
 
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);
 
*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
* set to lab test the report will be run on *;
%let lbtest = GLU;

* N counts can be introduced a different way *;
%let ct_act = 24;
%let ct_pla = 34;

libname Dir_ '.';
 %let Dir_  =%sysfunc(pathname(Dir_));
 
 %let Program_  = lab_data_with_subject_in_plotarea;
 %let Style_RTF =US_Landscape_SG_Color; 

 *-----------------------------------------------------------------------------------  
 3) Set titles and footnotes, adjust for RTF and PDF width.(template/functional code)
 -----------------------------------------------------------------------------------*;
 %macro titles(pdf=Y);
    title1 j=r h=1.0 'Avidity Biosciences, Inc.';
    title2 j=r h=1.0 'Study AV-US-xxx-xxx';
    title3 "Figure 3.1 Glucose Values By Visit";
    title4 "(Full Analysis Set)";
    %if %upcase(&pdf)=Y %then %do; 
        footnote1 j=l "_________________________________________________________________"
                      "_________________________________________________________________";
     %end;
     %else %do; 
        footnote1 j=l "_________________________________________________________________"
                      "_________________________________________________________________________";
     %end;

    footnote2 j=l "Study Footnote.";
    footnote3 j=l "Data Extracted: program_generated   " 
                   "Source: &Program_..sas   "
                   "Output file: &Program_..rtf &sysdate &systime ";
 %mend titles;
                                       
*-----------------------------------------------------------------------------------
 5) Build formats to help in data generation                         (template code)
 -----------------------------------------------------------------------------------;

proc format;
   value trtgroup
     1 = "Placebo (N=&ct_pla)"
     2 = "Active (N=&ct_act)";
run;

*-----------------------------------------------------------------------------------
 6) Generate data                                                   (functional code)
 -----------------------------------------------------------------------------------;

%include "&dir_./data_source.sas";

*-----------------------------------------------------------------------------------
 7) Pre-process the data                                          (functional code)
 -----------------------------------------------------------------------------------;

proc sort data=indata out=labs;
   by usubjid visitwk;
run;

data labs;
   set labs;    
   if lbtest="&lbtest";
   * adjust to position display *;
   lbstresn = lbstresn + 20;
   /* Delete some records to show proper display of usubjid at their last visit. This is to avoid
      overlaping of numbers. */      
   if usubjid in (2101 2102 2104 2107 2110 3118) and visitwk gt 4 then delete;
   if usubjid in (2111 2112 2114 3111 2117 2120 3101 3106 3108) and visitwk gt 6 then delete;
   if usubjid in (2108 2122 3103 3107 3120 3105) and visitwk gt 7 then delete;
   if usubjid in (2105 2115 3116 3108 2119) and visitwk gt 2 then delete;      
   if usubjid in (3102 2119) and visitwk gt 3 then delete;  
run;


data labs;
   set labs;
   by usubjid visitwk;
   * this sets the patient label to display on the last recorded visit *; 
   if last.usubjid then do;
      vis2=visitwk;
   end;
   else do;
      vis2 = . ;
   end;     
 run;
 
*-----------------------------------------------------------------------------------
 8) Generate the series plots with reference lines.                   (template code)
 -----------------------------------------------------------------------------------;
 %macro loop;
   ods escapechar='~';

   * call SGPLOT for GLU values *;
   proc sgplot data=labs ;
      series x=visitwk y=lbstresn / group=usubjid markers lineattrs=(thickness=1)
                                               markerattrs=(size=5);
      series x=vis2    y=lbstresn / group=usubjid datalabel=usubjid;
      refline 25 35 / axis=y lineattrs=(thickness=1) label=("LLN 25" "HLN 35");
      yaxis label="Glucose (mmol/L)";
      xaxis label="Study Visit";
      keylegend /location=outside position=bottomleft noborder across=6;
    run;

%mend loop;

*----------------------------------------------------------------------------------  
 9) Set ODS graphics on and specify required ODS graphics parameters to create a
    PDF output and an SGE file for presentation purposes.            (template code) 
 -----------------------------------------------------------------------------------;
 ods graphics on / reset=all height=5.00in width=9.00in imagemap=on border=off 
                     imagename="&Program_" ; /* For PNG file type */
 ods pdf 
        notoc
        file         = "&Program_..pdf"      /* pdf File Name */
        style        = &Style_RTF            /* ODS style template */
        dpi          = 300                   /* Publication quality resolution */
        ;
       
*----------------------------------------------------------------------------------  
 10) Run the SG code with the macro. Close graphic output PDF and SGE
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 %titles(PDF=Y);
 %loop;
 
 ods pdf      close;                        * Output PDF file ;

 *----------------------------------------------------------------------------------  
  10) Reset  ODS graphics options and set RTF file options.           (template code)
      RTF title is kept outside the graph to allow editing in WORD.
  -----------------------------------------------------------------------------------;
  ods graphics on / reset=all height=4.75in width=9.00in imagemap=on border=off 
                   imagename="&Program_" ; /* For PNG file type */

  ods rtf 
    nogtitle                              /* Put title in RTF text outside of graph */      
    bodytitle  
    notoc_data 
    file          = "&Program_..rtf"      /* RTF File Name */
    style         = &Style_RTF            /* ODS style template */
    headery       = 1080                  /* 0.75in space shared with top margin */
    footery       = 360                   /* 0.25in space shared with bottom margin */
    image_dpi     = 300
 ;

*----------------------------------------------------------------------------------  
 11) Run the GTL program with proc sgrender. Close graphic output RTF
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 %titles(PDF=N);
 %loop;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));
 %let rc=%sysfunc(filename(png,SGPlot.png));
 %let sysrc=%sysfunc(fdelete(&png));


