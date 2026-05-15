 
/********************************************************************************* 

Program Name           : vertical_bar_chart_panel_1.sas  

Path                   : sg1/045_vertical_bar_chart_panel

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

Program Flow           : 1) Set SAS options
                         2) Set macro variables that make code easier to read
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Generate the data
                         6) Create BarChart Macro for Processing.
                         7) Set the label for the percent from baseline variable for the legend.
                         8) Turn on ODS graphics
                         9) Create template
                        10) Create the Data Panel template for display of the Vertical Bar Charts.
                        11) Close ODS graphics
                        12) Delete temporary PNG file.   
                                                          

The original dataset is created and then used within a macro.

The original data is being manipulated in order to create a format of the data for the graph. This
   is accomplished in the macro BARCHARTX.  
1. Three variables are created for each treatment group to be displayed on the graph:
   a)pchgN (where N is a number that is related to a treatment group) - a variable
      which is assigned the value of the percent change from baseline for a treatment group.
   b)astN  (where N is a number that is related to a treatment group) - a variable
      which is assigned asterisks (*) to denote the significance related to the p-value
      for a treatment group.
   c)yvalN (where N is a number that is related to a treatment group) - a variable
      which is assigned a y-axis value which will allow the astN variable to display
      above (when the pchgN value is positive) or below (when the pchgN value is negative)
      the vertical bar.


Annotations are accomplished using different types of graphs within the prototype template.


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
 %let Program_  = vertical_bar_chart_panel_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Outfile_  = &Program_;
 %let Source_   = labs;
 %let n_pla     = 15;
 %let n_act     = 15;
 
 title1 "Multiple Panel Vertical Bar Chart with CI";
 title2 "(Analysis Set)";
 footnote1;
 
*-----------------------------------------------------------------------------------
 3) Simulate call SSUB call to /tools/init.inc                       (template code)
 -----------------------------------------------------------------------------------;
%let ADAM    = &Dir_;
%let PGMDIR  = &Dir_;
%let PROGRAM = &Program_;
%let RTF     = &Dir_/;

*------------------------------------------------------------------------------------
 4) Define title and set global variables.                            (template code)
 ------------------------------------------------------------------------------------;
%let Titles = title1 # title2;
%let outname=&Outfile_;

*-----------------------------------------------------------------------------------  
 5) Generate Data.                                                 (functional code)
 -----------------------------------------------------------------------------------;  
data work.labs;
label pchg     = "Percent change from baseline to month 12 (LS Means and CI)"
      trt      = "Treatment";
input lbtest $1-5 trt $ pchg lclm uclm pval;

datalines;
HDL-C  1  8.6   5.5    9.5   0.0001 
HDL-C  2  12.1  10.3   13.5  0.00001 
HCT    1  2.9   2.2    3.5   0.002         
HCT    2  8.6   5.6    9.6   0.0001  
LDL-C  1  -4.9  -10.0  -4.5  0.001    
LDL-C  2  -9.8  -18.1  -8.1  0.0005  
;
run;


*-----------------------------------------------------------------------------------
6) Create BarChart Macro for Processing                             (template code)
 -----------------------------------------------------------------------------------;
%macro Barchartx();

*-----------------------------------------------------------------------------------  
     Pre Process data for multiple treatment groups (functional code)
      Create a Percent Change variable pchgN where N is a number to designate a 
       specific treatment group.  This allows a style color to be added in the 
       template for each treatment group to allow color 
       changes for the bars.
 -----------------------------------------------------------------------------------;
* Create a macro variable to hold the number of different treatment groups; 
Proc SQL Noprint;
   Select count (distinct trt) 
           into :trt_cnt
      from work.labs;
Quit;

* Create a list of the different treatment groups;
Proc SQL Noprint;
   Select distinct(trt) into :trt1-:trt999
      from work.labs;
Quit;


* Sort the work dataset by the treatment group;
proc sort data=work.labs; 
   by trt;
run; 

* Create a Percent Change from Baseline value for each treatment group;
* This is used in the Graph Template to create the individual treatment bars;
data work.labs;
   set work.labs;
   * Set the variables to missing;
   %do c=1 %to %eval(&trt_cnt.);       
       ast&c. = '   ';
       yval&c. = .;
       pchg&c. = .;
   %end;

   * Set the variable values by treatment group;
   %do i=1 %to %eval(&trt_cnt.);

       * Detemine the value to add to the confidence limit for plotting the significance asterisk;
       if trt = "&&trt&i." then do;
          if pchg => 0 then do;
             lmt    = uclm;
             addval = .5;
       end;
       else do;
          lmt    = lclm;
          addval = -.5;
       end;

       * Set the change from baseline for the treatment group;
       pchg&i. = pchg;

       * Determine the level of signficance and set the y-axis display value;
       if pval = .00001 then do;
          yval&i. =  lmt + addval;
          ast&i.  = '***';
       end;
       else
          if pval = .0001 then do;
             yval&i. =  lmt + addval;
             ast&i.  = '** ';
          end;
          else
             if pval = .0005 then do;
                yval&i. =  lmt + addval;
                ast&i.  = '*  ';
             end;
    end;
%end;
output;

run;

%mend Barchartx;
%Barchartx();

*----------------------------------------------------------------------------------------  
 7) Set the label for the percent from baseline variable for the legend (functional code)
 ----------------------------------------------------------------------------------------;
data work.labs;
  * Set the label for the new percent from baseline variable for the legend;
  set work.labs;
  label pchg1= "Placebo (N=&n_pla)";
  label pchg2= "AVD001 (N=&n_act)";
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
   
 
*------------------------------------------------------------------------------------------  
9) Create the Data Panel template for display of the Vertical Bar Charts.   (template code)
 ------------------------------------------------------------------------------------------;  
proc template; 
 define statgraph layoutdatapanelci;   
  begingraph / backgroundcolor=white;     
    * Set footnotes;
    entryfootnote halign=left "Study Footnote";
    entryfootnote halign=left "Program: &dir_./&Program..sas"; 
    entryfootnote halign=left "Output: &Outfile_..rtf (Date Generated: &sysdate &systime)  Source Data: &Source_.";  
  
   layout datapanel classvars=(lbtest)/ 
          columns=3 rows=1
          columngutter=3
          rowaxisopts=(linearopts=(tickvaluesequence=(start=-20 end=20 increment=5)) 
                       label="Percent change from baseline to month 12 (LS Means and CI)")
          columnaxisopts=(linearopts=(tickvaluesequence=(start=-20 end=20 increment=5)) display=none)                  
          headerlabeldisplay=value; 
 
   layout prototype / cycleattrs=true;
     * Create a reference line at 0 for the y axis;
     referenceline y=0;

     * Create a vertical bar chart with CI for the first treatment group-Placebo;
     barchartparm x=trt y=pchg1  / errorupper=uclm errorlower=lclm  name="a1";  

     * Create a vertical bar chart  with CI for the second treatment group-GLD001;
     barchartparm x=trt y=pchg2  / errorupper=uclm errorlower=lclm  name="a2";   
    
     * Create a scatter plot to display the asterisks above or below the bar for the first treatment group-Placebo;
     scatterplot x=trt y=yval1 / markercharacter=ast1 markercharacterattrs=(color=black weight=bold);

     * Create a scatter plot to display the asterisks above or below the bar for the first treatment group-Placebo;
     scatterplot x=trt y=yval2 / markercharacter=ast2 markercharacterattrs=(color=black weight=bold);
     
   endlayout;
   
   * Display the legend for the bar charts a1-the first treatment group, and a2 - the second treatment group;
      sidebar / align=right ;
        discretelegend  "a1"  "a2" / border=false across=1 ;
      endsidebar;

   
   endlayout;
   
  endgraph; 
 end; 
run; 

**-----------------------------------------------------------------------------------
 10) Run Proc Sgrender to display graph  (template code)
 -----------------------------------------------------------------------------------;

proc sgrender data=labs template=layoutdatapanelci;
run;

*---------------------------------------------------------------------------------  
 11) Close graphic output files and write to disk.                  (template code)
 ---------------------------------------------------------------------------------;
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;
 ods path     clear;

*---------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                     (template code)
 ---------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(myRef,&outfile_..png));
%let sysrc=%sysfunc(fdelete(&myRef)); 