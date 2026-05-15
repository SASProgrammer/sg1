/************************************************************************************* 

Program Name           : scatter_plot_QTCB_1.sas

Path                   : sg1\048_scatter_plot_QTCB

Purpose                : To demonstrate the use of Graph Template Datapanel in the following situation:
                            1) Output Requirements: 
                                a) Create a panel of scatter plots with a 30 and 60 degree reference lines
                            2) Environmental Factors:
                                   a) Simulating execution of a "init.sas" to set some global macro variables.
                                   b) Simulating use of the PI Manager.  Not using regular SAS 
                                      titles and footnotes.
                                                    
Input Datasets/Views   : Program generated

Macro calls external   : none

Output lists, etc.     : &Program..rtf  

Program Flow : 1) Set required SAS options and set macro search path.
               2) Set global macro variables that make code easier to read.
               3) Simulate call SSUB call to /tools/init.inc 
               4) Define title and set global variables.  
               5) Create the Formats  
               6) Generate data
               7) Set ODS graphics on and specify required ODS graphics parameters such as: 
                 a) RTF file name
                 b) ODS graphics style template                            
               8) Create the Data Panel and style template for display of the scatter plots.
               9) Call Proc SGRender to display the panel of Plots using the Data Panel template.
              10) Close graphic output files and write to disk.
              11) Delete temporary PNG file.

Storage/Control Specs  :  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    05/14/26        dgianneschi     Create.
*********************************************************************************************/

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
 %let Program_  = scatter_plot_qtcb;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;

*-----------------------------------------------------------------------------------
 3)  Simulate call SSUB call to /tools/init.inc                      (template code)
 -----------------------------------------------------------------------------------;

%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*-------------------------------------------------------------------------------------
 4) Define title and set global variables.                             (template code)
 -------------------------------------------------------------------------------------;
title1 " Figure 14.1.1. Post Dose QTcB vs. Baseline QTcB by Timepoint " ;
title2 " (Protocol 99999999) " ;
%let Titles = title1 # title2 ;
%let outname=&Outfile_;
%let source_=labs;

%let n_pla  = 59;
%let n_act1 = 54;
%let n_act2 = 57;
%let n_act3 = 60;

*-----------------------------------------------------------------------------------  
 5) Create the Formats   (functional code)
-----------------------------------------------------------------------------------;  
proc format;
 value $trt (NOTSORTED)
  '0'="Placebo (N=&n_pla.)"
  '1'="AVD001 25mg (N=&n_act1.)"
  '2'="AVD001 50mg (N=&n_act2.)"
  '3'="AVD001 100mg (N=&n_act3.)"
  ;
 run;

*-----------------------------------------------------------------------------------  
 6) Generate Data.    (functional code)
-----------------------------------------------------------------------------------;  
 data work.labs;
   label baseline ="Baseline Result";
   label value ="Result Value";
   input subject_id lbtest $ baseline value trt $ reading $15. l $3. b $4. s $4. a $4. sixtyx sixtyy thirtyx thirtyy 
      nthirtyx nthirtyy nsixtyx nsixtyy trt1 $;
   format trt $trt.;

datalines;
101 QTcB 320 350 0 Day  3         +60 +30 -30 -60 500 540 540 540 550 510 555 465 0
101 QTcB 380 385 0 Day  4         +60 +30 -30 -60 500 540 540 540 550 510 555 465 0
101 QTcB 390 375 0 Day  8 Predose +60 +30 -30 -60 500 540 540 540 550 510 555 465 0
101 QTcB 390 380 0 Day 15 Predose +60 +30 -30 -60 500 540 540 540 550 510 555 465 0
301 QTcB 375 350 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
301 QTcB 385 385 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
301 QTcB 395 375 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
301 QTcB 395 380 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
102 QTcB 350 390 0 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
102 QTcB 360 395 0 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
102 QTcB 340 385 0 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
102 QTcB 340 350 0 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
302 QTcB 355 390 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
302 QTcB 345 355 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
302 QTcB 400 395 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
302 QTcB 405 380 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
103 QTcB 325 365 0 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
103 QTcB 330 335 0 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
103 QTcB 330 345 0 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
103 QTcB 340 350 0 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
303 QTcB 335 355 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
303 QTcB 365 365 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
303 QTcB 390 370 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
303 QTcB 405 410 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
104 QTcB 325 400 0 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
104 QTcB 330 355 0 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
104 QTcB 345 395 0 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
104 QTcB 330 360 0 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
304 QTcB 355 350 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
304 QTcB 335 345 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
304 QTcB 380 375 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
304 QTcB 415 390 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
105 QTcB 420 450 0 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
105 QTcB 480 485 0 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
105 QTcB 390 475 0 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
105 QTcB 360 480 0 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
305 QTcB 475 450 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
305 QTcB 485 415 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
305 QTcB 395 475 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
305 QTcB 425 430 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
106 QTcB 410 400 0 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
106 QTcB 460 495 0 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
106 QTcB 440 485 0 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
106 QTcB 440 450 0 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 0
306 QTcB 455 490 1 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
306 QTcB 445 455 1 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
306 QTcB 415 410 1 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
306 QTcB 510 480 1 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 1
401 QTcB 420 450 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
401 QTcB 370 375 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
401 QTcB 340 325 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
401 QTcB 395 350 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
501 QTcB 475 450 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
501 QTcB 515 515 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3 
501 QTcB 505 525 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
501 QTcB 495 480 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
402 QTcB 320 360 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
402 QTcB 335 365 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
402 QTcB 325 390 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
402 QTcB 335 365 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
502 QTcB 345 395 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
502 QTcB 365 375 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
502 QTcB 410 525 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
502 QTcB 435 390 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
403 QTcB 315 375 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
403 QTcB 310 355 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
403 QTcB 320 335 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
403 QTcB 350 340 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
503 QTcB 375 395 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
503 QTcB 425 415 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
503 QTcB 400 395 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
503 QTcB 415 470 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
404 QTcB 520 535 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
404 QTcB 370 325 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
404 QTcB 365 370 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
404 QTcB 345 390 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
504 QTcB 335 345 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
504 QTcB 345 350 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
504 QTcB 420 425 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
504 QTcB 475 490 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
405 QTcB 500 550 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
405 QTcB 510 485 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
405 QTcB 356 425 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
405 QTcB 390 450 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
505 QTcB 445 455 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
505 QTcB 455 435 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
505 QTcB 390 515 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
505 QTcB 455 435 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3 
406 QTcB 510 500 2 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
406 QTcB 430 485 2 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
406 QTcB 460 495 2 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
406 QTcB 490 480 2 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 2
506 QTcB 555 450 3 Day  3         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
506 QTcB 465 470 3 Day  4         +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
506 QTcB 485 550 3 Day  8 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
506 QTcB 525 580 3 Day 15 Predose +60 +30 -30 -60  .    .  .    .  .    .  .    . 3
;

run;

* Sort the data for the Panel generation.; 
proc sort data=work.labs(drop=trt1);
   by reading;
run;

*----------------------------------------------------------------------------------  
 7)  Set ODS graphics on and specify required ODS graphics parameters to create a
     RTF file for the CSR.
 
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
  
*-----------------------------------------------------------------------------------  
 8) Create the Data Panel style template with Graph Template language
    for display of the scatter plots. 
    Note that the Graph template will require some changes for the new graph.
    The entrytitle and variable names for the scatterplots will need to reflect 
    the graph title and the variable names from the input dataset. (Template Code)
 -----------------------------------------------------------------------------------;  
proc template; 
 define statgraph layoutdatapanel;  
 
  begingraph; 
   entryfootnote halign=left " ";
   entryfootnote halign=left "Study Footnote";
   entryfootnote halign=left "Program: &dir_./&Program..sas"; 
   entryfootnote halign=left "Output: &Outfile_..rtf (Date Generated: &sysdate &systime)  Source Data: &Source_.";  

   layout datapanel classvars=(reading)/ columns=2 rows=1 
     columngutter=5 rowgutter=5     
     rowaxisopts=(type=linear
                  label="Post-Dose QTcB-Interval (msec)" 
                  linearopts=(viewmin=300 viewmax= 550 thresholdmin=1 thresholdmax=1 tickvaluelist=(300 350 400 450 500 550)))
     columnaxisopts=(type=linear label="Baseline QTcB-Interval (msec)" 
                     linearopts=(viewmin=300 viewmax= 550 thresholdmin=1 thresholdmax=1 tickvaluelist=(300 350 400 450 500 550)))
     headerlabeldisplay=value;
 
   layout prototype / cycleattrs=true;
     scatterplot y = baseline x = value / group=trt name="sp" ; 
     scatterplot y = sixtyy   x = sixtyx /  markercharacter=l ; 
     scatterplot y = thirtyy  x = thirtyx /  markercharacter=b ; 
     scatterplot y = nthirtyy  x = nthirtyx /  markercharacter=s ; 
     scatterplot y = nsixtyy  x = nsixtyx /  markercharacter=a ;

     referenceline x=450 /lineattrs=(thickness=0.5) datatransparency=0.8;
     referenceline x=500 /lineattrs=(thickness=0.5) datatransparency=0.8; 

     lineparm x=320 y=250 slope=.90 / lineattrs=(pattern=solid color=black) datatransparency=0.8;
     lineparm x=310 y=275 slope=.90 / lineattrs=(pattern=solid color=black) datatransparency=0.8;
     lineparm x=300 y=300 slope=.90 / lineattrs=(pattern=solid color=black) datatransparency=0.8;
     lineparm x=290 y=325 slope=.90 / lineattrs=(pattern=solid color=black) datatransparency=0.8;
     lineparm x=280 y=355 slope=.90 / lineattrs=(pattern=solid color=black) datatransparency=0.8;
     
   endlayout;
   
   sidebar /align=bottom;
     discretelegend "sp"/title="Treatment Group:  " autoalign=(bottomleft) border=true;
   endsidebar;
 
   endlayout;

 endgraph; 
 end; 
run; 


*-----------------------------------------------------------------------------------  
 9) Call Proc SGRender to display the panel of Plots using the Data Panel template.
-----------------------------------------------------------------------------------;  
proc sgrender data = work.labs template = layoutdatapanel; 
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
