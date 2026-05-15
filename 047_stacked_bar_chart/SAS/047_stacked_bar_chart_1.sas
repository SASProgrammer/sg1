/*********************************************************************************

Program Name           : stacked_bar_chart_1.sas

Path                   : sg1\047_stacked_bar_chart
                                  
Purpose                : To demonstrate the use of SAS 9.2 to generate quick plots:
                          1) Output Requirements:
                             a) Parameterized Stacked Bar Chart
                          
Input Datasets/Views   : Input Dataset

Macro calls external   : none

Outputs                : &Program..rtf  

Program Flow           : 1) Set SAS options and style template libname
                         2) Set global macro variable that make code easier to read.
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Set ODS graphics on and specify required ODS graphics parameters                         
                         6) Use SG Procedure for Developing the plot
                         7) Close graphic output files and write to disk.  
                         8) Delete temporary PNG file.
                         
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
 %let Program_  = stacked_bar_chart_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;
 %let Source_   = Any;
 
 title1 "Stacked Bar Chart";
 title2 "(Analysis Set)";
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

*-------------------------------------------------------------------------------------
 5) Generate the input dataset                                       (functional code)
 -------------------------------------------------------------------------------------;
data donors;
input period $ donation class $;
cards;
Q12007 10 Clear
Q12007 5  Large
Q12007 10 Medium
Q12007 15 Small
Q22007 10 Clear
Q22007 6 Large
Q22007 12 Medium
Q22007 15 Small
Q32007 33 Clear
Q32007 5 Large
Q32007 5 Medium
Q32007 6 Small
Q42007 29 Clear
Q42007 6 Large
Q42007 5 Medium
Q42007 3 Small
;
RUN;

*----------------------------------------------------------------------------------  
 5)  Set ODS graphics on and specify required ODS graphics parameters to create a
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
   
  ods listing 
      SGE           = on                    /* Create the SGE file type */ 
      style         = &Style_RTF            /* ODS style template */
      image_dpi     = 100 
   ; 

*---------------------------------------------------------------------------------  
 7) Use SG Procedure for Developing the plot                    (functional code)
 ---------------------------------------------------------------------------------;
proc sgplot data=donors;
  vbar period/response=donation group=class;
  xaxis label="Quarter";
  yaxis label="Donation by Each Class";
  footnote1 j=l 'Study Footnote';
  footnote2 j=l "Program: &Dir_./&Program_..sas";
  footnote3 j=l "Output: &Outfile_..rtf (Date Generated: &sysdate &systime) "
         " Source Data: &Source_.";
         
run;


 *---------------------------------------------------------------------------------  
 8) Close graphic output files and write to disk.                  (template code)
 ---------------------------------------------------------------------------------;
 ods rtf      close;                        * Output RTF file ;
 ods listing  close;                        * Output PNG and SGE files;
 ods graphics off;
 ods path     clear;

*---------------------------------------------------------------------------------  
 9) Delete temporary PNG file.                                     (template code)
 ---------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(myRef,&outfile_..png));
%let sysrc=%sysfunc(fdelete(&myRef)); 