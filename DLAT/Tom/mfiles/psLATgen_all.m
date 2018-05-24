% psLATgen_all
% popscript to study effect of SPL on delay
% PXJ 8/2005
%
% this version of the script contains data from A0241, A0242, A0428, A0454, A0306, A0307
% * as extracted out of DSACXAC with DSACXACextractor (a list generated with psSACXAC)
% * manually adjusted (if there are multiple sets at the same spl, DSACXACextractor automatically picks the last one --> if other ones
% were better, I replaced them)
% * manually added (NRHO-data at one interaural correlation, usable NSPL-data, some high cf-fibres)
% why some fibers were not used is explained in the code
% TF 29/08/2005
% 
% also in this version, in the resulting struct array DLAT, four fields are added, 'slope', 'cf','fibernr','difcor'
% containing respectively the slope (as estimated using linear regression with polyfit(),
% the number of the fiber, the characteristic frequency, and if the delays are obtained using difcors (1) or not (0).
%
% while the popscript runs, a WFplot can be made (change 'no' in 'no'), and a plot (delay,intensity) is made for the current fiber.
%
%
% two groupplots are made:
%   * delay as a function of intensity
%   * slope as a function of characteristic frequency
% the groupplots contain different symbols and colors for delays obtained by difcors (in blue and with 'o')  
% and delays obtained for data where only one interaural correlation is available (in red and with '*').
% TF 02/09/2005
% 

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
                                                                                                                                             
%A0306--------------------------------------------------------------------------------------------------------------                                                                                                                                              
%Fiber 4
List = GenWFList(struct([]), 'A0306', [27;28], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 27                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 6
List = GenWFList(struct([]), 'A0306', [41;40], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 40                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 7
List = GenWFList(struct([]), 'A0306', [51;52;53], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 51                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 8
List = GenWFList(struct([]), 'A0306', [60;61;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 60                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 10
List = GenWFList(struct([]), 'A0306', [105;106;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 105                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 11
List = GenWFList(struct([]), 'A0306', [123;124;125], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 123                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 13
List = GenWFList(struct([]), 'A0306', [168;169;170], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 168                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 17
List = GenWFList(struct([]), 'A0306', [213;214;215], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 213                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 24
List = GenWFList(struct([]), 'A0306', [244;245;246], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 244                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 25
List = GenWFList(struct([]), 'A0306', [264;265;266], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 264                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 29
List = GenWFList(struct([]), 'A0306', [295;296;297], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 295                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 31
List = GenWFList(struct([]), 'A0306', [319;320;321], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 319                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 33
List = GenWFList(struct([]), 'A0306', [327;328;329], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 327                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 35
List = GenWFList(struct([]), 'A0306', [348;349;350], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 348                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 38
List = GenWFList(struct([]), 'A0306', [385;386;387], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 385                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 41, high cf
List = struct('filename','A0306','iseqp',num2cell([405,406,407]),'isubseqp',num2cell([1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 405                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 44
List = GenWFList(struct([]), 'A0306', [453;454;455], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 453                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 47
List = GenWFList(struct([]), 'A0306', [472;473;474], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 472                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 48
List = GenWFList(struct([]), 'A0306', [502;503], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 502                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 49
List = GenWFList(struct([]), 'A0306', [525;526;527], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 525                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 50 (!see ds 544: interaural corr -1 beetje onvolledig)
List = GenWFList(struct([]), 'A0306', [543;544], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 543                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 51
List = GenWFList(struct([]), 'A0306', [553;554;555], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 553                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;


%A0307--------------------------------------------------------------------------------------------------------------
%Fiber 4, high cf
List = struct('filename','A0307','iseqp',num2cell([8,9]),'isubseqp',num2cell([2,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 8                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0%Fiber 5 (bad thr)
List = GenWFList(struct([]), 'A0307', [12;13], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 12                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 6 (bad thr?)
List = GenWFList(struct([]), 'A0307', [18;19], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 18                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 7 (bad thr?)
List = GenWFList(struct([]), 'A0307', [25;26;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 25                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 8 (bad thr?)
List = GenWFList(struct([]), 'A0307', [47;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 47                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 14
List = GenWFList(struct([]), 'A0307', [67;68], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 67                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 15
List = GenWFList(struct([]), 'A0307', [75;76], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 75                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 17
List = GenWFList(struct([]), 'A0307', [85;86], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 85                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 29 (weird thr-curve)
List = GenWFList(struct([]), 'A0307', [140;141], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 141                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 30
List = GenWFList(struct([]), 'A0307', [168;169], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 168                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 32
List = GenWFList(struct([]), 'A0307', [205;206;207], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 205                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 43
List = GenWFList(struct([]), 'A0307', [280;281;282], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 280                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 45
List = GenWFList(struct([]), 'A0307', [293;294;295], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 293                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %(see dot raster: ds 311 not good) 
%Fiber 48
List = GenWFList(struct([]), 'A0307', [310;311], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 310                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 50
List = GenWFList(struct([]), 'A0307', [325;328;332], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 325                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0
%Fiber 51 (see dot raster: ds 369 not good)
List = GenWFList(struct([]), 'A0307', [368;369], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 368                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 53
List = GenWFList(struct([]), 'A0307', [372;373;374], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 372                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0
%Fiber 54 (bad thr)
List = GenWFList(struct([]), 'A0307', [387;388;389], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 387                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 55(bad thr?)
List = GenWFList(struct([]), 'A0307', [404;405;406], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 404                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 56 (bad thr?)
List = GenWFList(struct([]), 'A0307', [419;420;421], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 419                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %bad thr
%Fiber 57
List = GenWFList(struct([]), 'A0307', [429;430;431], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 429                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 58
List = GenWFList(struct([]), 'A0307', [444;445;446], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 444                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %bad thr
%Fiber 60
List = GenWFList(struct([]), 'A0307', [472;473], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 472                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 61
List = GenWFList(struct([]), 'A0307', [486;487;488], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 486                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 62 (ds 495 not good)

%Fiber 64
List = GenWFList(struct([]), 'A0307', [498;499;500], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 498                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 65
List = GenWFList(struct([]), 'A0307', [517;519;520], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 517                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 66
List = GenWFList(struct([]), 'A0307', [530;531;532], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 530                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %bad thr
%Fiber 69
List = GenWFList(struct([]), 'A0307', [579;580], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 579                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 70 (ds 583 not good)

if 0
%Fiber 73 (bad thr)
List = GenWFList(struct([]), 'A0307', [601;602], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 601                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0
%Fiber 74 (bad thr)
List = GenWFList(struct([]), 'A0307', [618;619;620], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 618                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end


%Fiber 77 (ds 642 not good, see dot raster)

if 0 %bad thr
%Fiber 79
List = GenWFList(struct([]), 'A0307', [656;657], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 656                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end
    
%Fiber 81 (should ds 666 or ds 669 be chosen as NRHO @ 70 dB?)
List = GenWFList(struct([]), 'A0307', [666;667;668], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 666                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 82, high cf
List = struct('filename','A0307','iseqp',num2cell([675,676,677]),'isubseqp',num2cell([2,1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 82                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 83 (bad thr)

%Fiber 88 (ds 701 not good)
List = GenWFList(struct([]), 'A0307', [699;700], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 699                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 91
List = GenWFList(struct([]), 'A0307', [707;708], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 707                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 92, high cf
List = struct('filename','A0307','iseqp',num2cell([710,711,712]),'isubseqp',num2cell([1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 710                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 94, high cf
List = struct('filename','A0307','iseqp',num2cell([715,716]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 715                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %bad thr
%Fiber 96 (choose ds 721 or ds722 for 90 dB?)
List = GenWFList(struct([]), 'A0307', [720;721], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 720                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0%bad thr
%Fiber 99
List = GenWFList(struct([]), 'A0307', [729;730;731], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 729                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0%bad thr
%Fiber 100
List = GenWFList(struct([]), 'A0307', [733;734], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 733                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 101 (bad thr?)
List = GenWFList(struct([]), 'A0307', [738;739], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 738                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 103
List = GenWFList(struct([]), 'A0307', [744;745;746], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 744                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 104 (choose ds 749 or 751 for 90 dB?)
List = GenWFList(struct([]), 'A0307', [748;749;750], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 748                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 110, high cf
List = struct('filename','A0307','iseqp',num2cell([775,776,777]),'isubseqp',num2cell([2,2,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 775                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 111 (ds 782 not good at interaural correlation -1), high cf
List = struct('filename','A0307','iseqp',num2cell([781,782]),'isubseqp',num2cell([2,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 781                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 112 (choose 786 or 787 for 90dB?), high cf
List = struct('filename','A0307','iseqp',num2cell([785,786,788]),'isubseqp',num2cell([2,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 785                   

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%A0241--------------------------------------------------------------------------------------------------------------                                                                                                                
%Fiber 10                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [15;16;17], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 15                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
                                                                                                                                              
%Fiber 17                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [30;31;32;33], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 30                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 18                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [35;36;37;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 35                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 19                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [41;42;43;44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 42                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 20                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [47;48;49;50;52], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 47                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 21                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [54;55;56;58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 54                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 23                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [64;65;66], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 64                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 25                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [70;71;73], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 70                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 29, high cf (added NSPL-data)
%responses to interaural correlation +1
List = struct('filename','A0241','iseqp',num2cell([-47,-47,-45,-45,-45]),'isubseqp',num2cell([1,2,1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -45, subseq 2

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
%responses to interaural correlation -1
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46,-46,-46,-46]),'isubseqn',num2cell([1,2,3,4,5]),'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -46, subseq 4                       

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;


%Fiber 30, high cf (added NSPL-data)
List = struct('filename','A0241','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-49,-49,-49]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -49, subseq 3                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 31, high cf (added NSPL-data)
% interaural correlation +1
List = struct('filename','A0241','iseqp',num2cell([-50,-50,-50,-50]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -50, subseq 3                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
% interaural correlation -1
List = struct('filename','A0241','iseqp',num2cell([-51,-51,-51,-51]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -51, subseq 3                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 33, added (datasets 89 and 90 are not good enough to use)
List = GenWFList(struct([]), 'A0241', [87;88], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 87                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 35                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [95;96;97;99], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 95                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 37                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [104;105], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 105                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           

%Fiber 38, high cf                                                                                                                                     
List = struct('filename','A0241','iseqp',num2cell([-66,-66]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -66, subseq 2                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 39, added NSPL data
List = struct('filename','A0241','iseqp',num2cell([-67,-67,-67,-67]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -67, subseq 3                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 42                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [114;115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 114                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 47                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [123;124;125], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 123                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 48                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [128;129;130], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 128                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %not good (see WF-plot)
%Fiber 49, high cf
List = struct('filename','A0241','iseqp',num2cell([-78,-78,-78,-78]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',num2cell([-79,-79,-79,-79]),'isubseqn',num2cell([1,2,3,4]),'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -78/-79, subseq 3                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0 %not good (see WF-plot)
%Fiber 50, high cf
List = struct('filename','A0241','iseqp',num2cell([-84,-84,-84,-82,-82,-82,-82]),'isubseqp',num2cell([1,2,3,1,2,3,4]),...
    'iseqn',num2cell([-85,-85,-85,-83,-83,-83,-83]),'isubseqn',num2cell([1,2,3,1,2,3,4]),'discernvalue',num2cell([20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds -82/-83, subseq 3                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 55                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [179;180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 179                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 64                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [195;196], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 195                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 65                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [198;199], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 198                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 67                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [208;209;210], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 208                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 % high threshold
%Fiber 69, added (only responses to +1 interaural correlation noise used)
List = struct('filename','A0241','iseqp',num2cell([214,215]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = 215                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0 % (broken spike? - see book + see WFplot)
%Fiber 70, added
List = GenWFList(struct([]), 'A0241', [217;218;219;220], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 217                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 71, high cf
List = GenWFList(struct([]), 'A0241', [229;230], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 229                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
                                                                                                                                              
%Fiber 72 (!see databrowse and book: the seond thr-curve saved as belonging to fiber 72 is probably from another fiber, therefore
%the value of cf for this fiber has to be manually adjusted (see below))
List = GenWFList(struct([]), 'A0241', [232;233], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 232                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;    

%Fiber 81, high cf                                                                                                                                    
List = GenWFList(struct([]), 'A0241', [260;261], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 260                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all; 
                                                                                                                                              
%Fiber 82                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [263;264;265], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 263                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 83                                                                                                                                     
List = GenWFList(struct([]), 'A0241', [267;268], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 267                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           


%A0242--------------------------------------------------------------------------------------------------------------
%Fiber 1                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [2;3;4], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 2                        

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           

%Fiber 2                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [9;10;11;12], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');             
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 9                        

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           

%Fiber 4, added
List = struct('filename','A0242','iseqp',num2cell([15,17]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 15                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 7, added
List = struct('filename','A0242','iseqp',num2cell([20,21]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 20                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 8                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [23;24;25;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 23                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 9                                                                                                                                      
List = GenWFList(struct([]), 'A0242', [30;31;32], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 30                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 10                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [34;35;36], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 34                       

D= [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 11                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [40;41;42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 40                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 12                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [44;45;46;47;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 44                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 13                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [50;51;52;53], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 50                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 14                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [56;57;58], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 58                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 17                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [64;66;67;72], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 64                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 18                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [75;78;79], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 75                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 19                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [83;84], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 83                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 20                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [88;90;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 88                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 21                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [93;94;95], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 93                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 22                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [97;98], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 97                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 25                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [106;109;110], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 106                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 26                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [113;115;116], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 113                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 28                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [120;121;122], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 120                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 31                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [129;130;131], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 129                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 32                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [134;135], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 134                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 33                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [137;138;139], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 137                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 34                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [142;143;144;146], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 142                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 37                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [155;156;157;160], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 155                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 44                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [179;180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 179                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %see WFplot
%Fiber 45, added
List = struct('filename','A0242','iseqp',num2cell([185,186]),'isubseqp',num2cell([1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 185                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

%Fiber 47 (ds 192 added)                                                                                                                                    
List = GenWFList(struct([]), 'A0242', [191;192;195;197], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 191                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 48                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [202;203;204;207], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 202                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 49                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [211;216;217], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 211                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 51                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [233;234;235;236;237], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 234                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 52                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [241;242;243], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 241                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 63                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [280;281;282;283], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 280                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 76                                                                                                                                     
List = struct('filename','A0242','iseqp',num2cell([318,319,320]),'isubseqp',num2cell([1,1,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60,50]));
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 318                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 82                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [336;337], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 336                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 85                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [343;345], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 343                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 86                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [351;352;353], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 351                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 88                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [358;359], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 358                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 89                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [364;365;366], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 364                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 90                                                                                                                                     
List = GenWFList(struct([]), 'A0242', [369;371], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 369                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 93 (!see book: ds 377 and ds 378 (both saved under fiber 92) are really datasets of fiber 93) 
List = GenWFList(struct([]), 'A0242', [378;379;380;381], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 378                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%A0428--------------------------------------------------------------------------------------------------------------
%Fiber 6                                                                                                                                      
List = GenWFList(struct([]), 'A0428', [66;76], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 66                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 7                                                                                                                                      
List = GenWFList(struct([]), 'A0428', [79;90;91], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 79                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 11                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [159;160;161], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 159                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 12                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [218;219;220], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 218                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 13                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [239;240;241], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 239                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
 
if 0 %high threshold
%Fiber 17 (dataset 277 added)                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [275;276;277], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 275                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
end                 

%Fiber 18                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [279;280;281], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 279                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 19                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [313;314], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 313                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 20                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [368;369;370], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 368                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 21                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [375;376;377;378], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 375                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 22                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [393;394;395], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 393                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 23                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [408;409], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 408                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 36                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [468;469;470;471], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 468                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 42                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [479;480;481], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 479                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 43                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [484;485], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 484                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 44                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [487;488], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 487                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 46                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [492;493;494], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 492                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 48                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [497;498;499], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 497                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 49                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [501;502;503], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 501                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 50                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [505;506], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 505                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 51                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [508;509;510;512;513], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 508                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 52                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [515;516;517], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 515                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 53 added (only interaural correlation -1 available)
List = struct('filename','A0428','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([519,520]),'isubseqn',num2cell([2,1]),'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 519                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

%Fiber 54: ds 523 not good (cfr SAC)


%Fiber 55                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [525;526], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 525                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 57                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [530;531;532;533;534], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');    
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 530                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 59                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [537;538;539], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 537                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 60                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [541;542;543], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 541                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 61                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [545;546], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 545                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 62                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [548;549;550;551], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 548                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 64                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [555;556], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 555                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 66                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [560;561;562], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 560                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 68                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [565;566;567], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 565                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 70                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [571;572], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 571                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 71                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [574;575;576], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 574                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 73                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [579;580], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 579                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 74                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [582;583;584], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 582                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 75                                                                                                                                     
List = GenWFList(struct([]), 'A0428', [586;587], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 586                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           

%A0454--------------------------------------------------------------------------------------------------------------
%Fiber 5                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [13;14], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 13                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 6                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [17;18;19;21], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 17                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 9                                                                                                                                      
List = GenWFList(struct([]), 'A0454', [37;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 37                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 10                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [40;41], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                  
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 40                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 13                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [47;48;49;50;51], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');         
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 47                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

if 0 %see WFplot
%Fiber 18, high cf
% interaural correlation -1
List = struct('filename','A0454','iseqp',num2cell([63,64,65,66]),'isubseqp',num2cell([2,1,1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 63                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% interaural correlation +1
List = struct('filename','A0454','iseqp',num2cell([63,64,65,66]),'isubseqp',num2cell([1,2,2,1]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50,90,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 63                      

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
end

if 0 %(WFplot not smooth enough)
%Fiber 32                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [93;94;95;96], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 93                       

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
end

%Fiber 34                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [104;105;106;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 104                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 35                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [109;111;112;113], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 109                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 36                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [116;118;119], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 3, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 116                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 40                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [131;132;133;134], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 131                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 41                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [139;140;141;142;143;144], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 140                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 44                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [150;151;152], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 150                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           


if 0 %double triggers
%Fiber 45                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [155;156], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 155                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
end

%Fiber 47                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [163;164;165], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 163                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 48                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [173;174;175;176], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 173                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 58                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [198;197], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 198                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 59                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [203;204], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 203                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 68                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [221;222;223;224], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');        
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 221                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 71                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [231;232], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');                
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 231                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 72                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [234;235;236], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 234                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 74                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [241;242;243], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 241                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
%Fiber 75                                                                                                                                     
List = GenWFList(struct([]), 'A0454', [248;249;250;251], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');            
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); % reference = ds 248                      

D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;                                                                                           
                                                                                                                                              
echo off;                                                                                                                                         
                                                                                       
%-----------------------------------------------------------------                                                                                                                                              
nd=numel(D);

%add new field 'fibernr' to D and fill it
D(1).fibernr=NaN;
for i=1:nd
    % try-catch used construction used to handle rows of DLAT that have NaN for ds1.iseqp or ds1.iseqn
    try, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqp);
    catch, D(i).fibernr = getFnr({D(i).ds1.filename},D(i).ds1.iseqn);
    end
end

%add new field 'slope' to D and fill it
D(1).slope = NaN;
Args = num2cell(getTRatios(D));
[D.slope] = deal(Args{:});

%add new field 'cf' to D and fill it
D(1).cf=NaN;
for i=1:nd
    %for fiber 72 of A0241, the wrong thr-curve is chosen for the cf by getcf4cell() --> this cf has to be manually changed:
    if isequal(D(i).ds1.filename, 'A0241')&(D(i).fibernr==72), D(i).cf=2732;
    else,
    g = getCF4Cell(D(i).ds1.filename, D(i).fibernr);
    D(i).cf = g.thr.cf;
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
save('pslatgen_all', 'DLAT');
%-----------------------------------------------------------------

Ddif=structfilter(DLAT, '$difcor$ == 1');
Dnodif=structfilter(DLAT, '$difcor$ == 0');

%groupplot delay as a function of intensity
groupplot(Ddif, 'xval', 'yval', Dnodif, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('Intensity (dB SPL)');
ylabel('Delay (ms)');
title(['Plot-(delay,intensity) for A0241,A0242,A0428,A0454,A0306,A0307']);
hold off;

%groupplot slopes as a function of cf
groupplot(Ddif, 'cf', 'slope', Dnodif, 'cf', 'slope', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (microsec/dB)');
title('Plot-(cf,slope) for A0241,A0242,A0428,A0454,A0306,A0307');
line([0,30000], [0,0]);
hold off;

if 0
%delay-intensityplots in groups defined by CF
Dnodif100 = structfilter(Dnodif, '($cf$>100)&($cf$<=200)');Ddif100 = structfilter(Ddif, '($cf$>100)&($cf$<=200)');
Dnodif200 = structfilter(Dnodif, '($cf$>200)&($cf$<=400)');Ddif200 = structfilter(Ddif, '($cf$>200)&($cf$<=400)');
Dnodif400 = structfilter(Dnodif, '($cf$>400)&($cf$<=800)');Ddif400 = structfilter(Ddif, '($cf$>400)&($cf$<=800)');
Dnodif800 = structfilter(Dnodif, '($cf$>800)&($cf$<=1600)');Ddif800 = structfilter(Ddif, '($cf$>800)&($cf$<=1600)');
Dnodif1600 = structfilter(Dnodif, '($cf$>1600)&($cf$<=3200)');Ddif1600 = structfilter(Ddif, '($cf$>1600)&($cf$<=3200)');
Dnodif3200 = structfilter(Dnodif, '$cf$>3200');Ddif3200 = structfilter(Ddif, '$cf$>3200');

groupplot(Ddif100, 'xval', 'yval', Dnodif100, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]100Hz;200Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp1=gcf;
figure;fig=gcf;putplot(fig,getplot(gp1,2),2,3,1);
groupplot(Ddif200, 'xval', 'yval', Dnodif200, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]200Hz;400Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp2=gcf;
putplot(fig,getplot(gp2,2),2,3,2);
groupplot(Ddif400, 'xval', 'yval', Dnodif400, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]400Hz;800Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp3=gcf;
putplot(fig,getplot(gp3,2),2,3,3);
groupplot(Ddif800, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]800Hz;1600Hz]');xlabel('Intensity (dB SPL)');ylabel('Delay (ms)');gp4=gcf;
putplot(fig,getplot(gp4,2),2,3,4);
groupplot(Ddif1600, 'xval', 'yval', Dnodif1600, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]1600Hz;3200Hz]');gp5=gcf;
putplot(fig,getplot(gp5,2),2,3,5);
groupplot(Ddif3200, 'xval', 'yval', Dnodif3200, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});title('CF ]3200Hz;30000Hz]');gp6=gcf;
putplot(fig,getplot(gp6,2),2,3,6);

close(gp1);close(gp2);close(gp3);close(gp4);close(gp5);close(gp6);
end