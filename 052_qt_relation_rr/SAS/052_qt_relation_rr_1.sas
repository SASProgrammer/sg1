/************************************************************************************* 

Program Name           : qt_relation_rr_1.sas

Path                   : sg1/052_qt_relation_rr

Purpose                : To generate scatter plot of Relationship of QT interval by RR Interval:
                            1) Environmental Factors:
                                   a) Simulating execution of a "init.sas" to set some global macro variables.
                                   b) Simulating use of the PI Manager.  Not using regular SAS 
                                      titles and footnotes.
                                                    
Macro calls external   : none

Output lists, etc.     : &Program..rtf  

Program Flow : 1) Set SAS options and style template libname.
               2) Set global macro variable that make code easier to read.
               3) Set "init.sas" macro variables, simulate execution of "init.sas" 
               4) Set "PI Manager" macro variables, simulate a call to "PI Manager"
               5) Generate data
               6) Set ODS graphics on and specify required ODS graphics parameters such as: 
                 a) RTF file name
                 b) ODS graphics style template. 
               7) Generate template to develop the plot.
               8) Close graphic output files and write to disk.
               9) Delete temporary PNG file.

Storage/Control Specs  :  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    5/14/26         dgianneschi     Create.
*********************************************************************************************/

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
 %let Program_  = qt_relation_rr_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;
 %let Style_SGE = SG_PPT;

 *-----------------------------------------------------------------------------------
 3) Set "init.sas" global variables, simulate execution of "init.sas" (template code)
 -----------------------------------------------------------------------------------;

%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*-------------------------------------------------------------------------------------
 4) Define title and set global variables.                             (template code)
 -------------------------------------------------------------------------------------;
title1 " Figure NNN: QT Interval Relationships to RR" ;
title2 " (Protocol 99999999) " ;
%let Titles = title1 # title2 ;
%let outname=&Outfile_;
%let source_=Any;

*-----------------------------------------------------------------------------------  
 5) Generate Data.    (functional code)
-----------------------------------------------------------------------------------;  
 data work.labs;
   attrib subject_id label ="Subject Id"
      rr         label ="RR Interval (msec)"
		qt         label ="QT Interval (msec)"
		qtcf       label ="QTcF Interval (msec)"
		qtcb       label ="QTcB Interval (msec)"
		trt        label ="Treatment"
		  ;
   input subject_id rr qt qtcf qtcb trt $;

datalines;
101 450  400 430 419 AVD001
102 550  430 420 423 AVD001
103 650  410 390 338 AVD001
104 750  500 380 345 AVD001
105 850  440 448 451 AVD001
106 950  457 460 562 AVD001
107 1050 390 400 378 AVD001
108 1150 412 450 486 AVD001
109 1250 370 389 450 AVD001
110 1350 390 430 439 AVD001
;
run;

* Sort the data for the Panel generation.; 
proc sort data=work.labs;
   by trt subject_id;
run;

*----------------------------------------------------------------------------------  
 6) Set ODS graphics on and specify required ODS graphics parameters to create a
    RTF file for the CSR and SGE file nonCSR purposes such publications.
    Landscape available HEIGHT and WIDTH is 6.00 and 9.25 inches.   (template code)
  -----------------------------------------------------------------------------------;

  ods graphics on / reset=all height=5.00in width=9.00in imagemap=on border=off 
                    imagename="&outfile_" ;  

  ods noproctitle
      escapechar='~'
   ; 
      
  ods rtf 
      nogtitle                              /* Put title in RTF text outside of graph */      
      bodytitle  
      notoc_data 
      file          = "&outfile_..rtf"      
      style         = &Style_RTF             
      headery       = 1080                  /* 0.75in space shared with top margin */
      footery       = 360                   /* 0.25in space shared with bottom margin */
      image_dpi     = 300
   ;
  
*-----------------------------------------------------------------------------------  
 7) Generate template to develop the plot.
-----------------------------------------------------------------------------------;  
proc template;
  define statgraph begingraph;
    begingraph ;
    entryfootnote halign=left "Study Footnote";
    entryfootnote halign=left "Program: &dir_./&Program..sas"; 
    entryfootnote halign=left "Output: &Outfile_..rtf (Date Generated: &sysdate &systime)  Source Data: &Source_.";  
    layout lattice / columns=2 rows=2 rowgutter=10px columngutter=10px;
      layout overlay / yaxisopts=(griddisplay=on label="QT Interval (msec)" 
                                  linearopts=(viewmax=600 viewmin=250))
                       xaxisopts=(griddisplay=on label="RR Interval (msec)" 
                                 linearopts=(viewmax=1600 viewmin=300));
	    entry "QT by RR Interval No Correction" /valign=top textattrs=(weight=bold);
        scatterplot x=rr y=qt /group=subject_id;
		referenceline y=400/DATATRANSPARENCY=0.5 curvelabel="Average";
      endlayout;
	  
      layout overlay / yaxisopts=(griddisplay=on label="QTcF Interval (msec)" 
                                 linearopts=(viewmax=600 viewmin=250))
                       xaxisopts=(griddisplay=on label="RR Interval (msec)"  
                                  linearopts=(viewmax=1600 viewmin=300));
	    entry "QTcF by RR Interval" /valign=top textattrs=(weight=bold);
        scatterplot x=rr y=qtcf /group=subject_id;
		referenceline y=400/DATATRANSPARENCY=0.5 curvelabel="Average";
      endlayout;



      layout overlay / yaxisopts=(griddisplay=on label="QTcB Interval (msec)" 
                                  linearopts=(viewmax=600 viewmin=250))
                       xaxisopts=(griddisplay=on label="RR Interval (msec)" 
                                 linearopts=(viewmax=1600 viewmin=300));
	    entry "QTcB by RR Interval" /valign=top textattrs=(weight=bold);
        scatterplot x=rr y=qtcb /group=subject_id;
		referenceline y=400/DATATRANSPARENCY=0.5 curvelabel="Average";
      endlayout;


      layout gridded /border=false opaque=true;
	       entry halign=center "QT Interval Relationship to RR"/valign=bottom ;
		   entry halign=center "Note: To be used for"/valign=bottom ;
           entry halign=center "diagnostic purposes only"/valign=bottom ;
		   entry halign=center "(e.g. not for publication)"/valign=bottom ;
      endlayout;
 
    endlayout;
    endgraph;
  end;
run;

proc sgrender data=labs template=begingraph;
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