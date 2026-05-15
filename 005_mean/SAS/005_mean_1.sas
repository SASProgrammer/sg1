*********************************************************************************** 

Program Name           : 005_mean_1.sas  

Path                   : sg1\005_mean\

Purpose                : To demonstrate creation of a mean plots
                                                    
Production Outputs     : &Program..rtf  - CSR in text table output   
                         &Program..pdf  - Appendix graph 
                         &Program..sge  - nonCSR output 
                         
Qualification Outputs  : means.sas7bdat - validation output    


Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define title and set global variables.    
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Generate the statistics and print results.  
                          7) Get confidence intervals and generate offset for all visit point based on 
                            treatment.  Get the Number of Subject counts.                      
                          8) Set ODS graphics options for PDF and SGE.
                          9) Create the GTL program  
                         10) Run the GTL program with proc sgrender. Close graphic
                             output PDF and SGE file and write to disk.
                         11) Reset  ODS graphics options and set RTF file options. 
                             RTF title is kept outside the graph to allow editing 
                             in WORD. 
                         12) Run the GTL program with proc sgrender. Close graphic 
                             output RTF file and write to disk.
                         13) Delete temporary PNG file. 

Storage/Control Specs  :  

Mod#    Ver#    Date            Username           Description
---     ----    -------         -----------        ------------------------------------------
001     1.00    5/11/2026       dgianneschi        Created program.
*********************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 
*-----------------------------------------------------------------------------------
 2)  Set global variables.                                           (template code)
 -----------------------------------------------------------------------------------;
 libname Dir_ '.';
 %let Dir_      = %sysfunc(pathname(Dir_)); 
 %let Program_  = _005_mean_1;
 %let Style_RTF = US_Landscape_SG_Color; 
 
 *-------------------------------------------------------------------------------------
  3) Define title and set global variables.                             (template code)
  -------------------------------------------------------------------------------------;
  title3 h=2.0 bold 'Figure 14-1.1.2. Laboratory Data by Visit ';
  title4 h=2.0 bold "Mean AmBisome~{unicode '00AE'x} by Study Week";
                  
*-----------------------------------------------------------------------------------
 4) Build formats                                                    (template code)
 -----------------------------------------------------------------------------------;
 proc format;
     value trtgroup 
           0='1:Placebo (N=100)'
           1='2:AVID001 10mg QD (N=100)'
           2='3:AVID002 20mg QD (N=100)'
           3='4:AVID003 30mg QD (N=100)'
           4='5:AVID004 40mg QD (N=100)'
           5='6:AVID005 50mg QD (N=100)'         
      ;    
    value  week 
           0='Baseline '
           1='Week 1'
           2='Week 2'
           3='Week 3'
           4='Week 4'
           5='Week 5'
           6='Week 6'
      ;    
run;

*-----------------------------------------------------------------------------------
 5) Generate data.                                                 (functional code)    
 -----------------------------------------------------------------------------------;
 data labs;
   do trtgroup=0 to 5;
      do visit=0 to 6;
         do subject=1 to 100;
            subjid=subject*1000+trtgroup;
            lbdesc='ALB';
            lbstresn=(30+sqrt(10)*rannor(5451)) + 
                     (trtgroup*2) + 
                     ((subjid*.001) + sqrt(5)*rannor(75451)) +
                      (visit);  /*6-visit*/
            output;
         end;
      end;
   end;
run;              
 
proc sort data=labs;
    by visit trtgroup;
run;

*-----------------------------------------------------------------------------------
 6) Generate the statistics and print results.                       (template code)    
 -----------------------------------------------------------------------------------;
 proc means data=labs nway noprint;
    var lbstresn;
    output out=Dir_.means n=n nmiss=nmiss mean=mean median=median min=min max=max range=range 
                          std=std stderr=stdmean uclm=uclm lclm=lclm q1=q1 q3=q3;
    by lbdesc visit trtgroup;
 run;

 proc print data=Dir_.means;   
    var lbdesc visit trtgroup n nmiss mean std uclm lclm q1 q3; 
 run;
 
*-----------------------------------------------------------------------------------
 7) Get confidence intervals and generate offset for all visit point based on 
    treatment.  Get the Number of Subject counts.                   (template code)    
 -----------------------------------------------------------------------------------;
 data means;
   format trtgroup trtgroup.;
   format visit  week.;
   set Dir_.means end=eof;
   nval=put(n,3.0);
   visit_off=visit - 0.15 + 0.05*trtgroup;
   if trtgroup=0 then n_1=nval ;
   if trtgroup=1 then n_2=nval ;
   if trtgroup=2 then n_3=nval ;
   if trtgroup=3 then n_4=nval ;
   if trtgroup=4 then n_5=nval ;
   if trtgroup=5 then n_6=nval ;
run;

*----------------------------------------------------------------------------------  
 8) Set ODS graphics on and specify required ODS graphics parameters to create a
    PDF output and an SGE file for presentation purposes.       (template code) 
 -----------------------------------------------------------------------------------;
 ods graphics on / reset=all height=5.75in width=9.00in imagemap=on border=off 
                  imagename="&Program_" ; /* For PNG file type */

 ods noproctitle escapechar='~';

 ods pdf 
    notoc
    file          = "&Program_..pdf"      /* pdf File Name */
    style         = &Style_RTF            /* ODS style template */
    dpi           = 300
      ;


      
*-----------------------------------------------------------------------------------
 9) Create the GTL program                                          (template code)                                                                
 -----------------------------------------------------------------------------------;
 proc template;
    define statgraph begingraph;
    dynamic _xlabel _ylabel;
    begingraph;
      layout overlay / yaxisopts=(label=_ylabel offsetmin=0.07)
                       xaxisopts=(label=_xlabel linearopts=(viewmin=-0.25 viewmax=6.25 
                                  tickvaluelist=(0 1 2 3 4 5 6) tickvalueformat=week.)) ;

      entry "Number of Subjects:" / autoalign=(BOTTOMLEFT) pad=(top=7);

      scatterplot y=mean x=visit_off /
                 group=trtgroup index=trtcd  markerattrs=(size=0) 
                 yerrorlower=lclm  yerrorupper=uclm 
                 errorbarattrs=(pattern=1 thickness=1px);

      seriesplot y=mean x=visit_off / primary=true
               group=trtgroup index=trtcd display=(markers) name="series";


      innermargin / align=bottom;
           blockplot x=visit block=n_6 / 
              label='6:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA6 (size=7pt)
              valueattrs=GRAPHDATA6 (size=7pt) ;
           blockplot x=visit block=n_5 / 
              label='5:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA5 (size=7pt) 
              valueattrs=GRAPHDATA5 (size=7pt);
           blockplot x=visit block=n_4 / 
              label='4:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA4 (size=7pt)
              valueattrs=GRAPHDATA4 (size=7pt) ;
           blockplot x=visit block=n_3 / 
              label='3:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA3 (size=7pt) 
              valueattrs=GRAPHDATA3 (size=7pt);
           blockplot x=visit block=n_2 / 
              label='2:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA2 (size=7pt)
              valueattrs=GRAPHDATA2 (size=7pt) ;
           blockplot x=visit block=n_1 / 
              label='1:' display=(label values)
              valuehalign=start valuefitpolicy=truncate labelposition=left labelattrs=GRAPHDATA1 (size=7pt) 
              valueattrs=GRAPHDATA1 (size=7pt);
      endinnermargin;

      DiscreteLegend "series" / title=" " halign=right autoalign=(right) location=outside across=1 border=false;
     
  endlayout;
  entryfootnote halign=left textattrs=(size=7pt)
              "_________________________________________________________________"
              "_________________________________________________________________";
                      
  entryfootnote halign=left textattrs=(size=7pt)
              "Vertical lines represent the confidence interval around the mean (alpha=0.05)"
              / pad=(top=5px) ;

  entryfootnote halign=left textattrs=(size=7pt)
              "Data Extracted: program_generated   " 
              "Source: &Program_..sasf   "
              "Output file: &Program_..rtf &sysdate &systime "
              / pad=(top=5px) ;
  endgraph;
end;
run;


*----------------------------------------------------------------------------------  
 10) Run the GTL program with proc sgrender. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 
 proc sgrender data=means template=begingraph;
      dynamic _xlabel="Study Week" _ylabel="Mean AmBisome~{unicode '00AE'x} ";
 run;

 ods pdf      close;                        * Output PDF file ;

*----------------------------------------------------------------------------------  
 11) Reset  ODS graphics options and set RTF file options.  RTF title is kept outside          
     the graph to allow editing in WORD.                             (template code)
 -----------------------------------------------------------------------------------;
 ods graphics on / reset=all height=5.50in width=9.00in imagemap=on border=off 
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
 12) Run the GTL program with proc sgrender. Close graphic output RTF
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;     
 proc sgrender data=means template=begingraph;
      dynamic _xlabel="Study Week" _ylabel="Mean AmBisome ~{unicode '00AE'x} ";
 run;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 13) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));




