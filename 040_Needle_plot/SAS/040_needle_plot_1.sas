/*********************************************************************************

Program Name           : needle_plot_1.sas

Path                   : sg1/040_needle_plot/needle_plot.sas
                                  
Purpose                : To demonstrate the use of SAS 9.2 to generate quick plots:
                          1) Output Requirements:
                             a) Percent Change by Subject, needle plot
                          2) Environmental Factors:
                             a) N/A

Input Datasets/Views   : sashelp.class

Macro calls external   : none

Outputs                : &Program..rtf  

Program Flow           : 1) Set SAS options and style template libname
                         2) Set global macro variable that make code easier to read.
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Build formats to help in data generation
                         6) Prepare the data for reporting 
                         7) Set ODS graphics on and specify required ODS graphics parameters                         
                         8) Develop Graphic template for plot
                         9) Close graphic output files and write to disk.  
                        10) Delete temporary PNG file.
                         
Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ------------------------------------
001     1.00    05/14/26        dgianneschi     Create.

************************************************************************************/

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
 %let Program_  = needle_plot;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Style_SGE = SG_PPT;
 %let Source_   = sashelp.class;
 
*-------------------------------------------------------------------------------------
 2) Set titlesde easier to read.                                       (template code)
 -------------------------------------------------------------------------------------; 
 title1 j=r h=1.0 'Avidity Biosciences, Inc.';
 title2 j=r h=1.0 'Study AV-US-xxx-xxx';
 title3 "Figure 6.5 Plot of Best Percent Change in Weight, All Subjects";
 title4 "(Full Analysis Set)";

*-----------------------------------------------------------------------------------
 5) Build formats to help in data generation                        (functional code)
 -----------------------------------------------------------------------------------;
 proc format;
   value groupf
     1 = "< 25% Reduction"
     2 = ">= 25% Reduction";
 run;

*--------------------------------------------------------------------------------------
 6) Prepare the data for reporting.                                   (functional code)
---------------------------------------------------------------------------------------;
 data class;
   format group groupf.;
   set sashelp.class;

   * generate weight and baseline weight data *;
   newweight = (weight + (ranuni(234) * (ranuni(123) * 54)));
   baseweight = weight;

   inord=_n_;

   * choose some subjects to arbitrarily go the other direction *;
   if _n_ in (2,9,5,12,17) then do;
      baseweight = weight * 1.2;
      weight = weight * 1.4;
   end;

   weight = newweight;

   * some arbitrary weight reduction calcs *;
   reduct    = ((baseweight - weight) / weight);
   weightred = baseweight - weight;

   * grouping by reduction percentage *;
   if reduct le -0.25 then group = 2;
                      else group = 1;
run;

* need to sort by weight reduction to present *;
* best to the right                           *;
proc sort data=class;
   by descending weightred;
run;

data class;
   set class;
   ord = _n_;
run;

*---------------------------------------------------------------------------------  
 7) Develop Graphic template for plot                            (functional code)
 ---------------------------------------------------------------------------------;
proc template;
   define statgraph needleplot;
      begingraph;

         layout overlay /
            xaxisopts=(type=discrete
                       label="Subjects N=19"
                       display=(label line))
            yaxisopts=(label="Percent Change" griddisplay=on
                       gridattrs=(color=gray pattern=solid thickness=1)
                       linearopts=(tickvaluelist=(-100 -80 -60 -40 -20 0 20 40)
                       viewmax=40 viewmin=-100));
            needleplot x=ord y=weightred / group=group
                       baselineintercept=0
                       lineattrs=(pattern=solid thickness=32) name="a";
            discretelegend "a" / across=1 location=inside
                       halign=right valign=top border=0 pad=2;
         endlayout;
         
         entryfootnote halign=left 
                        "_____________________________________________________________________"
                        "____________________________________________________________________";
                                
         entryfootnote halign=left 
                        "Study footnote."
                        / pad=(top=5px) ;
          
         entryfootnote halign=left 
                     "Data Extracted:  &source_  " 
                        "Source: &Program_..sas   "
                        "Output file: &Program_..rtf &sysdate &systime "
                       / pad=(top=5px) ; 

         
      endgraph;
   end;
run;

*----------------------------------------------------------------------------------  
  4) Set ODS graphics on and specify required ODS graphics parameters to create a
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
 8) Run the GTL program with proc sgrender. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 proc sgrender data=class template=needleplot;
 run;

 ods pdf      close;                        * Output PDF file ;

*----------------------------------------------------------------------------------  
 9) Reset  ODS graphics options and set RTF file options.  RTF title is kept outside          
    the graph to allow editing in WORD.                             (template code)
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
 10) Run the GTL program with proc sgrender. Close graphic output RTF
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 proc sgrender data=class template=needleplot;
 run;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 11) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,SGRender.png));
 %let sysrc=%sysfunc(fdelete(&png));
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));