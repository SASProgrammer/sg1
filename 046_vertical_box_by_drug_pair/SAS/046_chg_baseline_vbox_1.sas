 
/********************************************************************************* 

Program Name           : chg_baseline_vbox_1.sas  

Path                   : sg1/046_vertical_box_by_drug_pair

Purpose                : To demonstrate the use of Graph Template Datapanel in the following situation:
                            1) Output Requirements: 
                                a) Create a panel of Bar Charts with Confidence Intervals
                            2) Environmental Factors:
                                   a) Simulating execution of a "init.sas" to set some global macro variables.
                                   b) Simulating use of the PI Manager.  Not using regular SAS 
                                      titles and footnotes.

Input Datasets/Views   : Program generated

Macro calls external   : None

Outputs                : &Program..rtf

Program Flow           : 1) Set SAS options and style template libname.
                         2) Set macro variables that make code easier to read
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Create treatment formats.
                         6) Read in data source.
                         7) Generate the change from baseline data.
                         8) Turn on ODS graphics
                         9) Call SGPANEL to display VBOX by treatment panels.
                        10) Close ODS graphics
                        11) Delete temporary PNG file.   
                                                          
Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ------------------------------------
001     1.00    05/14/26        dgianneschi     Create.
************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ 'sg1\000_style_template' access=readonly;
 
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

 ods listing;
 
*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = chg_baseline_vbox_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;
 %let Source_   = labs;
 %let n_pla     = 15;
 %let n_act     = 15;
 
 title1 "Figure 5.1 Change from Baseline for Glucose By Visit";
 title2 "(Full Analysis Set)";
 footnote1;
 
*-----------------------------------------------------------------------------------
 3) Simulate call SSUB call to /tools/init.inc                       (template code)
 -----------------------------------------------------------------------------------;
%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*-------------------------------------------------------------------------------------
 4) Define title and set global variables.                             (template code)
 -------------------------------------------------------------------------------------;
%let Titles = title1 # title2;
%let outname=&Outfile_;
* set to lab test the report will be run on *;
%let lbtest=GLU;
%let n_pla =15;
%let n_act =15;

*-----------------------------------------------------------------------------------
 5) Create treatment formats.                                       (functional code)
 -----------------------------------------------------------------------------------;

proc format;
   value trtgrpf
     1 = "Placebo (N=&n_pla)"
     2 = "AMD001 (N=&n_act)"
	 ;
run;

*-----------------------------------------------------------------------------------
 6) Read in data source.                                           (functional code)
 -----------------------------------------------------------------------------------;

%include "&Dir_/data_source.sas";

data labs;
   set indata;
   if lbtest="&lbtest";
run;

*-----------------------------------------------------------------------------------
 7) Generate the change from baseline data.                        (functional code)
 -----------------------------------------------------------------------------------;

proc sort data=labs;
   by usubjid visitwk;
run;

data base(keep=usubjid visitwk lbtest lbstresn rename=(lbstresn=baseval visitwk=basevis))
     main;
   set labs;
   by usubjid visitwk;
   if visitwk = 0 or first.usubjid then output base;
   output main;
run;

data combine;
   format trtcd trtgrpf.;
   merge labs(in=inmain)
         base(in=inbase);
   by usubjid;
   if inmain;
   if baseval ne . and lbstresn ne . then chgbase = lbstresn - baseval;

run;

*----------------------------------------------------------------------------------  
 8)  Set ODS graphics on and specify required ODS graphics parameters to create a
      RTF file for the CSR and SGE file nonCSR purposes such publications.
      Landscape available HEIGHT and WIDTH is 6.00 and 9.25 inches.   (template code)
-----------------------------------------------------------------------------------;
  
  ods graphics on / reset=all height=5.00in width=9.25in imagemap=on border=off 
                    imagename="&outfile_" ; /* For PNG and SGE file type */

  * Noproctitle suppresses the writing of the title of the procedure that produces the results *;
  ods noproctitle;
  * Select only the Survival Plot for the RTF destination                    *;
  *  Without using the select statement all statistical output listings are  *;
  *  also written to the RTF destination                                     *;

  ODS PROCLABEL "string"; 

  ods rtf 
      nogtitle                              /* Put title in RTF text outside of graph */      
      bodytitle     
      notoc_data 
      file          = "&outfile_..rtf"      /* RTF File Name */
      style         = &Style_RTF            /* ODS style template */
      headery       = 1080                  /* 0.75in space shared with top margin */
      footery       = 360                   /* 0.25in space shared with bottom margin */
      image_dpi     = 300
   ;

**-----------------------------------------------------------------------------------
 9) Call SGPANEL to display VBOX by treatment panels                (template code)
 -----------------------------------------------------------------------------------; 
proc sgpanel data=combine cycleattrs;
   panelby visitwk / columns=9 rows=1 spacing=2 uniscale=all novarname;
   vbox chgbase / category=trtcd boxwidth=0.4;
   rowaxis label="Change from baseline (g/L)";
   colaxis label="Treatment";
   footnote1 j=l "Study Footnote";
   footnote2 j=l "Program: &dir_./&Program..sas"; 
   footnote3 j=l "Output: &Outfile_..rtf (Date Generated: &sysdate &systime)  Source Data: &Source_.";  

run;

*---------------------------------------------------------------------------------  
 10) Close graphic output files and write to disk.                  (template code)
 ---------------------------------------------------------------------------------;
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;
 ods path     clear;

*---------------------------------------------------------------------------------  
 11) Delete temporary PNG file.                                     (template code)
 ---------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(myRef,&outfile_..png));
%let sysrc=%sysfunc(fdelete(&myRef)); 

* close graphics file *;
ods graphics off;
ods rtf close;