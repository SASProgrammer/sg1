/*-------------------------------------------------------------------------------------------------
  Program Name           : barchart_error_bar.sas

  Path                   : <BAE release>/sg/054_tnfset_titlekey_example_043/barchart_error_bar.sas
                                    
  Purpose                : This program is an example of how to use the SAS Statistical Graphic 
                           procedures to produce a bar chart with confidence bars.  The user
                           copies and modifies this program to meet their specific requirements.
                           The user assumes the business risk of qualifying the output for 
                           production use.  This risk is usually mitigated through double 
                           programming, using proc compare to verify the numbers on the production
                           and independently programmed data withis plotted on the two graphs. 
                           A visual inspection is also recommended.
                                                    
  Input Datasets/Views   : sashelp.cars (part of the SAS system test data)

  Macro calls external   : %tnfset - to get title and footnote definitions from an external file

  Outputs                : &Program..rtf - for Clinical Statistical Report 
                           &Program..pdf - for regulatory publication  
                           &Program..sge - for further processing with SGE Tool in order to 
                                           meet medical journal publication requirements 
                           Dir_.result   - for integration testing, regression testing, and 
                                           production qualification (double programming)                           

  Program Flow           :  1) Set SAS options and style template libname
                            2) Set global macro variable that make code easier to read.
                            3) Call BAE TNFSET utility to define titles and footnotes for this program.
                            4) Write out permanent dataset used to produce the plot, which will
                               for integration and regression testing, and production qualification.    
                            5) Define macro that will call SG Procedure to produce the plot. 
                            6) Set ODS graphics for RTF and SGE file creation.
                            7) Set ODS graphics For PDF output;
                            8) Call BAE TNFSET utility to define titles and footnotes for this program.                           
                            9) Close graphic output files and write to disk.  
                           10) Delete temporary PNG file.
                           
  Revision History:                         
      -------     --------      ------------------------------------------------------------------                           
      Date        Username                                   Description
      -------     --------      ------------------------------------------------------------------
      19Mar2012   dgianneschi   Create.
      28Oct2014   dgianneschi   Add call to BAE %tnfset for standard way to maintain titles and 
                                footnotes outside of program code.
  ------------------------------------------------------------------------------------------------*/

  
/*------------------------------------------------------------------------------------------------
  1) Set SAS options and style template libname.                                   (template code)
  ------------------------------------------------------------------------------------------------*/
  options missing='-' nodate nonumber center nobyline label
          PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

         
/*------------------------------------------------------------------------------------------------
  2) Set global macro variable that make code easier to read.                      (template code)
  ------------------------------------------------------------------------------------------------*/
  libname Dir_ '.';
  %let Dir_      = %sysfunc(pathname(Dir_)); 
  %let Source_   = sashelp.cars;      
  %let outname=&JOBNAME;
 
 
/*------------------------------------------------------------------------------------------------
  3) Call BAE TNFSET utility to define titles and footnotes for this program.      (template code)
  ------------------------------------------------------------------------------------------------*/
  %tnfset(titlekey = %str(&JOBNAME.) ,
          tsource  = %str(../tools/tnf.inc ),
          graphics = Y ,
          font     = Times,
          ttlsize  = 1.5,
          footsize = 0.25
         );
         
/*------------------------------------------------------------------------------------------------
  4) Prepare the data for reporting (used in integration and regression test).   (functional code)
  ------------------------------------------------------------------------------------------------*/
  proc summary data=&Source_. nway; 
     class type; 
     var mpg_highway; 
     output out=Dir_.result mean=mean stderr=stderr ; 
  run; 
 
 
/*------------------------------------------------------------------------------------------------  
  5) Define macro that will call SG Procedure to produce the plot.               (functional code)
  ------------------------------------------------------------------------------------------------*/
  %macro call_plot; 
     proc sgplot data=&Source_. noautolegend;
        vbar type/response=mpg_highway stat=mean limits=both limitstat=stderr barwidth=0.5;
            
     run;
  %mend call_plot; 
 
 
/*------------------------------------------------------------------------------------------------  
  6) Set ODS graphics on and specify required ODS graphics parameters to create an RTF file for 
     the CSR and SGE file nonCSR purposes such as publications.  Noproctitle suppresses the 
     writing of the title of the procedure that produces the graph.                (template code)
  ------------------------------------------------------------------------------------------------*/
  ods graphics on / reset=all height=5.00in width=9.25in imagemap=on border=off 
                    imagename="&outname" ; /* For PNG and SGE file type */

  ods noproctitle;

  ods rtf 
      nogtitle                              /* Put title in RTF text outside of graph */      
      bodytitle     
      notoc_data 
      file          = "&JOBNAME..rtf"       /* RTF File Name */
      style         = US_Landscape_SG_Color /* ODS style template */
      headery       = 1080                  /* 0.75in space shared with top margin */
      footery       = 360                   /* 0.25in space shared with bottom margin */
      image_dpi     = 300
   ;
   
  ods listing 
      SGE           = on                    /* Create the SGE file type */ 
      style         = US_Landscape_SG_Color /* ODS style template */
      image_dpi     = 100 
   ; 

  %call_plot;

  ods rtf      close;                        * Output RTF file ;
  ods listing  close;                        * Output PNG and SGE files;


/*------------------------------------------------------------------------------------------------  
  7) Set ODS graphics to create a PDF output.                                      (template code) 
  ------------------------------------------------------------------------------------------------*/
  ods graphics on / reset=all height=6.00in width=9.00in imagemap=on border=off 
                     imagename="&JOBNAME" ; /* For PNG file type */

  ods pdf 
      notoc
      file         = "&JOBNAME..pdf"       /* pdf File Name */
      style        = US_Landscape_SG_Color /* ODS style template */
      dpi          = 300                   /* Publication quality resolution */
   ;

   
/*------------------------------------------------------------------------------------------------  
  8) Call BAE TNFSET utility to define titles and footnotes for this program.      (template code)
  ------------------------------------------------------------------------------------------------*/       
  %tnfset(titlekey = %str(&JOBNAME.) ,
         tsource  = %str(../tools/tnf.inc ),
         graphics = Y ,
         font     = Times,
         ttlsize  = 0.50,
         footsize = 0.50
             );              
  %call_plot;

  
/*------------------------------------------------------------------------------------------------   
  9) Close graphic output files and write to disk.                                 (template code)
  ------------------------------------------------------------------------------------------------*/
  ods pdf      close;                        * Output PDF file ;
  ods graphics off;
  ods path     clear;

  
/*------------------------------------------------------------------------------------------------  
  10) Delete temporary PNG file.                                                    (template code)
  ------------------------------------------------------------------------------------------------*/
 %let rc=%sysfunc(filename(myRef,&outname..png));
 %let sysrc=%sysfunc(fdelete(&myRef)); 