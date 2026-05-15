/************************************************************************************* 

Program Name           : chg_qtcb_vs_serum.sas (for Std. Macros) 

Path                   : eHandbook/c02_Sample_Macros/Common_TLG/figures/050_chg_qtcb_vs_serum

Purpose                : To generate scatter plot of change from baseline qtcb at different concentration level:
                            1) Environmental Factors:
                                   a) Simulating execution of a "init.sas" to set some global macro variables.
                                   b) Simulating use of the PI Manager.  Not using regular SAS 
                                      titles and footnotes.
                                                    
Macro calls external   : none

Output lists, etc.     : &Program..rtf  
                         &Program..sge

Program Flow : 1) Set required SAS options and set macro search path.
               2) Set global macro variables that make code easier to read.
               3) Simulate call SSUB call to /tools/init.inc 
               4) Define title and set global variables.  
               5) Create the Formats  
               6) Generate data
               7) Set ODS graphics on and specify required ODS graphics parameters such as: 
                 a) RTF file name
                 b) ODS graphics style template. 
               8) Call Proc SGPLOT to display the panel of Plots.
               9) Close graphic output files and write to disk.
              10) Delete temporary PNG file.

Storage/Control Specs  :  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    19Mar2013       dgianneschi     Create.
*********************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ '/u/biostat/t3.02.02/ods_v92/linux' access=readonly;
 
 *libname ods_ '\\biomdata\vol\u\biostat\t3.02.02\ods_v92\windows' access=readonly;
 
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

 ods listing;

*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 
 %let Dir_      = %sysfunc(pathname(Dir_));
 %let Program_  = chg_qtcb_vs_serum;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;

*-----------------------------------------------------------------------------------
 3) Simulate call SSUB call to /tools/init.inc                       (template code)
 -----------------------------------------------------------------------------------;

%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*-------------------------------------------------------------------------------------
 4)  Define title and set global variables.                            (template code)
 -------------------------------------------------------------------------------------;
title1 " Figure 14.1.1. Change from Baseline QTcB  by GLDXXX Serum Concentration" ;
title2 " (Protocol 99999999) " ;
%let Titles = title1 # title2 ;
%let outname=&Outfile_;
%let source_=labs;

%let n_pla  = 59;
%let n_act1 = 54;
%let n_act2 = 57;

*-----------------------------------------------------------------------------------  
 5) Create the Formats   (functional code)
-----------------------------------------------------------------------------------;  
proc format;
 value $trt (NOTSORTED)
  '0'="Placebo (N=&n_pla.)"
  '1'="GLD001 25mg (N=&n_act1.)"
  '2'="GLD001 50mg (N=&n_act2.)"
  ;
 run;

*-----------------------------------------------------------------------------------  
 6) Generate Data.    (functional code)
-----------------------------------------------------------------------------------;  
 data work.labs;
   label baseline ="Baseline Result";
   label value ="Result Value";
   input subject_id lbtest $ baseline value concentration trt $;
   format trt $trt.;

datalines;
101 QTcB 320 350 0.1 0 
101 QTcB 320 340 100 0 
101 QTcB 320 370 1000 0 
101 QTcB 320 380 10000 0 
101 QTcB 320 323 10200 0 
102 QTcB 420 450 3 0 
102 QTcB 420 440 130 0 
102 QTcB 420 470 1040 0 
102 QTcB 420 480 10300 0 
102 QTcB 420 423 11100 0 
103 QTcB 520 550 0.2 0 
103 QTcB 520 540 230 0 
103 QTcB 520 570 2040 0 
103 QTcB 520 580 20300 0 
103 QTcB 520 523 21100 0 
201 QTcB 310 350 1.7 1 
201 QTcB 310 340 170 1 
201 QTcB 310 370 1700 1 
201 QTcB 310 380 17000 1 
201 QTcB 310 322 17200 1 
202 QTcB 410 459 0.1 1 
202 QTcB 410 443 170 1 
202 QTcB 410 476 1740 1 
202 QTcB 410 489 17300 1 
202 QTcB 410 428 17100 1  
203 QTcB 510 595 0.2 1 
203 QTcB 510 519 280 1 
203 QTcB 510 544 2940 1 
203 QTcB 510 500 22300 1 
203 QTcB 510 511 20100 1 
301 QTcB 330 366 0.9 2 
301 QTcB 330 322 122 2 
301 QTcB 330 377 1900 2 
301 QTcB 330 333 10920 2 
301 QTcB 330 399 11200 2 
302 QTcB 430 422 0.5 2 
302 QTcB 430 488 230 2 
302 QTcB 430 445 5040 2 
302 QTcB 430 422 13300 2 
302 QTcB 430 413 12100 2 
303 QTcB 530 590 0.4 2 
303 QTcB 530 530 430 2 
303 QTcB 530 560 4040 2 
303 QTcB 530 590 12300 2 
303 QTcB 530 583 17100 2 
;
run;

data labs;
   attrib chg_base label="Change from Baseline QTcB (msec)";
   set labs;
    chg_base=value-baseline;
run;    

* Sort the data for the Panel generation.; 
proc sort data=work.labs;
   by trt subject_id;
run;

*----------------------------------------------------------------------------------  
 7)  Set ODS graphics on and specify required ODS graphics parameters to create a
     RTF file for the CSR and SGE file nonCSR purposes such publications.
 
     HEIGHT = 5.00in  
        For the CSR standard landscape layout, there are 6.00 inches available for the graph 
        HEIGHT setting, accounting for 1.50in top margin and 1.00in bottom margin.
        Running heading (HEADERY) and footings (FOOTERY) share space with these 
        margins, but must be specified as shown below to create a valid RTF file.  

        The HEIGHT setting is a function of the number titles because of the NOGTITLE, 
        which puts the title outside of the graphic.  The goal is to set HEIGHT to a
        value which fills the page without flowing over into the next page or creating
        a blank trailing page.  Use 0.50in for each title line, so for this graph
        set HEIGHT = 5.00in (6.00in - 1.00in) accounting for the two title lines (2 * 0.50).

     WIDTH is not specified to maintain the standard TV (4/3) aspect ratio.  Set WIDTH
     to 9.25in if you want the graph to fill the available width, Given US Letter paper
     with 8.5inch width with 0.75in and 1.00in left margin and right margins. 
                                                                      (template code)
  -----------------------------------------------------------------------------------;

  ods graphics on / reset=all height=5.00in width=9.25in imagemap=on border=off 
                    imagename="&outfile_" ; /* For PNG and SGE file type */

  * Noproctitle suppresses the writing of the title of the procedure that produces the results *;
  ods noproctitle;
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

*-----------------------------------------------------------------------------------  
 8) Call Proc SGRender to display the panel of Plots using the Data Panel template.
-----------------------------------------------------------------------------------;  

proc sgplot data=labs cycleattrs;
  refline 0 30 /transparency=0.8	;
  scatter y=chg_base x=concentration/group=trt ;
  xaxis type=log minor label="GLDXXX Concentration (ng/mL)";
  yaxis label="QTcB Change from Baseline (msec)" values=(120 to -120 by -30);
  keylegend / title="" location=inside noborder position=bottomleft;
  footnote1 j=left "Study Footnote";
  footnote2 j=left "Program: &dir_./&Program..sas"; 
  footnote3 j=left "Output: &Outfile_..rtf (Date Generated: &sysdate &systime)  Source Data: &Source_.";  

run;


 *---------------------------------------------------------------------------------  
 9) Close graphic output files and write to disk.                  (template code)
 ---------------------------------------------------------------------------------;
 ods rtf      close;                        * Output RTF file ;
 ods listing  close;                        * Output PNG and SGE files;
 ods graphics off;
 ods path     clear;

*---------------------------------------------------------------------------------  
 10) Delete temporary PNG file.                                     (template code)
 ---------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(myRef,&outfile_..png));
%let sysrc=%sysfunc(fdelete(&myRef)); 
