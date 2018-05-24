
% psLATgen_DSACXAC
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains usable data from A0241, A0242, A0428, A0454,
% as extracted out DSACXAC (a list generated with psSACXAC)
% TF 29/08/2005

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';


                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
                                                                                                                                              
%A0241--------------------------------------------------------------------------------------------------------------                                                                                                                
%Fibre 10                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [15;16;17], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 15                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 17                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [30;31;32;33], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 30                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 18                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [35;36;37;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 35                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 19                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [41;42;43;44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 42                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 20                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [47;48;49;50;52], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 47                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 21                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [54;55;56;58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 54                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 23                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [64;65;66], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 64                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 25                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [70;71;73], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 70                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 35                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [95;96;97;99], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 95                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 37                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [104;105], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 105                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 42                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [114;115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 114                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 47                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [123;124;125], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 123                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 48                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [128;129;130], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 128                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 55                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [179;180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 179                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 64                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [195;196], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 195                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 65                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [198;199], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 198                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 67                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [208;209;210], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 208                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 72                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [232;233], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 232                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 82                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [263;264;265], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 263                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 83                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [267;268], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 267                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           

%A0242--------------------------------------------------------------------------------------------------------------
%Fibre 1                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [2;3;4], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 2                        
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 2                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [9;10;11;12], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');             
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 9                        
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 8                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [23;24;25;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 23                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 9                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [30;31;32], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 30                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 10                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [34;35;36], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 34                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 11                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [40;41;42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 40                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 12                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [44;45;46;47;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 44                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 13                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [50;51;52;53], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 50                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 14                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [56;57;58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 58                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 17                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [64;66;67;72], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 64                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 18                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [75;78;79], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 75                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 19                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [83;84], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 83                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 20                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [88;90;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 88                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 21                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [93;94;95], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 93                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 22                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [97;98], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 97                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 25                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [106;109;110], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 106                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 26                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [113;115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 113                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 28                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [121;122;123], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 123                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 31                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [129;130;131], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 129                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 32                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [134;135], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 134                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 33                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [137;138;139], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 137                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 34                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [142;143;144], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 142                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 37                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [155;156;157;160], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 155                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 44                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [179;180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 179                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 47                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [191;195;197], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 191                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 48                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [202;203;204;207], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 202                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 49                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [211;216;217], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 211                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 51                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [233;234;235;236;237], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 234                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 52                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [241;242;243], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 241                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 63                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [280;281;282;283], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 280                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 76                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [318;319], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 318                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 82                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [336;337], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 336                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 85                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [343;345], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 343                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 86                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [351;352;353], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 351                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 88                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [358;359], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 358                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 89                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [364;365;366], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 364                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 90                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [369;371], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 369                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           

%A0428--------------------------------------------------------------------------------------------------------------
%Fibre 6                                                                                                                                      
List = GenWFList(struct([]), 'A0428', [66;76], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 66                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 7                                                                                                                                      
List = GenWFList(struct([]), 'A0428', [79;90;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 79                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 11                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [159;160;161], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 159                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 12                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [218;219;220], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 218                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 13                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [239;240;241], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 239                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 17                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [275;276], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 275                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 18                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [279;280;281], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 279                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 19                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [313;314], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 313                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 20                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [368;369;370], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 368                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 21                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [375;376;377;378], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 375                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 22                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [393;394;395], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 393                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 23                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [408;409], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 408                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 36                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [468;469;470;471], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 468                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 42                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [479;480;481], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 479                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 43                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [484;485], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 484                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 44                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [487;488], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 487                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 46                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [492;493;494], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 492                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 48                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [497;498;499], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 497                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 49                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [501;502;503], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 501                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 50                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [505;506], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 505                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 51                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [508;509;510;512;513], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 508                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 52                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [515;516;517], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 515                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 55                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [525;526], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 525                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 57                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [530;531;532;533;534], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 530                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 59                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [537;538;539], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 537                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 60                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [541;542;543], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 541                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 61                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [545;546], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 545                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 62                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [548;549;550;551], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 548                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 64                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [555;556], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 555                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 66                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [560;561;562], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 560                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 68                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [565;566;567], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 565                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 70                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [571;572], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 571                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 71                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [574;575;576], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 574                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 73                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [579;580], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 579                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 74                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [582;583;584], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 582                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 75                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [586;587], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 586                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           

%A0454--------------------------------------------------------------------------------------------------------------
%Fibre 5                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [13;14], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 13                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 6                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [17;18;19;21], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 17                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 9                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [37;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 37                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 10                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [40;41], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 40                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 13                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [47;48;49;50;51], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 47                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 32                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [93;94;95;96], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 93                       
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 34                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [104;105;106;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 104                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 35                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [109;111;112;113], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 109                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 36                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [116;118;119], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 116                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 40                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [131;132;133;134], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 131                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 41                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [139;140;141;142;143;144], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 140                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 44                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [150;151;152], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 150                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 45                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [155;156], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 155                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 47                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [163;164;165], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 163                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 48                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [173;174;175;176], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 173                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 58                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [198;197], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 198                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 59                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [203;204], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 203                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 68                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [221;222;223;224], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 221                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 71                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [231;232], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 231                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 72                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [234;235;236], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 234                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 74                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [241;242;243], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 241                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
%Fibre 75                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [248;249;250], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 248                      
D = [D; ExtractPSentry(T, XFieldName, YFieldName)];                                                                                           
                                                                                                                                              
                                                                                        
                                                                                       
                                                                                                                                              
                                                                                       
                                                                                                                                              
                                                                                           
                                                                                                                                              
                                                                   
                                                                                                                                              


%-----------------------------------------------------------------
DLAT = D; clear('D');
save(mfilename, 'DLAT');
%-----------------------------------------------------------------


groupplot(DLAT, 'xval', 'yval');

echo off;