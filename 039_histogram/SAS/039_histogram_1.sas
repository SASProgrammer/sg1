/*********************************************************************************

Program Name           : Histogram_1.sas

Path                   : sg1/039_Histogram/histogram.sas
                                  
Purpose                : To demonstrate the use of SG Components 1.0 with the following requirements:
                            1) Functional:
                                a) Emperical density function (Histogram)
                            2) Nonfunctional:
                                a) RTF and SGE file formats
                                b) Title outside graphic
                                c) Graph in CSR landscape format

Run Dependencies       : sg1 Style Template Library

Input Datasets/Views   : sashelp.cars

Macro calls external   : none

Output lists, etc.     : &Program..rtf  

Program Flow           : 1) Set SAS options and style template libname
                         2) Set global macro variable that make code easier to read.
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Set ODS graphics on and specify required ODS graphics parameters                         
                         6) Call SG graphic procedure
                         7) Close graphic output files and write to disk.  
                         8) Delete temporary PNG file.


Storage/Control Specs  :  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    05/14/26        dgianneschi     created program
*********************************************************************************************/

Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ 'sg1\000_style_templates' access=readonly;
  
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = histogram;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Style_SGE = SG_PPT; 
  
 title1 j=r h=1.0 'Avidity Biosciences, Inc.';
 title2 j=r h=1.0 'Study AV-US-xxx-xxx';
 title3 'Figure 14-1.1.2. Distribution of Weight';
 title4 '(Efficacy Analysis Set)';

*---------------------------------------------------------------------------------  
 3) Create GTL program                                           (functional code)
 ---------------------------------------------------------------------------------;
 proc template; 
  define statgraph inset; 
   dynamic VAR; 
   begingraph;     
    layout overlay / yaxisopts=(griddisplay=on); 
     histogram VAR / scale=percent; 
     layout gridded / columns=2 
         autoalign=(topleft topright) border=true 
         opaque=true backgroundcolor=GraphWalls:color; 
      entry halign=left "N"; 
      entry halign=left eval(strip(put(n(VAR),12.0))); 
      entry halign=left "Mean"; 
      entry halign=left eval(strip(put(mean(VAR),12.2))); 
      entry halign=left "Std Dev"; 
      entry halign=left eval(strip(put(stddev(VAR),12.2))); 
     endlayout; 
    endlayout; 
    entryfootnote halign=left 
               "_____________________________________________________________________"
               "____________________________________________________________________";
                       
    entryfootnote halign=left 
               "Study footnote."
               / pad=(top=5px) ;
 
    entryfootnote halign=left 
               "Data Extracted:  sashelp.cars  " 
               "Source: &Program_..sas   "
               "Output file: &Program_..rtf &sysdate &systime "
              / pad=(top=5px) ; 

   endgraph; 
  end; 
 run; 
 
*----------------------------------------------------------------------------------  
  4) Set ODS graphics on and specify required ODS graphics parameters to create a
     PDF output file for presentation purposes.            (template code) 
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
 5) Run the GTL program with proc sgrender. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 proc sgrender data= sashelp.cars template=inset; 
    dynamic VAR="Weight"; 
 run;

 ods pdf      close;                        * Output PDF file ;

*----------------------------------------------------------------------------------  
 6) Reset  ODS graphics options and set RTF file options.  RTF title is kept outside          
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
 7) Run the GTL program with proc sgrender. Close graphic output RTF
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 proc sgrender data= sashelp.cars template=inset; 
    dynamic VAR="Weight"; 
 run;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 8) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,SGRender.png));
 %let sysrc=%sysfunc(fdelete(&png));
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));