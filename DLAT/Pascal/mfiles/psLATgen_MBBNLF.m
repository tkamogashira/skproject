% psLATgen_MBBNLF
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains broadband noise-data from low frequency fibers from all monkeys available to me (see filenames below)
% a fiber is considered 'good' as the threshold was below 21dB and CF below 5000 Hz.
%
% also in this version, in the resulting struct array DLAT, three fields are added, 'slope', 'cf' and 'fibernr'
% containing respectively the slope (as estimated using linear regression with polyfit()),
% the number of the fiber and the characteristic frequency
%
% two types of delay have to be discerned: fine structure-delay (computed by Tf, by limiting the correlation lag to +/- 400 microsec) and enveloppe-delay (computed by T). Each fiber
% has to rows in struct array DLAT: the first contains in field yval the envelope-delay, the second contains fine structure-delay
% in field yval.
%
% a (delay,intensity), staggered by CF (scaling factor defined by SFe en Sff (in Hz/ms), for envelope and
% finestructure-delay, respectively) - and a (slope,cf)-plot are made
% TF 09/09/2005

echo on;

D = struct([]);

% fields that need to be retrieved
XFieldName = 'ds2.discernvalue';
YFieldName = 'primpeak.delay';
ppnm = 'primpeak.normmagn';
spd = 'secpeaks.delay';
spnm = 'secpeaks.normmagn';
lagfn = 'lag';
normcofn = 'normco';

%smoothing and spline factor
smoothing = 3;
spline = 10;
                

% scaling factors for envelope delay-intensity-curve and finestructure delay-intensity curve
SFe = 10000;
SFf = 10000;

if 0
%M0308, M0312, M0313,C, M0314,B, M0315,B,C,D, M0317, M0318, M0319, M0322,C: no good fibers


 %the fibers other than those of M0542 are commented out for the moment, because the individual WFplots and book entries
    % are not looked at yet.
    
%M0322B--------------------------------------------------------------------------------------------------------------
if 0 %see WFplot, no finestructure time-info present => not really 'low-frequent'
%Fiber 23 (no difcors used, see evalsacxac), therefore only responses to interaural correlation +1 used
%interaural correlation +1
List = struct('filename','M0322B','iseqp',num2cell([15,16,17,18,19,20]),'isubseqp',num2cell([1,2,1,1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,30,40,60,80]));               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 15
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 15
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval'); concatto1Row(ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval')];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 


%interaural correlation -1
List = struct('filename','M0322B','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([15,16,17,18,19,20]),'isubseqn',num2cell([2,1,2,2,2,1]),'discernvalue',num2cell([70,50,30,40,60,80]));               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 15
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 15
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval'); concatto1Row(ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval')];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 
end

%M0401-----------------------------------------------------------------------------------------------------------------------
%Fiber 15
List = GenWFList(struct([]), 'M0401', [40;41], [+1, -1], 'discernvalue',...
    'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 40   
Tf = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 40 
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%M0402, M0403,B,C,D,M0415,B, M0416,B,C: no good fibers

                                                                                                                        
%M0540------------------------------------------------------------------------------------------------------------------------
%Fiber 14 (!multiple thr)
List = GenWFList(struct([]), 'M0540', [69;79], [+1, -1], 'discernvalue',...
    'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', ...
    'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 69  
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', ...
    'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 69  
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%Fiber 21
List = GenWFList(struct([]), 'M0540', [96;97;98], [+1, -1], 'discernvalue',...
    'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 96     
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 96
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%M0540B--------------------------------------------------------------------------
%Fiber 45
List = GenWFList(struct([]), 'M0540B', [20;21], [+1, -1], 'discernvalue',...
    'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 20    
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 20   
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%M0541, M0541B, M0541C
%Fiber 29
List = GenWFList(struct([]), 'M0541', [240;241;242;243], [+1, -1], 'discernvalue',...
    'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 20    
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', ...
    'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 20   
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 


                                                                                                                                            
%M0542, M0542B, M0542C---------------------------------------------------------------------------------------------------------
%Fiber 5
List = GenWFList(struct([]), 'M0542', [74;75;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 74                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 74 
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%Fiber 7 (broad thr-curve)
List = GenWFList(struct([]), 'M0542', [120;121;122;123;124], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 120                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 120 
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%Fiber 11
List = GenWFList(struct([]), 'M0542', [150;161;162;163;164], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 150                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 150 
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all; 

%Fiber 12
List = GenWFList(struct([]), 'M0542', [175;176;177;178], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 175                       
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 175
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 23
List = GenWFList(struct([]), 'M0542', [293;294;295], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 293                       
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 293                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 24
List = GenWFList(struct([]), 'M0542', [316;317;318], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 316                       
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 316                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;


%Fiber 31
List = GenWFList(struct([]), 'M0542', [351;352], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); % reference = ds 351                       
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 351                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];%groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;


%Fiber 50 and further: high TH
end

%M0543, M0543B, M0543C------------------------------------------------------------------------------------------------------------------------------------
%Fiber 8 (bad threshold)
List = GenWFList(struct([]), 'M0543', [11;12;13;14], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 11                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 11                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 10 (bad threshold)
List = GenWFList(struct([]), 'M0543', [16;17;18;19;20], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 18                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 18                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 12 (bad threshold)
List = GenWFList(struct([]), 'M0543', [23;24;25;26], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 23                       
Tf = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 23                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 25 (use dataset 9 (50 repetitions) or dataset 10 (100 repetitions) for 30 dB?)
List = GenWFList(struct([]), 'M0543B', [3;4;5;6;7;8;10], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 3                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 3                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 26 (dataset 21 (20dB) not usable - use 50 or 100 repetitions for 30 dB?)
List = GenWFList(struct([]), 'M0543B', [12;13;14;15;16;17;20], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 12                       
Tf = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 12                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%Fiber 27
List = GenWFList(struct([]), 'M0543B', [23;24], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 23                       
Tf = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline,'cormaxlag',0.4); % reference = ds 23                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm); ExtractPSentryTF(Tf, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval', 'yval','xlim',[30 90],'ylim',[-1 0.7]);pause;close all;

%---------------------------------------------------------------------------------------------------------------------------------------                                                                                                                                             
echo off;                                                                                                                                         
                                                                                       
%-----------------------------------------------------------------                                                                                                                                              
nd=numel(D);

%add new field 'fibernr' to D and fill it
D(1).fibernr=NaN;
for i=1:nd
    % try-catch-construction used to handle rows of DLAT that have NaN for ds1.iseqp or ds1.iseqn
    try, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqp);
    catch, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqn);
    end
end

%add new field 'slope' to D and fill it
D(1).slope = NaN;
Args = num2cell(getTRatios(D));
[D.slope] = deal(Args{:});

%add new field 'envdelay' to D and fill it (field that shows which delays are envelope- and which are finestructure-related (resp. values 1 and 0 in the field)
D(1).envdelay=NaN;
for i=1:nd
    if mod(i,2)==0, D(i).envdelay=0;
    else D(i).envdelay=1;
    end
end

%add new fields 'cf' and 'yvalscaledtocf' to D and fill them
D(1).cf=NaN;D(1).yvalscaledtocf=NaN;
for i=1:nd
    g = getCF4Cell(D(i).ds1.filename, D(i).fibernr);
    D(i).cf = g.thr.cf;
    if D(i).envdelay == 0, D(i).yvalscaledtocf=SFf*(D(i).yval)+(D(i).cf);
    else, D(i).yvalscaledtocf=SFe*(D(i).yval)+(D(i).cf);
    end
end                                                                                                                                                                                     

%add new field 'difcor' to D and fill it
D(1).difcor=NaN;
for i=1:nd
    if (~isnan(D(i).ds1.iseqn))&(~isnan(D(i).ds1.iseqp)), D(i).difcor=1;
    else, D(i).difcor=0;
    end
end



%-----------------------------------------------------------------
DLAT = D; clear('D');
save(mfilename, 'DLAT');
%-----------------------------------------------------------------
Ddifenv=structfilter(DLAT, '($difcor$ == 1)&($envdelay$ == 1)');
Ddiffine=structfilter(DLAT, '($difcor$ == 1)&($envdelay$ == 0)');
Dnondifenv=structfilter(DLAT, '($difcor$ == 0)&($envdelay$ == 1)');
Dnondiffine=structfilter(DLAT, '($difcor$ == 0)&($envdelay$ == 0)');

%groupplot envelope delay as a function of intensity (there is no nondif-data for the moment!)
groupplot(Ddifenv, 'xval', 'yvalscaledtocf');
hold on;
xlabel('Intensity (dB SPL)');
ylabel('CF (Hz)');
title('Plot-(envelope delay,intensity) for monkey-BBN-LF');
% Plotting delay-unit box
% Calculate sizes of current axis ...
A=axis; XRng=A(1:2); YRng=A(3:4);
Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
%Find coordinates of lower left corner ...
[Xllc, Yllc] = deal(XRng(1) + 0.050*Xsize, YRng(1) + 0.025*Ysize);
%Find width and height of box ...
[Width, Height] = deal(0.005*Xsize, 1*(SFe/5));
%Plot unitbox ...
rectangle('Position', [Xllc, Yllc, Width, Height], 'EdgeColor', 'k', ...
    'FaceColor', [1 1 1], 'LineStyle', '-');
rectangle('Position', [Xllc, Yllc, Width, Height/2], 'EdgeColor', 'k', ...
    'FaceColor', [0 0 0], 'LineStyle', '-');
%Plot legend ...
text(Xllc+Width+0.010*Xsize, Yllc, '0.0', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+(Height/2), '0.1', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+Height, '0.2', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc-0.02*Xsize, Yllc+0.2*Height,'Delay (ms)', 'fontsize', 10, 'fontweight', 'normal', 'Rotation', 90);
hold off;
%Show scaling factor
text(XRng(2) - 0.2*Xsize, Yllc, ['current SF: ' num2str(SFe) ' Hz/ms'], 'fontsize', 10, 'fontweight', 'light');

%groupplot fine structure delay as a function of intensity (there is no nondif-data for the moment!)
groupplot(Ddiffine, 'xval', 'yvalscaledtocf');
hold on;
xlabel('Intensity (dB SPL)');
ylabel('CF (Hz)');
title('Plot-(finestructure delay,intensity) for monkey-BBN-LF');
% Plotting delay-unit box
% Calculate sizes of current axis ...
A=axis; XRng=A(1:2); YRng=A(3:4);
Xsize = abs(diff(XRng)); Ysize = abs(diff(YRng));
%Find coordinates of lower left corner ...
[Xllc, Yllc] = deal(XRng(1) + 0.050*Xsize, YRng(1) + 0.025*Ysize);
%Find width and height of box ...
[Width, Height] = deal(0.005*Xsize, 1*(SFf/5));
%Plot unitbox ...
rectangle('Position', [Xllc, Yllc, Width, Height], 'EdgeColor', 'k', ...
    'FaceColor', [1 1 1], 'LineStyle', '-');
rectangle('Position', [Xllc, Yllc, Width, Height/2], 'EdgeColor', 'k', ...
    'FaceColor', [0 0 0], 'LineStyle', '-');
%Plot legend ...
text(Xllc+Width+0.010*Xsize, Yllc, '0.0', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+(Height/2), '0.1', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc+Width+0.010*Xsize, Yllc+Height, '0.2', 'fontsize', 5, ...
    'fontweight', 'light');
text(Xllc-0.02*Xsize, Yllc+0.2*Height,'Delay (ms)', 'fontsize', 10, 'fontweight', 'normal', 'Rotation', 90);
hold off;
%Show scaling factor
text(XRng(2) - 0.2*Xsize, Yllc, ['current SF: ' num2str(SFf) ' Hz/ms'], 'fontsize', 10, 'fontweight', 'light');

%groupplot slopes as a function of cf (there is no nondif-data for the moment!)
groupplot(Ddiffine, 'cf', 'slope',Ddifenv,'cf','slope','markers',{'o','*'},'colors',{'b','r'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (microsec/dB)');
title('Plot-(cf,slope) for M0542');
line([0,30000], [0,0]);
hold off;