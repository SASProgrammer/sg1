/*********************************************************************************

Program Name           : subject_disposition_with_cumulative_percent_1.sas

Path                   : sg1\030_subject_disposition_with_cumulative_percent

Purpose                : To demonsrate the use of SAS ODS Graphics with the following requirements:
                          1) Functional:
                             a) Display cumulative percent of subjects over time
                             b) Display cumulative percent of subject treatment discontinuations by reason

Input Datasets/Views   : Program generated

Output lists, etc.     : &Program..pdf  
                         &Program..rtf  

Qualification Outputs  : None.

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Pre-process the data 
                          7) Define macro to generate the SGPLOT call to produce 
                             the series plots with reference lines
                          8) Set ODS graphics on and specify required ODS graphics 
                             parameters for PDF                     
                          9) Run the SG code with the macro. Close graphic output PDF
                             and SGE file and write to disk.   
                         10) Reset  ODS graphics options and set RTF file options.  
                         11) Run the SG code with the macro. Close RTF graphic output and
                             write to disk. 
                         12) Delete temporary PNG file.

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ------------------------------------
001     1.0     05/14/26       dgianneschi     Create
************************************************************************************/

*-----------------------------------------------------------------------------------
1) Set SAS options and style template libname.                      (template code)
-----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
        PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ 'sg1\000_style_templates' access=readonly;

 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

*-----------------------------------------------------------------------------------
 2) Simulate call SSUB call to /tools/init.inc                       (template code)
 -----------------------------------------------------------------------------------;
  libname Dir_ '.';
  %let Dir_      =%sysfunc(pathname(Dir_));

  %let Program_  = subject_disposition_with_cumulative_percent_1;
  %let Style_RTF =US_Landscape_SG_Color; 
  %let Style_SGE =SG_PPT; 

 %global n_Pla n_Drug;
 %let n_pla = 50 ;
 %let n_Drug = 50 ;
 
*-------------------------------------------------------------------------------------
 3) Define title.                                                      (template code)
 -------------------------------------------------------------------------------------;
 %macro title;
    title1 j=r h=1.0 'Avidity Biosciences, Inc.';
    title2 j=r h=1.0 'Study AV-US-xxx-xxx';
    title3 "Figure 14-01.001.001 Subject Disposition Over the Course of the Treatment Period";
 %mend title;

*-----------------------------------------------------------------------------------
 4) Create format for treatment groups (functional code)
 -----------------------------------------------------------------------------------;
 proc format;

  value trtgroup
     1='Placebo'
     2='Active Drug' ;

 
  value etxrsn
     1=  'Ineligibility determined'
     2=  '      Protocol violation'
     3=  '           Noncompliance'
     4=  '           Adverse event'
     5=  '       Consent withdrawn'
     6=  '      isease progression'
     7=  ' Administrative decision'
     8= '        Lost to follow-up'
     9= '                    Death'
     10= '                   Other';
 run;

*-----------------------------------------------------------------------------------
 5) Create example data with variables for:        
      Subject ID: pt                                
      Reason for treatment termination: rsnendtx    
      Study week treatment terminated: endtx_wk                    (functional code)
 -----------------------------------------------------------------------------------;
data cumpct;
 Do trtgroup=1 to 2;
      Do subj=1 to 50;
             pt=trtgroup*100 + subj;
             If subj<=10 and trtgroup=1 then do;
                rsnendtx=subj;
                endtx_wk=subj;
                output;
             End;
             If subj<=20 and trtgroup=2 then do;
                If subj<=10 then do;
                   rsnendtx=subj;
                   endtx_wk=subj;
                   output;
                End;
                If subj >10 then do;
                   rsnendtx=subj-10;
                   endtx_wk=subj-10;
                   output;
                End;
             End;
       End;
 End;
run;

%let n_tot = %eval(&n_pla + &n_Drug);

*-----------------------------------------------------------------------------------
6) Develop the data as per the requirement for display in plot    (functional code)
-----------------------------------------------------------------------------------;

  * Initialize counts for reason for subject discontinuation;

   data init_cumrsn;
    drop i j;
    do i=0 to 10 by 1;
     endtx_wk=i;
     count=0;
     percent=0;
      do j=1 to 10;
        rsnendtx=j;
        output;
      end;
     end;
   run;
   
   *ods output list=cumrsn;
   
   proc freq data=cumpct noprint;
     tables endtx_wk*rsnendtx /list out=cumrsn(drop=percent);
   run;
   
   data cumrsn;
      set cumrsn;
      percent=round(count/&n_tot*100,0.1);
      format percent 5.1;
   run;
      
   
   data cumrsn;
      merge init_cumrsn(in=in1) cumrsn;
      by endtx_wk rsnendtx;
      if percent = . then percent =0;
   run;
   
   
   proc sort data=cumrsn;
     by rsnendtx endtx_wk;
   run;
   
   data cumrsn;
     set cumrsn;
     by rsnendtx endtx_wk;
     if first.rsnendtx then cum_pct=0;
       cum_pct+percent;
     if last.endtx_wk;
    run;  
          
    proc sort data=cumrsn; 
       by endtx_wk rsnendtx;
    run;
         
   * Set macro variable for total subject counts for Placebo;

   data cumpct_Pla;
    set cumpct;
    if trtgroup=1;
   run;

   proc freq data=cumpct_Pla noprint;
     tables endtx_wk / out=cumpct_pla1 outcum ;
   run;
   
   data cumpct_pla1;
     set cumpct_pla1;
       cum_pct=round(cum_freq/&n_pla*100,0.1);
   run;
   
   * Initialize baseline counts and percents for Placebo;

   data cumpct_Pla1;
    set cumpct_Pla1;
    if _n_=1 then
     do;
      output;
      endtx_wk=0;
      count=0;
      percent=0;
      cum_freq=0;
      cum_pct=0;
      output;
     end;
    else output;
   run;

   data cumpct_Drug;
    set cumpct;
    if trtgroup=2;
   run;

  proc freq data=cumpct_Drug noprint;
     tables endtx_wk / out=cumpct_Drug1 outcum ;
  run;
   
   data cumpct_Drug1;
     set cumpct_Drug1;     
       cum_pct=round(cum_freq/&n_pla*100,0.1);
   run;  
  
  * Initialize baseline counts and percents for Drug A;

  data cumpct_Drug1;
   set cumpct_Drug1;
    if _n_=1 then
     do;
      output;
      endtx_wk=0;
      count=0;
      percent=0;
      cum_freq=0;
      cum_pct=0;
      output;
     end;
    else output;
   run;


   * Get cumulative counts and percents;

   data cumpct2;
   set cumpct_Pla1(in=inPla)
       cumpct_Drug1(in=inDrug);
    format trtgroup trtgroup.;
    cumulative_percent=100-cum_pct;
     if inPla
      then
       do;
        trtgroup=1;
        cumulative_count=input("&n_Pla",2.)-cum_freq;
       end;
      else
       do;
        trtgroup=2;
        cumulative_count=input("&n_Drug",2.)-cum_freq;
       end;
     run;

   proc sort;
    by endtx_wk;
   run;
   
  * Assign labels for treatment groups;

  data testdata;
   set cumpct2 cumrsn;
   length trtlabel $25;
   format rsnendtx etxrsn.;
   if trtgroup=1 then trtlabel="Placebo (N=&n_Pla)";
    else if trtgroup=2 then trtlabel="Drug A (N=&n_Drug)";
    format cum_pct 5.1;
    label cum_pct="Cumulative Percent";                
  run;

  proc sort data=testdata;
   by endtx_wk rsnendtx;
  run;
  
  proc print width=min;
  run;

 *-----------------------------------------------------------------------------------
  7) Create template                                       (functional/template code)
  -----------------------------------------------------------------------------------;
%macro gtl(pdf=Y);
 proc template;
  define statgraph layoutlattice;
    begingraph;

     layout lattice / rows=2 columns=1 columndatarange=unionall rowweights=(.70 .30) rowgutter=10 ;
     
         * Create plot of cumulative percent of subjects over time by treatment group;
         layout overlay /
            yaxisopts=(label='% of Subjects in Treatment Period'  labelattrs=(size=8)
               linearopts=(viewmin=0 viewmax=100  tickvaluesequence=(start=0 end=100 increment=10 )))
            xaxisopts=(label='Study Week'
              linearopts=(viewmin=0 viewmax=10  tickvaluesequence=(start=0 end=10 increment=1 )));
            stepplot x=endtx_wk y=cumulative_percent / /*lineattrs=(color=black)*/
             group=trtlabel name="step" curvelabel=trtlabel;
         endlayout;

         * Create table of reasons for discontinuation;
         layout overlay / xaxisopts=(display=none );
                  blockplot x=endtx_wk block=cum_pct / class=rsnendtx
                        repeatedvalues=true display=(label values )
                        valuehalign=start
                        labelposition=left labelattrs=GRAPHVALUETEXT(size=6pt)
                        valueattrs=GRAPHDATATEXT(size=6pt)
                        includemissingclass=false ;
         endlayout;
     endlayout;

     * Set label for Cumulative Percent;
     entryfootnote halign=center "Cumulative Percent (%)" / textattrs=(size=10pt weight=normal style=normal) pad=(top=10);

     * Set footnotes;
     %if &pdf=Y %then %do;
        entryfootnote halign=left 
                  "_______________________________________________________________________"
                  "_________________________________________________________________";
     %end;   
     %if &pdf=N %then %do;
        entryfootnote halign=left 
                  "____________________________________________________________________________"
                  "_________________________________________________________________________";
     %end;

                   
     entryfootnote halign=left 
               "Study footnote."
               / pad=(top=5px) ;
 
     entryfootnote halign=left 
               "Data Extracted: program_generated   " 
               "Source: &Program_..sas   "
              / pad=(top=5px) ; 
   
     entryfootnote halign=left 
               "Output file: &Program_..rtf &sysdate &systime ";
     endgraph;
   end;
  run;
%mend;

*----------------------------------------------------------------------------------  
 8)  Set ODS graphics on and specify required ODS graphics parameters to create a
     PDF file for the regulatory submission and SGE file for presentation.(template code)
  -----------------------------------------------------------------------------------;
  ods graphics on / reset=all height=5.00in width=9.00in imagemap=on border=off 
                    imagename="&Program_" ; /* For PNG and SGE file type */

 ods pdf 
        notoc
        file         = "&Program_..pdf"      /* pdf File Name */
        style        = &Style_RTF            /* ODS style template */
        dpi          = 300                   /* Publication quality resolution */
        ;

*----------------------------------------------------------------------------------  
 9) Run the GTL program with proc sgrender. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 %title;
 
 %gtl(pdf=Y);
 
 proc sgrender data=testdata template=layoutlattice;
 run;

 ods pdf      close;                        * Output PDF file ;

*----------------------------------------------------------------------------------  
10) Reset  ODS graphics options and set RTF file options.  RTF title is kept outside          
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
 11) Run the GTL program with proc sgrender. Close graphic output RTF
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 %title;
 
 %gtl(pdf=Y);
 
 proc sgrender data=testdata template=layoutlattice;
 run;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));





