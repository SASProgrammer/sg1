/*********************************************************************************

Program Name           : waterfall_1.sas

Path                   : sg1/042_waterfall
                                  
Purpose                : To demonstrate the use of SAS 9.4 to generate quick plots:
                          1) Output Requirements:
                             a) Increase and Decrease in change from baseline to show in waterfall plot
                          
Input Datasets/Views   : waterfall

Macro calls external   : none

Outputs                : &Program..rtf  

Program Flow           : 1) Set SAS options and style template libname
                         2) Set global macro variable that make code easier to read.
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Prepare the data for reporting 
                         6) Set ODS graphics on and specify required ODS graphics parameters                         
                         7) Use SG Procedure for Developing the plot
                         8) Close graphic output files and write to disk.  
                         9) Delete temporary PNG file.
                         
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
 
  ods listing;
 
*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = waterfall_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;
 %let Source_   = waterfall;
 
 title1 'Figure 14-1.1.2. Change from Baseline';
 title2 '(Waterfall Plot)';
 footnote1;
 
*-----------------------------------------------------------------------------------
 3) Simulate call SSUB call to /tools/init.inc                       (template code)
 -----------------------------------------------------------------------------------;
%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*-------------------------------------------------------------------------------------
 4)  Define title and set global variables.                           (template code)
 -------------------------------------------------------------------------------------;
%let Titles = title1 # title2;
%let outname=&Outfile_;
%let n_pop  =10;

*--------------------------------------------------------------------------------------
 5) Prepare the data for reporting.                                   (functional code)
---------------------------------------------------------------------------------------;
 data waterfall;
   input subject  $1-6 chg_base 10-15 trt 19-21;
   datalines;
  0001    5         1
  0002    -10       1
  0003    -12       1
  0004    -6        1
  0005    13        1
  0006    -30       1
  0007    -1        1
  0008    0         1
  0009    30        1
  0010    -34       1
   ;
 run;
 

/* Make sure to sort the data with descending chg_base */
 proc sort data=waterfall;
   by descending chg_base subject;
 run;
 
*----------------------------------------------------------------------------------  
 6)  Set ODS graphics on and specify required ODS graphics parameters to create a
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
   
*---------------------------------------------------------------------------------  
 7) Use SG Procedure for Developing the plot                    (functional code)
 ---------------------------------------------------------------------------------;
proc sgplot data=waterfall;
  needle x=subject y=chg_base/lineattrs=(color=blue thickness=10) ;
  xaxis display=(novalues noticks) label="Subject N=&n_pop.";
  yaxis label="Percent Change from Baseline" values=(50 40 30 20 10 0 -10 -20 -30 -40 -50);
  footnote1 j=l 'User supplied footnote.';
  footnote2 j=l "Program: &Dir_.\&Program_..sas";
  footnote3 j=l "Output: &Outfile_..rtf (Date Generated: &sysdate &systime) "
         " Source Data: &Source_.";
run;

 *---------------------------------------------------------------------------------  
 8) Close graphic output files and write to disk.                  (template code)
 ---------------------------------------------------------------------------------;
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;
 ods path     clear;

*---------------------------------------------------------------------------------  
 9) Delete temporary PNG file.                                     (template code)
 ---------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(myRef,&outfile_..png));
%let sysrc=%sysfunc(fdelete(&myRef)); 