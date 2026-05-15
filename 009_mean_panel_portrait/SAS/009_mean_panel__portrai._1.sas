/************************************************************************************* 

Program Name           : mean_panel_x_consistent_portrait.sas

Path                   : <BAE release>/sg/009_mean_panel_x_consistent_portrait

Purpose                : To demonstrate creation of a panel of mean plots, one for each treatment group

Input Datasets/Views   : %inc "&dir_./mplot_data_include1.sas";

Macro calls external   : none

Production Outputs     : &Program..rtf  
                         &Program..pdf
                         &Program..sge

Qualification Outputs  : result.sas7bdat

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Pre-process the data   
                          7) Set ODS graphics options for PDF and SGE.
                          8) Create macro to SGPANEL  
                          9) Run the macro. Close graphic
                             output PDF and write to disk.
                         10) Reset  ODS graphics options and set RTF file options. 
                             RTF title is kept outside the graph to allow editing 
                             in WORD. 
                         11) Run the macro. Close graphic 
                             output RTF file and write to disk.
                         12) Delete temporary PNG file. 


User Documentation      : Please see Biometrics Programming Training Wiki

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------------
001     1.00    5/11/26         dgianneschi     created program
*********************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=Portrait;

 libname ods_ '\sg1\000_style_template' access=readonly;
  
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = 009_mean_panel_x__portrait;
 %let Style_RTF = US_Portrait_SG_Color; 
 
 *-------------------------------------------------------------------------------------
  3) Set titles and footnotes.                                         (template code)
  -------------------------------------------------------------------------------------;

 title1 j=r h=1.0 'Avidity Biociences, Inc.';
 title2 j=r h=1.0 'Study AV-US-xxx-xxx';
 title3 j=r h=1.0 ' ';
 title4 'Figure 14-1.1.2. Laboratory Data by Visit ';
 title5 " Mean Ambisome ~{unicode '00AE'x} by Study Week ~{super 1}";
 footnote1 j=l "_____________________________________________________________________";
 footnote2 j=l "~{unicode '00B9'x} Study Week is defined as Saturday to Sunday";
 footnote3 j=l 'Example notes: Show treatment groups as a panel of plots';
 footnote4 j=l "Data Extracted: program_generated   " 
               "Source: &Program_..sas   "
              "Output file: &Program_..rtf &sysdate &systime ";
              
*-----------------------------------------------------------------------------------
 4) Build formats to help in data generation                         (template code)
 -----------------------------------------------------------------------------------; 
  %let n_pla  = 38;
  %let n_act1 = 60;
  %let n_act2 = 60;
  
  proc format;
    value
      trtgroup (notsorted)
           1="Control (N = &n_pla)"
           2="AVID001 (N = &n_act1)"
           3="AVID002 (N = &n_act2)"
       ;    
    value
      week (notsorted)
           0='Wk 0 '
           1='Wk 1'
           2='Wk 2'
           3='Wk 3'
           4='Wk 4'
           5='Wk 5'
           6='Wk 6'
       ;    
run;

*-----------------------------------------------------------------------------------
 5) Generate data                                                 (functional code)                     
 -----------------------------------------------------------------------------------;

%inc "&dir_./mplot_data_include1.sas";

*-----------------------------------------------------------------------------------
 6) Pre-process the data                                          (functional code)                     
 -----------------------------------------------------------------------------------;
* Sort the data *;
proc sort data=labs out=sortlabs;
   by visit visitwk trtgroup;
run;

* Generate the statistics *;
proc means data=sortlabs nway noprint;
   var lbstresn;
   output out=results n=n nmiss=nmiss mean=mean median=median min=min max=max range=range 
                          std=std stderr=stdmean uclm=uclm lclm=lclm;
   by visit visitwk trtgroup;
run;

* Subject count yaxis position *;
* Change according to placement where you want to populate subject count *;
proc sql;
   create table ypos as
   select distinct trtgroup, int(min (lclm)) - 2 as yval 
   from results
   group by trtgroup;
   
   create table Dir_.result as
   select a.*, b.yval 
   from results as a , ypos as b
   where a.trtgroup=b.trtgroup
   order by trtgroup, visitwk;

quit;

* Get confidence intervals *;
data result;
   format trtgroup trtgroup.;
   format visitwk  week.;
   label trtgroup='Group';
   label visitwk ='Study Week';
   label yval    ='ALB (g\l)';
   set Dir_.result;
   down = mean - std;
   up   = mean + std;
   nval='n=' || put(n,3.0);
run;

* Print statistics for comparisons *;
proc print data=result;   
   var visit visitwk trtgroup n nmiss mean std down up uclm lclm yval; 
run;

*----------------------------------------------------------------------------------  
 7) Set ODS graphics on and specify required ODS graphics parameters to create a
      RTF file for the CSR and SGE file nonCSR purposes such publications.
      Portrait available HEIGHT and WIDTH is 9.25 and 6.00 inches.   (template code)
 -----------------------------------------------------------------------------------;
  
  ods graphics on / reset=all imagemap=on border=off 
                    imagename="&Program_" ; /* For PNG and SGE file type */

  ods pdf 
      notoc
      file          = "&Program_..pdf"      /* pdf File Name */
      style         = &Style_RTF            /* ODS style template */
      dpi           = 300                   /* Publication quality resolution */
     ;
  
*-----------------------------------------------------------------------------------
 8) Create the  Plot                                               (template code)                                                                
 -----------------------------------------------------------------------------------;
 %macro gen_graph;
   ods escapechar='~';
   proc sgpanel data=result nocycleattrs noautolegend;
   
     panelby trtgroup / columns=1 novarname spacing=5 uniscale=column;  
        
     series x=visitwk y=mean  / group=trtgroup;
     scatter x=visitwk y=yval / group=trtgroup  markerchar=nval;
     scatter x=visitwk y=mean / group=trtgroup yerrorlower=uclm yerrorupper=lclm; 

     rowaxis label="Mean Ambisome ~{unicode '00AE'x} " grid ;
     colaxis label="Study Week ~{unicode '00B9'x}" values=(0 1 2 3 4 5 6) grid ;
   run;  
 %mend gen_graph;

 %gen_graph;

 *----------------------------------------------------------------------------------  
  9) Close graphic output PDF and SGE file and write to disk.       (template code)
  ----------------------------------------------------------------------------------;
  ods pdf      close;                        * Output PDF file ;

 *----------------------------------------------------------------------------------  
  10) Reset  ODS graphics options and set RTF file options.           (template code)
      RTF title is kept outside the graph to allow editing in WORD.
  -----------------------------------------------------------------------------------;
   ods graphics on / reset=all imagemap=on border=off 
                     imagename="&Program_" ; /* For PNG file type */

   ods rtf 
       nogtitle                              /* Put title in RTF text outside of graph */      
       bodytitle  
       notoc_data 
       file          = "&Program_..rtf"      /* RTF File Name */
       style         = &Style_RTF            /* ODS style template */
       image_dpi     = 300
    ;

  %gen_graph; 

  ods rtf      close;                        * Output RTF file ;
  ods graphics off;

 *----------------------------------------------------------------------------------  
  11) Delete temporary PNG file.                                      (template code)
  ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let rc=%sysfunc(fdelete(&png));
 