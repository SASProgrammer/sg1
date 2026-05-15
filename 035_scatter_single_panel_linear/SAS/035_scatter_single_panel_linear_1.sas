/************************************************************************************* 

Program Name           : scatter_single_panel_linear_1.sas 

Path                   : sg1/035_scatter_single_panel_linear

Purpose                : To demonstrate creation of a scatter single panel linear
                                                    
Input Datasets/Views   : sashelp.iris

Macro calls external   : none

Production Outputs     : &Program..rtf  
                         &Program..pdf

Qualification Outputs  : none

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Create macro to call SGSCATTER  
                          5) Set ODS graphics options for PDF and SGE.
                          6) Run the macro. Close graphic
                             output PDF and write to disk.
                          7) Reset  ODS graphics options and set RTF file options. 
                             RTF title is kept outside the graph to allow editing 
                             in WORD. 
                          8) Run the macro. Close graphic 
                             output RTF file and write to disk.
                          9) Delete temporary PNG file. 

User Documentation      : Please see sg1 User Guide

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    05/14/26        dgianneschi     created program
*********************************************************************************************/

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
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = scatter_single_panel_linear_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Style_SGE = SG_PPT; 
 
 *-----------------------------------------------------------------------------------  
  3) Set titles and footnotes, adjust for RTF and PDF width.(template/functional code)
  -----------------------------------------------------------------------------------*;
   %macro titles(pdf=Y);
      title1 j=r h=1.0 'Avidity Biosciences, Inc.';
      title2 j=r h=1.0 'Study AV-US-xxx-xxx';
      title3 "Example Graph";
      title4 "Single-Panel With Linear Regression";
      %if %upcase(&pdf)=Y %then %do; 
          footnote1 j=l "_________________________________________________________________"
                        "_________________________________________________________________";
       %end;
       %else %do; 
          footnote1 j=l "_________________________________________________________________"
                        "______________________________________________________________________";
       %end;
  
      footnote2 j=l "Study Footnote.";
      footnote3 j=l "Data Extracted: program_generated   " 
                     "Source: &Program_..sas   "
                     "Output file: &Program_..rtf &sysdate &systime ";
 %mend titles;
                  
*---------------------------------------------------------------------------------  
  4) Define macro to call SG graphic procedures                  (functional code)
 ---------------------------------------------------------------------------------;
 %macro loop;
   proc sgscatter data=sashelp.iris;  
      plot (sepallength) * (petallength) / reg spacing=5 group=species;
   run;          
 %mend loop;
             
  *----------------------------------------------------------------------------------  
  5) Set ODS graphics on and specify required ODS graphics parameters to create a
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
  6) Run the SG code with the macro. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
  ----------------------------------------------------------------------------------;
  %titles(PDF=Y);
  %loop;
  
  ods pdf      close;                        * Output PDF file ;
 
  *----------------------------------------------------------------------------------  
   7) Reset  ODS graphics options and set RTF file options.           (template code)
       RTF title is kept outside the graph to allow editing in WORD.
   -----------------------------------------------------------------------------------;
   ods graphics on / reset=all height=4.75in width=9.00in imagemap=on border=off 
                    imagename="&Program_" ; /* For PNG file type */
 
   ods rtf 
     notoc_data 
     file          = "&Program_..rtf"      /* RTF File Name */
     style         = &Style_RTF            /* ODS style template */
     headery       = 1080                  /* 0.75in space shared with top margin */
     footery       = 360                   /* 0.25in space shared with bottom margin */
     image_dpi     = 300
  ;
 
 *----------------------------------------------------------------------------------  
  8) Run the GTL program with proc sgrender. Close graphic output RTF
     file and write to disk.                                        (template code)
  ----------------------------------------------------------------------------------;     
  %titles(PDF=N);
  %loop;
  
  ods rtf      close;                        * Output RTF file ;
  ods graphics off;
 
 *----------------------------------------------------------------------------------  
  9) Delete temporary PNG file.                                      (template code)
  ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(myRef,&Program_..png));
%let sysrc=%sysfunc(fdelete(&myRef));                
 