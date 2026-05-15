Program Flow           : 1) Set SAS options and style template libname
                         2) Simulate call SSUB call to /tools/init.inc 
                         3) Set global macro variable  
                         4) Build formats 
                         5) Generate data
                         6) Generate the statistics and print results. 
Program Flow           :  1) Set SAS options and style template libname. 
                          2) Set global macro variable  
                          3) Define titles and footnotes, adjust for RTF and PDF width.   
                          4) Build formats                                                                   
                          5) Generate data.  
                          6) Generate the statistics and print results.  
                          7) Compute Y axis value for Subject Counts. 
                          8) Define macro to call SGPANEL.
                          9) Set ODS graphics on and specify required ODS graphics 
                             parameters for PDF and SGE                      
                         10) Run the SG code with the macro. Close graphic output PDF
                             and SGE file and write to disk.   
                         11) Reset  ODS graphics options and set RTF file options.  
                         12) Run the SG code with the macro. Close RTF graphic output and
                             write to disk. 
                         13) Delete temporary PNG file. 