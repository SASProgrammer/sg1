/************************************************************************************* 

Program Name           : scatter_panel_X_consistent_portrait_linear_1.sas 

Path                   : sg1/033_scatter_panel_X_consistent_portrait_linear

Purpose                : To demonstrate creation of a scatter panel X consistent linear with Portrait Layout
                                                    
SInput Datasets/Views   : sashelp.iris

Macro calls external   : none

Production Outputs     : &Program..rtf  
                         &Program..pdf

Qualification Outputs  : none

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Pre-process the data   
                          7) Set ODS graphics options for PDF and SGE.
                          8) Create macro to SGPANEL  
                          9) Run the macro. Close graphic
                             output PDF file and write to disk.
                         10) Reset  ODS graphics options and set RTF file options. 
                             RTF title is kept outside the graph to allow editing 
                             in WORD. 
                         11) Run the macro. Close graphic 
                             output RTF file and write to disk.
                         12) Delete temporary PNG file. 


User Documentation      : Please see Biometrics Data and Analysis Environment Wiki  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    05/14/26        dgianneschi     created program
*********************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=portrait;

 libname ods_ 'sg1\000_style_templates' access=readonly;
  
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = scatter_panel_X_consistent_portrait_linear_1;
 %let Style_RTF = US_Portrait_SG_Color; 
 
 *-------------------------------------------------------------------------------------
  3) Set titles and footnotes.                                         (template code)
  -------------------------------------------------------------------------------------;

 title1 j=r h=1.0 'Avidity Biosciences, Inc.';
 title2 j=r h=1.0 'Study AV-US-xxx-xxx';
 title3 j=r h=1.0 ' ';
 title4 "Example Graph";
 title5 "Multi-Panel With Consistent X axis"; 
 footnote1 j=l "_____________________________________________________________________";
 footnote2 j=l 'Example notes: Show treatment groups as a panel of plots';
 footnote3 j=l "Data Extracted: program_generated   " ;
 footnote4 j=l "Source: &Program_..sas   ";
 footnote5 j=l "Output file: &Program_..rtf &sysdate &systime ";
              


 *---------------------------------------------------------------------------------  
 6) Call SG graphic procedures                                   (functional code)
 ---------------------------------------------------------------------------------;
 %macro gen_graph;
   proc sgscatter data=sashelp.iris;*(where=(species="Virginica"));   
   compare y=(sepallength petallength)
           x=(petalwidth) / reg spacing=5 group=species grid;
   run;
 %mend gen_graph;

*----------------------------------------------------------------------------------  
 8) Set ODS graphics on and specify required ODS graphics parameters to create a
    PDF output and an SGE file for presentation purposes.            (template code) 
 -----------------------------------------------------------------------------------;
 ods graphics on / reset=all imagemap=on border=off 
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
 %gen_graph;
 
 ods pdf      close;                        * Output PDF file ;

 *----------------------------------------------------------------------------------  
  10) Reset  ODS graphics options and set RTF file options.           (template code)
      RTF title is kept outside the graph to allow editing in WORD.
  -----------------------------------------------------------------------------------;
  ods graphics on / reset=all imagemap=on border=off 
                   imagename="&Program_" ; /* For PNG file type */

  ods rtf 
    notoc_data 
    file          = "&Program_..rtf"      /* RTF File Name */
    style         = &Style_RTF            /* ODS style template */
    image_dpi     = 300
 ;

*----------------------------------------------------------------------------------  
 11) Run the GTL program with proc sgrender. Close graphic output RTF
    file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 %gen_graph;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let rc=%sysfunc(fdelete(&png));


