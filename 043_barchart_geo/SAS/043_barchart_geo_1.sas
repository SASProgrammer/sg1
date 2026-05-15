/*********************************************************************************

Program Name           : barchart_geo-1.sas

Path                   : sg1/043_barchart_geo

Purpose                : Bar chart of geometric mean with error bars
                          
Input Datasets/Views   : sashelp.cars

Macro calls external   : none

Production Outputs     : &JOBNAME..rtf  
                         &JOBNAME..pdf

Qualification Outputs  : Dir_.&JOBNAME._qc.sas7bdat 

Program Flow           : 1) Set SAS options and validation file output. 
                         2) Compute geometric mean and standard error. 
                         3) Set PDF graphics options                         
                         4) Define title and set global variables.  
                         5) Define macro to run SGPLOT code and call for PDF output
                         6) Close graphic output, write out PDF files
                         7) Set ODS graphics options for RTF output, call macro, output RTF file.
                         8) Delete temporary PNG file.                       
                         
Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ------------------------------------
001     1.00    05/14/26        dgianneschi     Create.

************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and validation file output.                      (template code)
 -----------------------------------------------------------------------------------;
 Options nodate nonumber center nobyline label PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

  libname Dir_ '.';
  %let Source_   = sashelp.cars;
  
 
*--------------------------------------------------------------------------------------
 2) Compute geometric mean and standard error.                        (functional code)
 ---------------------------------------------------------------------------------------;
  data adpp0;
      set &Source_;
      val=mpg_highway*1000;
      log_val = log(val);
  run;

  proc sort;
    by type;
  run;

  proc means data=adpp0;
      by type;
      var log_val;
      output out=mean_log_transformed_vars mean=mean_log_val stderr=stderr;
  run;

  data geomean;
      set mean_log_transformed_vars;
      geomean_ = exp(mean_log_val);
      stderr_  = sqrt((mean_log_val**2)*(stderr**2));
      lower_CL = geomean_ - stderr;
      upper_CL = geomean_ + stderr;
  run; 
  
*----------------------------------------------------------------------------------  
 3) Set ODS graphics on and specify required ODS graphics parameters to create a
    PDF output and an SGE file for presentation purposes.            (template code) 
 -----------------------------------------------------------------------------------;
  ods graphics on / reset=all height=6.00in width=9.00in imagemap=on border=off 
                    imagename="&JOBNAME" ; /* For PDF and SGE file type */

  ods pdf 
       notoc
       file         = "&JOBNAME..pdf"       /* pdf File Name */
       style        = &_Style_Land          /* ODS style template */
       dpi          = 300                   /* Publication quality resolution */
       ;
          
*-----------------------------------------------------------------------------------  
 4) Set titles and footnotes, adjust for RTF and PDF width.(template/functional code)
 -----------------------------------------------------------------------------------*;
 title1 j=r h=1.0 "&prtcmpny.";
 title2 j=r h=1.0 "&prtstudy.";
 title3 h=2.0 'Figure 14-1.1.2. Geometric Mean of Mileage by Vehicle Type';
 footnote1 j=l "_________________________________________________________________________________"
               "_________________________________________________________________________________";
 footnote2 j=l 'Errorbars show +/- 1 Geometric Standard Error';
 footnote3 j=l "Data Extracted: program_generated   " 
               "Source: ...&FOOT_JOBNAME   "
               "Output file: &JOBNAME..pdf  &sysdate &systime ";

*----------------------------------------------------------------------------------  
 5) Define macro to run SGPLOT code.                              (template code)
 ----------------------------------------------------------------------------------*;    
 %macro gen_graph;
    proc sgplot data=geomean noautolegend;
         vbar type/response=geomean_ stat=mean barwidth=0.5;
         vbarparm category=type response=geomeanl /
               limitlower=Lower_CL limitupper=Upper_CL;
    run;  
%mend gen_graph;

%gen_graph;


*----------------------------------------------------------------------------------  
 6) Close graphic output PDF and SGE file and write to disk.       (template code)
 ----------------------------------------------------------------------------------;
 ods pdf      close;                        * Output PDF file ;
 
 
*----------------------------------------------------------------------------------  
 7) Reset  ODS graphics options and set RTF file options.           (template code)
    RTF title is kept outside the graph to allow editing in WORD.
 -----------------------------------------------------------------------------------;
  ods graphics on / reset=all height=5.70in width=9.00in imagemap=on border=off 
                    imagename="&JOBNAME" ; /* For PNG file type */

   ods rtf 
      nogtitle                              /* Put title in RTF text outside of graph */      
      bodytitle  
      notoc_data 
      file          = "&JOBNAME..rtf"       /* RTF File Name */
      style         = &_Style_Land          /* ODS style template */
      headery       = 1080                  /* 0.75in space shared with top margin */
      footery       = 360                   /* 0.25in space shared with bottom margin */
      image_dpi     = 300
   ;

 %gen_graph; 
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

 
*----------------------------------------------------------------------------------  
 8) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
%let rc=%sysfunc(filename(png,&JOBNAME..png));










 (template code)

