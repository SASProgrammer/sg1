/************************************************************************************* 

Program Name           : scatter_matrix_linear_1.sas  

Path                   :  sg1/031_scatter_matrix_linear

Purpose                : To demonstrate creation of a scatter matrix linear
                                                    
Input Datasets/Views   : sashelp.iris

Macro calls external   : none

Output lists, etc.     : &Program..rtf  
                         &Program..sge

Program Flow           : 1) Set SAS options and style template libname
                         2) Set global macro variable that make code easier to read.
                         3) Simulate call SSUB call to /tools/init.inc 
                         4) Define title and set global variables.  
                         5) Set ODS graphics on and specify required ODS graphics parameters                         
                         7) Define macro to generate the SGPLOT call to produce 
                             the series plots with reference lines
                          8) Set ODS graphics on and specify required ODS graphics 
                             parameters for PDF                     
                          9) Run the SG code with the macro. Close graphic output PDF
                             and write to disk.   
                         10) Reset  ODS graphics options and set RTF file options.  
                         11) Run the SG code with the macro. Close RTF graphic output and
                             write to disk. 
                         12) Delete temporary PNG file.


Storage/Control Specs  :  

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
 %let Program_  = scatter_matrix_linear;
 %let Style_RTF = US_Landscape_SG_Color; 

 *-----------------------------------------------------------------------------------  
  3) Set titles and footnotes, adjust for RTF and PDF width.(template/functional code)
  -----------------------------------------------------------------------------------*;
  %macro titles(pdf=Y);
     title1 j=r h=1.0 'Avidity Biosciences, Inc.';
     title2 j=r h=1.0 'Study AV-US-xxx-xxx';
     title3 "Example Graph";
     title4 "Multi-Celled Linear Curve for Species Virginica";
     %if %upcase(&pdf)=Y %then %do; 
         footnote1 j=l "_________________________________________________________________"
                       "___________________________________________________________";
      %end;
      %else %do; 
         footnote1 j=l "_________________________________________________________________"
                       "_________________________________________________________________________";
      %end;
 
     footnote2 j=l "Study Footnote.";
     footnote3 j=l "Data Extracted: program_generated   " 
                    "Source: &Program_..sas   "
                    "Output file: &Program_..rtf &sysdate &systime ";
 %mend titles;
 
 *---------------------------------------------------------------------------------  
 4) Define macro to call SG graphic procedure            (functional/template code)
 ---------------------------------------------------------------------------------;
 %macro loop;
    proc sgscatter data=sashelp.iris(where=(species="Virginica"));   
       plot (sepallength sepalwidth)*(petallength petalwidth) / reg;
    run;
 %mend loop;
 
*----------------------------------------------------------------------------------  
 8) Set ODS graphics on and specify required ODS graphics parameters to create a
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
 9) Run the SG code with the macro. Close graphic output PDF and SGE
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 %titles(PDF=Y);
 %loop;
 
 ods pdf      close;                        * Output PDF file ;

 *----------------------------------------------------------------------------------  
  10) Reset  ODS graphics options and set RTF file options.           (template code)
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
 11) Run the GTL program with proc sgrender. Close graphic output RTF
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 %titles(PDF=N);
 %loop;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %macro delete_intermediate_files;
    %do I=1 %to 10;
        %if &I=1 %then %do;
            %let rc=%sysfunc(filename(png,&Program_..png));
            %let sysrc=%sysfunc(fdelete(&png));
        %end;
        %let rc=%sysfunc(filename(png,&Program_&I..png));
        %let sysrc=%sysfunc(fdelete(&png));
    %end;
 %mend delete_intermediate_files;
 %delete_intermediate_files;


