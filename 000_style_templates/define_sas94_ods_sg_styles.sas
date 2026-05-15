    
      Input             : SASHelp.TmplMst.styles.rtf 

      Output            : /sg1/000_style_templates/templates.sas7bitm
                          where <os> is "windows" or "linux"
                          Here are the template name components:
                          "US" indicates US Letter paper size (8.5inches x 11inches)
                          "Landscape" or "Portrait" indicates the page orientation.
                          "sg" indicates use with SAS 9.2 statistical graphics
                          "NNpt" indicates a point size of 8, 9, 10, 11, or 12
                          Styles Created: 
                             ---for SAS 9.4 Statistical graphics---  
                             US_Landscape_sg_color       - color 
                             US_Landscape_sg_grey_scale  - grey scale 
                             US_Landscape_sg_black_white - black and white 
                             US_Portrait_sg_color        - color 
                             US_Portrait_sg_grey_scale   - grey scale 
                             US_Portrait_sg_black_white  - black and white 
                             SG_PPT                      - PowerPoint overhead 
                             SG_Poster                   - PowerPoint poster
                             SG_Label                    - Product labeling (package insert for physician and consumer)
                            ---for SAS 9.4 ---  
                             US_Landscape_8pt                                                                       
                             US_Landscape_9pt                                                              
                             US_Landscape_10pt                                                          
                             US_Landscape_11pt                                                          
                             US_Landscape_12pt                                                             
                             US_Portrait_8pt                                                              
                             US_Portrait_9pt                                                                
                             US_Portrait_10pt                                                            
                             US_Portrait_11pt                                                            
                             US_Portrait_12pt    
                                   
     ------------------------------------------------------------------------------------------*/

    libname ods_ '.\sg1\000_style_templates';

    ods path ods_.templates(update) SASHelp.TMPLMST(READ);

    *-------------------------------------------------------------------------
     Def_Sytle |
     ----------
     Define a SAS 9.4 styles.
     -------------------------------------------------------------------------;

    %macro Def_Style(
            name    =,            /* Output style template name*/
            parent  =RTF,         /* Input parent style in SASHELP.TMPLMST */
            useu    =US,          /* US is US letter size paper 8.5inches x 11inches */
            layout  =Landscape,   /* Paper orientation: Landscape or Portrait */
            fs      = 10,         /* font size */
            lm      = .75,        /* Left margin in inches */                                                                                                        
            rm      = 1.0,        /* Right margin in inches */                                              
            tm      = 1.5,        /* Top margin in inches */                                  
            bm      = .75,        /* Bottom margin in inches */
            bg      = white,      /* Backgroud color */
            fg      = black,      /* Foregroud color */
            lk      = blue,       /* Link color */
            lk1     = blue,
            lk2     = blue,
            bgH     = white,
            fg1     = black,
            fg2     = black,
            fg3     = black,
            fg4     = black,
            bg1     = white,
            bg2     = white,
            bg3     = white,
            bg4     = white,
            fgA4    = black,
            bgA4    = white,
            fgA3    = black,
            bgA3    = white,
            fgA2    = black,
            bgA2    = white,
            fgA1    = black,
            bgA1    = white,
            fgA     = black,
            bgA     = white,             
            fgB4    = black,
            bgB4    = white,
            fgB3    = black,
            bgB3    = white,
            fgB2    = black,
            bgB2    = white,
            fgB1    = black,
            bgB1    = white,
            fgB     = black,
            bgB     = white,            
           titlefg  = black,
           titlebg  = white,
       style_type   = paper    /* Removed logic that differentiated between paper, slide, and label */
           );
       proc template;
            %if &name^=%str() %then %do; %* literal name supplied;
                %let name = %sysfunc(upcase(&name));
            %end;    
            %else %do; %* construct name;
                %let name = %sysfunc(upcase(&useu._&layout._&fs.pt));
            %end;         
            %put Builiding name = &name from parent = &parent;
            define style &name / store=ods_.templates;
            parent=styles.&parent; 

            style fonts from fonts /
                   'headingFont' = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'docFont'     = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'footFont'    = ("<monospace>, <MTmonospace>, Courier New, Courier",  9pt, Bold)
                   'TitleFont'   = ("<monospace>, <MTmonospace>, Courier New, Courier", 11pt, Bold)
              
                   /* The fonts below are not known to be used by Proc */
                   /* Report, but must be present for Proc Template    */ 
              
                   'TitleFont2'         = ("<monospace>, <MTmonospace>, Courier New, Courier", 11pt, Bold)
                   'StrongFont'         = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'EmphasisFont'       = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'FixedEmphasisFont'  = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'FixedStrongFont'    = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'FixedHeadingFont'   = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'BatchFixedFont'     = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'FixedFont'          = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'headingEmphasisFont'= ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
            ;
            style GraphFonts from GraphFonts /
                   'headingFont'        = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'docFont'            = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'footFont'           = ("<monospace>, <MTmonospace>, Courier New, Courier", 9pt, Bold)
                   'TitleFont'          = ("<monospace>, <MTmonospace>, Courier New, Courier", 11pt, Bold)
                   'GraphDataFont'      = ("<monospace>, <MTmonospace>, Courier New, Courier", %eval(&fs - 2)pt, Bold)
                   'GraphUnicodeFont'   = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'GraphValueFont'     = ("<monospace>, <MTmonospace>, Courier New, Courier", %eval(&fs - 1)pt, Bold)
                   'GraphLabelFont'     = ("<monospace>, <MTmonospace>, Courier New, Courier", &fs.pt, Bold)
                   'GraphFootnoteFont'  = ("<monospace>, <MTmonospace>, Courier New, Courier", 9pt, Bold)
                   'GraphTitleFont'     = ("<monospace>, <MTmonospace>, Courier New, Courier", 11pt, Bold)
                   'GraphAnnoFont'      = ("<monospace>, <MTmonospace>, Courier New, Courier", %eval(&fs - 1)pt, Bold)
           ;    
     
           style SystemFooter from SystemFooter
                   "Controls system footer text." /
                   just=left
                   protectspecialchars=off
                   font = Fonts('FootFont');
          
              style PageNo from PageNo
                   "Controls page numbers for printer" /
                           font_size=9pt;
         
              style BodyDate from BodyDate
                   "Controls the date field in the Body file." /
                            font_size=9pt;
          
              style RTFData from Data/
                   protectspecialchars=off asis = on;
          
              style RTFHeader from Header/
                   protectspecialchars=off;
              
              style table from table/
                   rules=groups;
          
              style body from body/
                  leftmargin    = &lm.in
                  rightmargin   = &rm.in
                  topmargin     = &tm.in
                  bottommargin  = &bm.in;

              style GraphGridLines from GraphGridLines /
                    displayopts = "on";

              style color_list from color_list "Colors for &name style" /        
                    'link'   = &lk
                    'bgH'    = &bg
                    'fg'     = &fg
                    'fg1'    = &fg1
                    'fg2'    = &fg2
                    'fg3'    = &fg3
                    'fg4'    = &fg4
                    'bg'     = &bg
                    'bg1'    = &bg1
                    'bg2'    = &bg2
                    'bg3'    = &bg3
                    'bg4'    = &bg4
                    'ggrid'  = &fg
                    'fgA4'   = &fgA4
                    'bgA4'   = &bgA4
                    'fgA3'   = &fgA3
                    'bgA3'   = &bgA3
                    'fgA2'   = &fgA2
                    'bgA2'   = &bgA2
                    'fgA1'   = &fgA1
                    'bgA1'   = &bgA1
                    'fgA'    = &fgA
                    'bgA'    = &bgA             
                    'fgB4'   = &fgB4
                    'bgB4'   = &bgB4
                    'fgB3'   = &fgB3
                    'bgB3'   = &bgB3
                    'fgB2'   = &fgB2
                    'bgB2'   = &bgB2
                    'fgB1'   = &fgB1
                    'bgB1'   = &bgB1
                    'fgB'    = &fgB
                    'bgB'    = &bgB            
                    'link1'  = &lk1
                    'link2'  = &lk2
                   'titlefg' = &titlefg
                   'titlebg' = &titlebg;

             style colors from colors "Abstract colors used in the default style" /
                    'headerfgemph' = color_list('fg')
                    'headerbgemph' = color_list('bgH')
                    'headerfgstrong' = color_list('fg')
                    'headerbgstrong' = color_list('bgH')
                    'headerfg' = color_list('fg')
                    'headerbg' = color_list('bgH')
                    'datafgemph' = color_list('fg')
                    'databgemph' = color_list('bg')
                    'datafgstrong' = color_list('fg')
                    'databgstrong' = color_list('bg')
                    'datafg' = color_list('fg')
                    'databg' = color_list('bg')
                    'batchbg' = color_list('bg')
                    'batchfg' = color_list('fg')
                    'tableborder' = color_list('fg')
                    'tablebg' = color_list('bg')
                    'notefg' = color_list('fg')
                    'notebg' = color_list('bg')
                    'bylinefg' = color_list('fg')
                    'bylinebg' = color_list('bg')
                    'captionfg' = color_list('fg')
                    'captionbg' = color_list('bg')
                    'proctitlefg' = color_list('fg')
                    'proctitlebg' = color_list('bg')
                    'systitlefg' = color_list('fg')
                    'systitlebg' = color_list('bg')
                    'Conentryfg' = color_list('fg')
                    'Confolderfg' = color_list('fg')
                    'Contitlefg' = color_list('fg')
                    'link2' = color_list('lk2')
                    'link1' = color_list('lk1')
                    'contentfg' = color_list('fg')
                    'contentbg' = color_list('bg')
                    'docfg' = color_list('fg')
                    'docbg' = color_list('bg')  
                    'link'   = &lk
                    'bgH'    = &bg
                    'fg'     = &fg
                    'fg1'    = &fg1
                    'fg2'    = &fg2
                    'fg3'    = &fg3
                    'fg4'    = &fg4
                    'bg'     = &bg
                    'bg1'    = &bg1
                    'bg2'    = &bg2
                    'bg3'    = &bg3
                    'bg4'    = &bg4
                    'ggrid'  = &fg
                    'fgA4'   = &fgA4
                    'bgA4'   = &bgA4
                    'fgA3'   = &fgA3
                    'bgA3'   = &bgA3
                    'fgA2'   = &fgA2
                    'bgA2'   = &bgA2
                    'fgA1'   = &fgA1
                    'bgA1'   = &bgA1
                    'fgA'    = &fgA
                    'bgA'    = &bgA             
                    'fgB4'   = &fgB4
                    'bgB4'   = &bgB4
                    'fgB3'   = &fgB3
                    'bgB3'   = &bgB3
                    'fgB2'   = &fgB2
                    'bgB2'   = &bgB2
                    'fgB1'   = &fgB1
                    'bgB1'   = &bgB1
                    'fgB'    = &fgB
                    'bgB'    = &bgB            
                    'link1'  = &lk1
                    'link2'  = &lk2
                   'titlefg' = &titlefg
                   'titlebg' = &titlebg;
                   
            style GraphBackground  "Graph background attributes" /    
             backgroundcolor = &bg
                    color    = &bg;
                
            style GraphWalls  "Wall Attributes" /
                 frameborder = on
               contrastcolor = &fg
             backgroundcolor = &bg
             color           = &bg;
         
            style GraphLegendBackground  "Legend Background Attributes" /
                    backgroundcolor = &bg
                    color           = &bg;   

        end; %* of sytle definition;
        
        %* Print out code of &name and &parent style template;
        title "%upcase(&name.)  Template Source Code in a file(parent = &parent.)";
        source &name   / file="&name..sas"     store=ods_.templates;
        *source styles.&parent / file="&parent..sas"   store=SASHelp.TmplMst;
    run;

    %mend;

    * Call internal macro Def_Style to set style elemments such as fonts and margins *;

    %Def_Style(layout=Landscape,fs=8, lm=.75,rm=1.0,tm=1.5,bm=.75 );
    %Def_Style(layout=Landscape,fs=9, lm=.75,rm=1.0,tm=1.5,bm=.75 );
    %Def_Style(layout=Landscape,fs=10,lm=.75,rm=1.0,tm=1.5,bm=.75 );
    %Def_Style(layout=Landscape,fs=11,lm=.75,rm=1.0,tm=1.5,bm=.75 );
    %Def_Style(layout=Landscape,fs=12,lm=.75,rm=1.0,tm=1.5,bm=.75 );
    %Def_Style(layout=Portrait, fs=8, lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(layout=Portrait, fs=9, lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(layout=Portrait, fs=10,lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(layout=Portrait, fs=11,lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(layout=Portrait, fs=12,lm=1.5,rm=1.0,tm=1,  bm=.75 );
    
    * These styles are used for SAS 9.4 statistical graphics;

    %Def_Style(name=US_Landscape_sg_color,        parent=default);    
    
    %Def_Style(name=US_Landscape_sg_grey_scale,   parent=journal);    
    %Def_Style(name=US_Landscape_sg_black_white,  parent=journal2);  
    %Def_Style(name=US_Portrait_sg_color,        parent=default,    
               lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(name=US_Portrait_sg_grey_scale,   parent=journal,    
               lm=1.5,rm=1.0,tm=1,  bm=.75 );
    %Def_Style(name=US_Portrait_sg_black_white,  parent=journal2,  
               lm=1.5,rm=1.0,tm=1,  bm=.75 );
     
    %Def_Style(
            name    = sg_ppt,        /* Output style template name*/
            parent  = magnify,       /* Input parent style in SASHELP.TMPLMST */
            lm      = 0.25,          /* Left margin in inches */                                                                                                        
            rm      = 0.25,          /* Right margin in inches */                                              
            tm      = 0.25,          /* Top margin in inches */                                  
            bm      = 0.25,          /* Bottom margin in inches */
            bg      = CX660909,      /* Backgroud color */
            fg      = white,         /* foregroud color */
            lk      = cyan,           /* link color */
            lk1     = cyan,
            lk2     = cyan,
            bgH     = CX660909,
            fg1     = white,
            fg2     = white,
            fg3     = white,
            fg4     = white,
            bg1     = CX660909,
            bg2     = CX660909,
            bg3     = CX660909,
            bg4     = CX660909,
            fgA4    = white,
            bgA4    = CX660909,
            fgA3    = white,
            bgA3    = CX660909,
            fgA2    = white,
            bgA2    = CX660909,
            fgA1    = white,
            bgA1    = CX660909,
            fgA     = white,
            bgA     = CX660909,             
            fgB4    = white,
            bgB4    = CX660909,
            fgB3    = white,
            bgB3    = CX660909,
            fgB2    = white,
            bgB2    = CX660909,
            fgB1    = white,
            bgB1    = CX660909,
            fgB     = white,
            bgB     = CX660909,            
           titlefg  = yellow,
           titlebg  = CX660909, 
         style_type = slide
           );
     
    %Def_Style(
            name    = sg_poster,     /* Output style template name*/
            parent  = default,       /* Input parent style in SASHELP.TMPLMST */
            lm      = 0.25,          /* Left margin in inches */                                                                                                        
            rm      = 0.25,          /* Right margin in inches */                                              
            tm      = 0.25,          /* Top margin in inches */                                  
            bm      = 0.25,          /* Bottom margin in inches */
         style_type = slide
           );
         
     %Def_Style(
            name    = sg_label,      /* Output style template name*/
            parent  = journal2,      /* Input parent style in SASHELP.TMPLMST */
            lm      = 0.25,          /* Left margin in inches */                                                                                                        
            rm      = 0.25,          /* Right margin in inches */                                              
            tm      = 0.25,          /* Top margin in inches */                                  
            bm      = 0.25,          /* Bottom margin in inches */
         style_type = label
           );
  
   

                                                             *; 



