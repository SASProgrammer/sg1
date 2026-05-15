/************************************************************************************* 

Program Name           : mean_panel_matrix.sas  

Path                   : <BAE Version>/sg/006_Mean_panel_matrix

Purpose                : To demonstrate creation of a panel of mean plots, one for each treatment group
                                                    
Production Outputs     : &Program..rtf  
                         &Program..pdf
                         &Program..sge

Qualification Outputs  :  None. 

Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Pre-process the data   
                          7) Set ODS graphics options for PDF and SGE.
                          8) Create the GTL program  
                          9) Run the GTL program with proc sgrender. Close graphic
                             output PDF and SGE file and write to disk.
                         10) Reset  ODS graphics options and set RTF file options. 
                             RTF title is kept outside the graph to allow editing 
                             in WORD. 
                         11) Run the GTL program with proc sgrender. Close graphic 
                             output RTF file and write to disk.
                         12) Delete temporary PNG file. 

User Documentation      : Please see Biometrics Programming Training Wiki  

Mod#    Ver#    Date            Username        Description
---     ----    -------         --------        ---------------------------------------------
001     1.00    17Nov2012       dgianneschi     Created program
*********************************************************************************************/

*-----------------------------------------------------------------------------------
 1) Set SAS options and style template libname.                      (template code)
 -----------------------------------------------------------------------------------;
 Options missing='-' nodate nonumber center nobyline label
         PAPERSIZE=Letter ORIENTATION=LANDSCAPE;

 libname ods_ '/u/biostat/t3.02.02/ods_v92/linux' access=readonly;
 
 *libname ods_ '\\biomdata\vol\u\biostat\t3.02.02\ods_v92\windows' access=readonly;
 
 ods path work.templates(update) ods_.templates(read) SASHelp.TmplMst(read);

*-------------------------------------------------------------------------------------
 2) Set global macro variable that make code easier to read.  (template code)
 -------------------------------------------------------------------------------------;
 libname Dir_ '.';
 
 %let Dir_      = %sysfunc(pathname(Dir_));
 %let Program_  = mean_panel_matrix;
 %let Style_RTF = US_Landscape_SG_Color; 
 %let Style_SGE = SG_PPT; 
 
 *-----------------------------------------------------------------------------------  
  3) Set titles and treatment group counts.                (template/functional code)
  -----------------------------------------------------------------------------------*;
  title1 j=r h=1.0 'Avidity Sciences, Inc.';
  title2 j=r h=1.0 'Study GS-US-xxx-xxx';
  title3 'Figure 14-1.1.2. Laboratory Data by Treatment Group ';
  title4 " Mean Lipid Profile by Study Week";

  %let n_pla  = 59;
  %let n_act1 = 54;
  %let n_act2 = 57;
  %let n_act3 = 60;
                  
*-----------------------------------------------------------------------------------
 4) Build formats to help in data generation                          (template code)
 -----------------------------------------------------------------------------------;
proc format; 
    value StudyWk 1 ="Baseline"
	                2 ="Day 14"
				          3 ="Day 42"
				          4 ="Day 70"
				          5 ="Day 98"
				          6 ="End Point"
				          ;
run;

*-----------------------------------------------------------------------------------
 5) Generate data                                                 (functional code)                     
 -----------------------------------------------------------------------------------;
data lipid;
   label xc="Study Week" ;
   input by $ 1-7 x $ 8-17 xc a_n a_med a_lcl a_ucl b_n b_med b_lcl b_ucl c_n c_med c_lcl c_ucl d_n d_med d_lcl d_ucl;
   datalines;
Test 1 Baseline  1  30 5.21 5.04 5.52 31 5.17 4.94 5.47 33 5.24 4.97 5.33 35 5.08 4.81 5.35 
Test 2 Baseline  1  30 4.90 4.80 4.90 31 5.00 4.90 5.10 33 5.10 5.00 5.10 35 4.90 4.90 5.00 
Test 1 Day 14    2  30 4.90 4.60 5.79 30 6.65 4.81 7.51 31 5.74 5.51 6.78 34 4.49 4.03 4.94 
Test 2 Day 14    2  30 5.00 4.80 5.10 30 5.10 4.90 5.20 33 5.15 5.10 5.30 34 5.10 5.00 5.30 
Test 1 Day 42    3  29 5.30 5.04 6.44 30 4.77 4.15 7.84 32 4.40 3.34 6.13 33 4.94 4.81 5.11 
Test 2 Day 42    3  29 5.00 4.90 5.10 30 5.00 4.90 5.20 32 5.20 5.10 5.40 33 5.05 4.90 5.20 
Test 1 Day 70    4  29 6.05 4.91 6.84 29 5.15 3.91 6.83 32 5.81 5.17 6.65 32 5.09 4.29 5.90 
Test 2 Day 70    4  28 5.00 4.90 5.20 30 5.10 5.00 5.20 32 5.20 5.00 5.20 32 5.10 5.00 5.20 
Test 1 Day 98    5  28 5.20 5.07 5.39 30 5.28 5.15 5.38 32 5.35 5.22 5.52 31 5.10 4.94 5.23 
Test 2 Day 98    5  28 5.10 4.90 5.10 30 4.90 4.80 5.00 32 5.20 5.10 5.30 31 5.10 5.10 5.20 
Test 1 End Point 6  25 5.24 4.97 5.48 28 5.15 5.09 5.42 32 5.34 5.15 5.53 31 5.04 4.94 5.22 
Test 2 End Point 6  24 4.90 4.80 5.20 30 5.10 4.90 5.20 32 5.10 5.10 5.30 31 5.20 5.20 5.30 
;
run;

*-----------------------------------------------------------------------------------
 6) Pre-process the data                                          (functional code)                     
 -----------------------------------------------------------------------------------;
data lipid;
  attrib nvala nvalb nvalc nvald length=$10.;
  set lipid;
  format xc Studywk. ;
  yval = 2 ; /* Position on graph to put values for n = XX. If need then generate individual variable for each graph. */
  nvala = compbl("n=" || put(a_n,3.));
  nvalb = compbl("n=" || put(b_n,3.));
  nvalc = compbl("n=" || put(c_n,3.));
  nvald = compbl("n=" || put(d_n,3.));
run;


*----------------------------------------------------------------------------------  
 7)  Set ODS graphics on and specify required ODS graphics parameters to create a
     PDF file for the regulatory submission and SGE file for presentation.(template code)
  -----------------------------------------------------------------------------------;
  ods graphics on / reset=all height=4.75in width=9.00in imagemap=on border=off 
                    imagename="&Program_" ; /* For PNG and SGE file type */

 ods pdf 
        notoc
        file         = "&Program_..pdf"      /* pdf File Name */
        style        = &Style_RTF            /* ODS style template */
        dpi          = 300                   /* Publication quality resolution */
        ;

 ods listing 
       SGE           = on                    /* Create the SGE file type */ 
       style         = &Style_SGE            /* ODS style template */         
    ;

*-----------------------------------------------------------------------------------
 8) Create the  GTL program                                          (template code)                                                                
 -----------------------------------------------------------------------------------;
 proc template;
  define statgraph begingraph;
    dynamic XVAR1 YVAR YVAR1 YVAR2 YVAR3 YVAR4 TRT1 TRT2 TRT3 TRT4;
    begingraph ;
    entryfootnote halign=left 
               "_________________________________________________________________"
               "_________________________________________________________________";
                       
    entryfootnote halign=left 
               "Study footnote."
               / pad=(top=5px) ;
 
    entryfootnote halign=left 
               "Data Extracted: program_generated   " 
               "Source: &Program_..sasf   "
               "Output file: &Program_..rtf &sysdate &systime "
              / pad=(top=5px) ; 

      layout lattice / columns=2 rows=2 rowgutter=6px columngutter=5px rowdatarange=union;

      layout overlay / yaxisopts=(griddisplay=on label='Mean with 95% CI' linearopts=(viewmax=8 viewmin=2)) 
                              xaxisopts=(griddisplay=on discreteopts=(tickvaluefitpolicy=thin TICKVALUELIST=("1" "2" "3" "4" "5" "6")));
	    entry TRT1 /valign=top textattrs=(weight=bold);
        scatterplot x=XVAR1 y=YVAR1 /yerrorlower=a_lcl yerrorupper=a_ucl name='as' 
                                                markerattrs=graphdata1(size=9px weight=bold)
                                                errorbarattrs=graphdata1(pattern=solid thickness=2);
        scatterplot x=XVAR1 y=YVAR / name='an' markercharacter=nvala
                                                markerattrs=graphdata1(size=9px weight=bold);
	    seriesplot x=xc y=YVAR1 / lineattrs=graphdata1(pattern=solid  thickness=2px) name='al';
      endlayout;
  
      layout overlay / yaxisopts=(label='Mean with 95% CI' griddisplay=on linearopts=(viewmax=9 viewmin=2)) 
                              xaxisopts=(griddisplay=on discreteopts=(tickvaluefitpolicy=thin TICKVALUELIST=("1" "2" "3" "4" "5" "6")));
        entry TRT2 /valign=top textattrs=(weight=bold);
        scatterplot x=XVAR1 y=YVAR2 /yerrorlower=b_lcl yerrorupper=b_ucl name='bs' 
                                                markerattrs=graphdata2(size=9px weight=bold)
                                                errorbarattrs=graphdata2(pattern=solid thickness=2);
	    scatterplot x=XVAR1 y=YVAR / name='bn' markercharacter=nvalb
                                                markerattrs=graphdata2(size=9px weight=bold);
       seriesplot x=XVAR1 y=YVAR2 / lineattrs=graphdata2(pattern=dash  thickness=2px) name='bl';
      endlayout;

	  layout overlay / yaxisopts=(label='Mean with 95% CI' griddisplay=on linearopts=(viewmax=8 viewmin=2))
                              xaxisopts=(griddisplay=on discreteopts=(tickvaluefitpolicy=thin TICKVALUELIST=("1" "2" "3" "4" "5" "6")));
	    entry TRT3 /valign=top textattrs=(weight=bold);
        scatterplot x=XVAR1 y=YVAR3 /yerrorlower=c_lcl yerrorupper=c_ucl name='cs' 
                                                markerattrs=graphdata3(size=9px weight=bold)
                                                errorbarattrs=graphdata3(pattern=solid thickness=2);
  	    scatterplot x=XVAR1 y=YVAR / name='cn' markercharacter=nvalc
                                                markerattrs=graphdata3(size=9px weight=bold);
	    seriesplot x=XVAR1 y=YVAR3 / lineattrs=graphdata3(pattern=shortdashdot  thickness=2px) name='cl';
      endlayout;

	  layout overlay / yaxisopts=(label='Mean with 95% CI' griddisplay=on linearopts=(viewmax=8 viewmin=2))
                              xaxisopts=(griddisplay=on discreteopts=(tickvaluefitpolicy=thin TICKVALUELIST=("1" "2" "3" "4" "5" "6")));
	    entry TRT4 /valign=top textattrs=(weight=bold);
        scatterplot x=XVAR1 y=YVAR4 /yerrorlower=d_lcl yerrorupper=d_ucl name='ds' 
                                                markerattrs=graphdata4(size=9px weight=bold)
                                                errorbarattrs=graphdata4(pattern=solid thickness=2);
	    scatterplot x=XVAR1 y=YVAR / name='dn' markercharacter=nvald
                                                markerattrs=graphdata4(size=9px weight=bold);
	    seriesplot x=XVAR1 y=YVAR4 / lineattrs=graphdata4(pattern=dashdashdot  thickness=2px) name='dl';
      endlayout; 
    endlayout;
    endgraph;
  end;
run;

*----------------------------------------------------------------------------------  
 9) Run the GTL program with proc sgrender. Close graphic output PDF and SGE
     file and write to disk.                                        (template code)
 ----------------------------------------------------------------------------------;
 proc sgrender data=lipid template=begingraph;
   where by="Test 1";  
   dynamic xvar1="xc" yvar ="yval" yvar1="a_med" yvar2="b_med" 
                                   TRT1="Placebo (N=&n_pla)" TRT2="AVID001 (N=&n_act1)"
                                   yvar3="c_med" yvar4="d_med" 
                                   TRT3="AVID002 (N=&n_act2)" TRT4="AVID003 (N=&n_act3)"
    ;
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
proc sgrender data=lipid template=begingraph;
   where by="Test 1";  
   dynamic xvar1="xc" yvar ="yval" yvar1="a_med" yvar2="b_med" 
                                   TRT1="Placebo (N=&n_pla)" TRT2="AVID001 (N=&n_act1)"
                                   yvar3="c_med" yvar4="d_med" 
                                   TRT3="AVID002 (N=&n_act2)" TRT4="AVID003 (N=&n_act3)"
      ;
 run;
 
 ods rtf      close;                        * Output RTF file ;
 ods graphics off;

*----------------------------------------------------------------------------------  
 12) Delete temporary PNG file.                                      (template code)
 ----------------------------------------------------------------------------------;
 %let rc=%sysfunc(filename(png,&Program_..png));
 %let sysrc=%sysfunc(fdelete(&png));





