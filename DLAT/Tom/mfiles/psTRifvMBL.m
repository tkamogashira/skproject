
% psTRifvMBL
% popscript to study effect of SPL on delay, but now 'mean binaural level' is a constant value for a 
% certain value of the trading ratio, so that it's possible to study how trading ratio changes as 'MBL'
% changes.
%
% two plots are made:
%   - a groupplot-(non-reference-intensity,delay) of all the different 'MBL'-values of the fibers
%   - a groupplot-(slope,'MBL') of all the fibers
% 
% this version of the popscript contains all usable fibers from A0241 (see list DLAT from pslatgen_all.mat), 
% and for each fiber slopes are calculated for as much MBL's as possible. But always steps between adjacent SPL's are 10dB, 
% thus a fiber that has only data for noise responses at 90, 70 and 50 dB is not used in the analysis. 
% This is done to keep the resolution
% equal for each fiber.
% TF 01/09/2005
%
% CURRENTLY BUSY ADDING FIBERS OF A0428

echo on;

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';

D=struct([]);
                                                                                                                                                                                                                                                              
%A0241--------------------------------------------------------------------------------------------------------------
%-------------------------------------------------------------------------------------------------------------------
%Fiber 10--------------SPLS: [70;60;80] for dsnrs[15;16;17]
D1=struct([]);D2=struct([]);
%MBL of 60dB
ref=2;
List = GenWFList(struct([]), 'A0241', [16;17], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 15
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];  
ref=1;
List = GenWFList(struct([]), 'A0241', [15], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 15                       
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;clear D2;

%Fiber 17--------------SPLS: [70;60;80;50] for dsnr[30;31;32;33]
D1=struct([]);
D2=struct([]);
%MBL of 70dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [31;32], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 31                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];                                                                                           
%70dB tov 70dB (thus SAC)
ref=1;
List = GenWFList(struct([]), 'A0241', [30], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 30                       
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
ref=1;
List = GenWFList(struct([]), 'A0241', [32;31], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 32                       
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];                                                                                                                                       
%MBL of 60 dB                                                         
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [30;33], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 33                       
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];                                                                                           
%60dB tov 60dB (thus SAC)
List = GenWFList(struct([]), 'A0241', [31], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 31                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
ref=1;
List = GenWFList(struct([]), 'A0241', [30;33], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 30                       
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];
                                                                                       
D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;


%Fiber 18----------SPLS:[70;60;80;50] for datasetnrs[35;36;37;38]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [36;37], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 36                      
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [35], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 35                       
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
ref=1;
List = GenWFList(struct([]), 'A0241', [36;37], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 37                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [35;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 38                     
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0241', [36], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 36                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
ref=1;
List = GenWFList(struct([]), 'A0241', [35;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 35                     
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)];

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 19----------SPLS:[60;70;80;50] for datasetnrs[41;42;43;44]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [43;41], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 43                      
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 42                       
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [42;44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 44                     
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0241', [41], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no'); % reference = ds 41                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 20 [70;60;80;50;40] for dsnrs[47;48;49;50;52]-------------------------------------------------------------------------
D1=struct([]); D2=struct([]); D3=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [48;49], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [47], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [47;50], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                      
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0241', [48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;
%MBL of 50 dB
D3=struct([]);
%60dB tov 40 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [48;52], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                      
D3 = [D3; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%50dB SAC
List = GenWFList(struct([]), 'A0241', [50], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D3 = [D3; ExtractPSentry(T, XFieldName, YFieldName)];
%40dB tov 60 dB
D3(3)=D3(1);D3(3).yval=-(D3(1).yval);D3(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval');concatto1Row(D3,'xval','yval')];clear D1;clear D2;clear D3;

%Fiber 21----------SPLS:[70;80;60;50] for datasetnrs[54;55;56;58]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [55;56], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [54], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [54;58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0241', [56], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 25----------SPLS:[70;80;60] for datasetnrs[70;71;73]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [71;73], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [70], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];

%Fiber 29, high cf (added NSPL-data)--------SPLS:[40,50,60,70,80]--for dsnr[-47_1,-47_2,-45_1,-45_2,-45_3]---------------------
%interaural correlation +1
D1=struct([]);D2=struct([]);D3=struct([]);
%MBL of 70 dB
%80dB tov 60dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-45,-45]),'isubseqp',num2cell([1,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%70dB SAC
List = struct('filename','A0241','iseqp',num2cell([-45]),'isubseqp',num2cell([2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%60dB tov 80dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-47,-45]),'isubseqp',num2cell([2,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0241','iseqp',num2cell([-45]),'isubseqp',num2cell([1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;
%MBL of 50 dB
%60dB tov 40dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-47,-45]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D3 = [D3; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%50dB SAC
List = struct('filename','A0241','iseqp',num2cell([-47]),'isubseqp',num2cell([2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D3 = [D3; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%40dB tov 60dB
D3(3)=D3(1);D3(3).yval=-(D3(1).yval);D3(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval');concatto1Row(D3,'xval','yval')];

if 0
%interaural correlation -1-----------------------[-46] subseq [1;2;3;4;5] for SPLS[40;50;60;70;80]
D1=struct([]);D2=struct([]);D3=struct([]);
%MBL of 70 dB
%80dB tov 60dB
ref=2;
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46]),'isubseqn',num2cell([3,5]),'discernvalue',num2cell([60,80]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%70dB SAC
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46]),'isubseqn',num2cell([4]),'discernvalue',num2cell([70]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%60dB tov 80dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46]),'isubseqn',num2cell([2,4]),'discernvalue',num2cell([50,70]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46]),'isubseqn',num2cell([3]),'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;
%MBL of 50 dB
%60dB tov 40dB
ref=2;
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46]),'isubseqn',num2cell([1,3]),'discernvalue',num2cell([40,60]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D3 = [D3; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%50dB SAC
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46]),'isubseqn',num2cell([2]),'discernvalue',num2cell([50]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D3 = [D3; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%40dB tov 60dB
D3(3)=D3(1);D3(3).yval=-(D3(1).yval);D3(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval');concatto1Row(D3,'xval','yval')];
end


%Fiber 30 high cf
%interaural correlation -1-----------------------[-49] subseq [1;2;3] for SPLS[50;60;70]
D1=struct([]);
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-49,-49]),'isubseqn',num2cell([1,3]),'discernvalue',num2cell([50,70]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-49]),'isubseqn',num2cell([2]),'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];


%Fiber 31 high cf
%interaural correlation +1 --------SPLS:[50,60,70,80]--for dsnr[-50] subseq[1,2,3,4]---------------------
D1=struct([]);D2=struct([]);
%MBL of 70 dB
%80dB tov 60dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-50,-50]),'isubseqp',num2cell([2,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%70dB SAC
List = struct('filename','A0241','iseqp',num2cell([-50]),'isubseqp',num2cell([3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%60dB tov 80dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-50,-50]),'isubseqp',num2cell([1,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0241','iseqp',num2cell([-50]),'isubseqp',num2cell([2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1; clear D2;

%Fiber 35----------SPLS:[70;60;50;80] for datasetnrs[95;96;97;99]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [96;99], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [95], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [95;97], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0241', [96], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 39
%interaural correlation +1 --------SPLS:[50,60,70,80]--for dsnr[-67] subseq[1,2,3,4]---------------------
D1=struct([]);D2=struct([]);
%MBL of 70 dB
%80dB tov 60dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-67,-67]),'isubseqp',num2cell([2,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%70dB SAC
List = struct('filename','A0241','iseqp',num2cell([-67]),'isubseqp',num2cell([3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%60dB tov 80dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0241','iseqp',num2cell([-67,-67]),'isubseqp',num2cell([1,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0241','iseqp',num2cell([-67]),'isubseqp',num2cell([2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D2 = [D2; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 42 dsnr[114;115;116]----SPL[70;60;80]----------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [114], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%Fiber 47 dsnr[123;124;125]----SPL[70;60;80]----------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [124;125], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [123], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 48 dsnr[128;129;130]----SPL[70;60;80]----------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [129;130], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [128], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 55 dsnr[179;180;181]----SPL[70;60;80]----------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [179], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 67 dsnr[208;209;210]----SPL[70;80;60]----------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [209;210], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [208], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 82 ds[263 264 265] spl[70 60 80]------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0241', [264;265], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0241', [263], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%---------------------------------------------------------------------------------------------------------------------
%A0242 ---------------------------------------------------------------------------------------------------------------

%Fiber 1 ds[2;3;4] spl[70;50;60]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [2;3], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [4], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 2----------SPLS:[70;60;80;50] for datasetnrs[9;10;11;12]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [10;11], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [9], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [9;12], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [10], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 8----------SPLS:[70;60;80;50] for datasetnrs[23;24;25;27]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [24;25], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [23], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [23;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [24], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 9 ds[30;31;32] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [30;32], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [31], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 10 ds[34;35;36] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [34;36], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [35], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 11 ds[40;41;42] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [41;42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [40], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 12 ds[44;45;46;47;48] spl[70;60;80;50;40]------------------------------------------------------------------------
D1=struct([]);D2=struct([]);D3=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [45;46], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [44;47], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [45], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;
%MBL of 50 dB
%60dB tov 40 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [45;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D3 = [D3; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%50dB SAC
List = GenWFList(struct([]), 'A0242', [47], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D3 = [D3; ExtractPSentry(T, XFieldName, YFieldName)];
%40dB tov 60 dB
D3(3)=D3(1);D3(3).yval=-(D3(1).yval);D3(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval');concatto1Row(D3,'xval','yval')];clear D1;clear D2;clear D3;


%Fiber 13----------SPLS:[70;60;50;80] for datasetnrs[50;51;52;53]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [51;53], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [50], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [50;52], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [51], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 14 ds[56;57;58] spl[80;60;70]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [56;57], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 17----------SPLS:[70;60;80;50] for datasetnrs[64;66;67;72]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [66;67], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [64], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [64;72], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [66], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 18 ds[75;78;79] spl[70;80;60]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [78;79], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [75], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 20 ds[88;90;91] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [88;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [90], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 21 ds[93;94;95] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [93;95], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [94], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 25 ds[106;109;110] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [106;110], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [109], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 26 ds[113;115;116] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [113], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 28 ds[120;121;122] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [121;122], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [120], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 31 ds[129;130;131] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [130;131], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [129], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 33 ds[137;138;139] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [138;139], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [137], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%Fiber 34----------SPLS:[70;60;80;50] for datasetnrs[142;143;144;146]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [143;144], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [142], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [142;146], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [143], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;


%Fiber 37----------SPLS:[70;60;80;50] for datasetnrs[155;156;157;160]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [156;157], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [155], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [155;160], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [156], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;


%Fiber 44 ds[179;180;181] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [179], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 47----------SPLS:[70;60;80;50] for datasetnrs[191;192;195;197]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [192;195], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [191], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [191;197], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [192], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 48----------SPLS:[70;60;80;50] for datasetnrs[202;203;204;207]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [203;204], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [202], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [202;207], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [203], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

%Fiber 49 ds[211;216;217] spl[70;60;50]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [211;217], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [216], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;

%Fiber 51 ds[233;234;235;236;237] spl[60;70;80;50;40]------------------------------------------------------------------------
D1=struct([]);D2=struct([]);D3=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [233;235], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [234], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [234;236], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [233], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;
%MBL of 50 dB
%60dB tov 40 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [233;237], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D3 = [D3; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%50dB SAC
List = GenWFList(struct([]), 'A0242', [236], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D3 = [D3; ExtractPSentry(T, XFieldName, YFieldName)];
%40dB tov 60 dB
D3(3)=D3(1);D3(3).yval=-(D3(1).yval);D3(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval');concatto1Row(D3,'xval','yval')];clear D1;clear D2;clear D3;


%Fiber 52 ds[241;242;243] spl[70;80;60]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [242;243], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [241], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%Fiber 63----------SPLS:[70;60;50;40] for datasetnrs[280;281;282;283]---------------------------------------------------------
D1=struct([]);
D2=struct([]);
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [280;282], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [281], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;
%MBL of 50 dB
%60dB tov 40 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [281;283], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%50dB SAC
List = GenWFList(struct([]), 'A0242', [282], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%40dB tov 60 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=40;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;


%Fiber 76 
%interaural correlation +1-----------------------[318;319;320] subseq [1;1;1] for SPLS[70;60;50]
D1=struct([]);
%MBL of 60 dB
%70dB tov 50dB
ref=2;
List = struct('filename','A0242','iseqp',num2cell([318,320]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; filterspl(concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval'),ref)];
%60dB SAC
List = struct('filename','A0242','iseqp',num2cell([319]),'isubseqp',num2cell([1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60]));
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');
D1 = [D1; concatto1Row(ExtractPSentry(T, XFieldName, YFieldName),'xval','yval')];
%50dB tov 70dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval')];



%Fiber 86 ds[351;352;353] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [352;353], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [351], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%Fiber 89 ds[364;365;366] spl[70;60;80]--------------------------------------------------------------------------------------
D1=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [365;366], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [364], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');      
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;

D=[D;concatto1Row(D1,'xval','yval')];clear D1;


%Fiber 93----------dsnrs:[378;379;380;381] for spls[70;60;50;80]-------!!CF has to be adjusted for this fiber (see book and pslatgen_all
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [379;381], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [378], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [378;380], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [379], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;

if 0
%A0428----------!Most fibers of A0428 are not ready to use because SPL is varied in steps of 20dB instead of 10 dB! (see above)
%----------------------------------------------------------------------------------------------------------------------------

%Fiber 51----------dsnrs:[378;379;380;381] for spls[70;60;50;80]
D1=struct([]);
D2=struct([]);
%MBL of 70 dB
%80dB tov 60 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [379;381], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                     
D1 = [D1; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%70dB SAC
List = GenWFList(struct([]), 'A0242', [378], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                        
D1 = [D1; ExtractPSentry(T, XFieldName, YFieldName)];
%60dB tov 80 dB
D1(3)=D1(1);D1(3).yval=-(D1(1).yval);D1(3).xval=60;
%MBL of 60 dB
%70dB tov 50 dB
ref=2;
List = GenWFList(struct([]), 'A0242', [378;380], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, ref, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                    
D2 = [D2; filterspl(ExtractPSentry(T, XFieldName, YFieldName),ref)]; 
%60dB SAC
List = GenWFList(struct([]), 'A0242', [379], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = GenWFPlot(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no');                       
D2 = [D2; ExtractPSentry(T, XFieldName, YFieldName)];
%50dB tov 70 dB
D2(3)=D2(1);D2(3).yval=-(D2(1).yval);D2(3).xval=50;

D=[D;concatto1Row(D1,'xval','yval');concatto1Row(D2,'xval','yval')];clear D1;clear D2;
end
%-------------------------------------------------------------------------------------------------------------------
nd=numel(D);

%add field 'dsnr' to D (contains dsnr of iseqp, or of iseqn (if iseqp is NaN))
D(1).dsnr = NaN;
for i=1:nd
    if ~isnan(D(i).ds1.iseqp), D(i).dsnr=D(i).ds1.iseqp;
    else D(i).dsnr=D(i).ds1.iseqn;
    end
end

%add new field 'fibernr' to D
D(1).fibernr = NaN;
Args = num2cell(getfnr(structfield(D,'ds1.filename'),structfield(D,'dsnr')));
[D.fibernr] = deal(Args{:});

%add field 'MBL','slope' to D and fill them
D(1).MBL = NaN;D(1).cf=NaN;D(1).slope=NaN;
for i=1:nd
    x=D(i).xval; D(i).MBL=x(2);
    y=D(i).yval; 
    %this is ok as long as three spls are used, and the middle one is the value of the 'constant MBL'
    p=polyfit([x(2), x(1)],[y(2), (y(1)/2)],1);
    D(i).slope=p(1)*1000;
end


%create resulting struct array M, in which one row stands for one fiber,
%with fields filename,fibernr,MBL,slope
DMBL=struct('filename',structfield(D,'ds1.filename'), 'fibernr',...
    num2cell(structfield(D,'fibernr')),'MBL',num2cell(structfield(D,'MBL')), 'slope', num2cell(structfield(D, 'slope')));
%concatenate fields MBL and slope in M
DMBL=groupandconcat(DMBL,'MBL','slope');

%add new field 'cf' to DMBL and fill it
DMBL(1).cf=NaN;
for i=1:numel(DMBL)
    %try-catch construction used to handle fiber 93 of A0242, for which there is no threshold-curve saved,
    %the right thresholdcurve is said to belong to fiber 92
    try, g = getCF4Cell(DMBL(i).filename, DMBL(i).fibernr); DMBL(i).cf = g.thr.cf;
    catch, 
        if isequal(DMBL(i).filename, 'A0242') & isequal(DMBL(i).fibernr, 93)
                DMBL(i).cf = 1216;
        end
    end
end



%-----------------------------------------------------------------
save(mfilename, 'DMBL','D');
%-----------------------------------------------------------------
%plotting delays as a function of non-reference-levels
groupplot(D, 'xval', 'yval');
hold on;
xlabel('Non-reference level (dB)');
ylabel('Delay (ms)');
title('Groupplot generated by psTRifvMBL');
axis([40 90 -0.5 0.5]);
hold off;

%plotting slopes as a function of 'mean binaural level'
groupplot(DMBL, 'MBL', 'slope');
hold on;
xlabel('"Mean binaural level" (dB)');
ylabel('Slope (microsec/dB)');
title('Groupplot generated by psTRifvMBL');
axis([40 90 0 30]);
hold off;

echo off;