% pslatTBcatPM
%                                                                              %
% Included here is Cat TB data based on GenWFPlot.                             %          
% Several datatypes are used: NSPL, NRHO, ...                                  %
% Both high- and low-frequency data from experiments ...                       %
% D0120 (and b, c), D0121 (and b,c), D0202,D0208, D0212, D0215, D0217 ...      %
% D0219, D0408, D0409, D0412, D0413, D0414, ...                                %
% D0418, D0419 and D0419b have been looked at.                                 %
% Only sequences with variations in SPL have been included in this popscript.  %
%                                                                              %
% 02/01/07 PM                                                                  % 
%===============================================================================

%============================================================================|
% tag: 1 = good                                                             ||
%      2 = decent (noisy SAC due to low reps/burstdur,...)                  ||
%      3 = bad (very noisy SAC, bad ISI, bad trigger in rasterplot,...)     ||
%============================================================================|

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


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0120: no NRHObb 
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================


% cell 5: CF = 31.383Hz --------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest intensity subseq
% NSPL
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-9,-9,-9,-9,-9]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,50,40,30,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed lowest intensity subseq
% A-
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-10,-10,-10,-10,-10]),'isubseqn',num2cell([1,2,3,4,5]),'discernvalue',num2cell([60,50,40,30,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% B
% tag 3 (VERY noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-11,-11,-11]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% B-
% tag 3 (VERY noisy SAC)
List = struct('filename','D0120','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-12,-12,-12]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 9: CF = 6373Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 2 (noisy SAC)
List = struct('filename','D0120','iseqp',num2cell([-27,-27,-27]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (VERY noisy SAC, dip in rate curve)
List = struct('filename','D0120','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-28,-28,-28]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                      
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 10: CF = 4204Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 2 (good SAC, ras at 60 dB shows trigger problems. 60dB subseq. removed)
List = struct('filename','D0120','iseqp',num2cell([-39,-39]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % cell 21-----------------------------------------------------------------------------------------------------------------------------------------------------------
% % NSPL
% % no CF
% List = struct('filename','D0120','iseqp',num2cell([-65,-65,-65,-65,-65,-65,-65,-65,-65,-65]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40,30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
% 
% % NSPL
% % no CF
% List = struct('filename','D0120','iseqp',num2cell([-66,-66,-66,-66,-66,-66,-66,-66,-66,-66]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40,30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
% 
% 
% % NSPL
% % no CF
% List = struct('filename','D0120','iseqp',num2cell([-67,-67,-67,-67,-67,-67,-67,-67,-67,-67]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40,30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline);
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
% 
% % NSPL
% % no CF
% List = struct('filename','D0120','iseqp',num2cell([-68,-68,-68,-68,-68,-68,-68,-68,-68,-68]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40,30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0120b
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================


% % cell 30: no CF-------------------------------------------------------------------------------------------------------------------------------------------

% % NSPL
% % tag 1 
% List = struct('filename','D0120b','iseqp',num2cell([-17,-17,-17,-17,-17,-17]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;
% 

% cell 36: CF = 41.18Hz -------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 1
List = struct('filename','D0120b','iseqp',num2cell([-29,-29,-29,-29,-29,-29]),'isubseqp',num2cell([1,2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);

D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % NSPL
% % tag 3 (0, 10 and 20dB: very few spikes)
% List = struct('filename','D0120b','iseqp',num2cell([-30,-30,-30,-30]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% cell 37: CF = 6589Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (only minor noise in SAC)
List = struct('filename','D0120b','iseqp',num2cell([-34,-34,-34,-34,-34]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60,50,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% NSPL
% tag 1 (only minor noise in SAC)
List = struct('filename','D0120b','iseqp',num2cell([-35,-35,-35,-35,-35]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60,50,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % NSPL
% % tag 3 (VERY noisy SAC, very few spikes at 0 and 10dB)
% List = struct('filename','D0120b','iseqp',num2cell([-36,-36,-36,-36]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% cell 38: CF = 14.948Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 3 (VERY noisy SAC, check ISI histogram)
List = struct('filename','D0120b','iseqp',num2cell([-45,-45]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3(VERY noisy SAC, spikes in refractory period ISI histogram!)
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 39: CF= 21.184Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A-
% tag 3 (VERY noisy SAC, spikes in refractory period ISI histogram!)
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-62,-62]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A+
% tag 3 (VERY noisy SAC, spikes in refractory period ISI histogram!)
List = struct('filename','D0120b','iseqp',num2cell([-63,-63]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 40: CF = 21.119Hz -------------------------------------------------------------------------------------------------------------------------------------------

% NSPL LEFT
% tag 3 (clean ISI, clean ras, clean SP. VERY noisy SAC (low reps))
List = struct('filename','D0120b','iseqp',num2cell([-66,-66,-66,-66,-66,-66]),'isubseqp',num2cell([1,2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60,50,40,30,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% commented out: extremely noisy SAC
% % NSPL LEFT
% % tag 3 (clean ISI, clean ras, clean SP. VERY noisy SAC (low reps))
% List = struct('filename','D0120b','iseqp',num2cell([-67,-67,-67,-67,-67,-67,-67,-67]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,60,50,40,30,20,10,0]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% NSPL
% tag 3 tag 3 (clean ISI, ok ras, ok SP. VERY noisy SAC (low reps))
List = struct('filename','D0120b','iseqp',num2cell([-68,-68,-68,-68,-68,-68,-68,-68,-68]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 3 (spikes in refractory period ISI, ok SP, VERY noisy SAC (low reps))
List = struct('filename','D0120b','iseqp',num2cell([-69,-69,-69,-69,-69,-69,-69,-69,-69]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% comment: removed subseq 1 (0 dB)
% NSPL
% tag 2 (clean ISI, ok ras, bad SP (high rate at 0dB), only slight noise in SAC. Leave 0 condition out)
List = struct('filename','D0120b','iseqp',num2cell([-70,-70,-70,-70,-70,-70,-70,-70]),'isubseqp',num2cell([2,3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % warning: only 70 and 80dB subsequences show "normal" SPL responses
% % NSPL
% % tag 3 (bad SP (rate decreases as intensity increases up to 70dB, then increases at 80dB), good SAC except for 70dB)
% List = struct('filename','D0120b','iseqp',num2cell([-71,-71,-71,-71]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% NSPL
% ds -72: error: "cannot load dataset"

% error: "error in subsequence 6"
% NSPL
% tag 3
% List = struct('filename','D0120b','iseqp',num2cell([-73,-73,-73,-73,-73]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,82,84,86,88]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% left sub-70dB subsequences out
% NSPL RIGHT
% tag 3 (no response to 20,30,40,50,60 dB: the only interesting SACs are the 70, 80dB ones.)
List = struct('filename','D0120b','iseqp',num2cell([-74,-74]),'isubseqp',num2cell([6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% warning: slight decrease in rate as SPL increases
% NSPL
% tag 2 (rate decreases as SPL increases, minor noise in SACs)
List = struct('filename','D0120b','iseqp',num2cell([-75,-75,-75,-75,-75]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% warning: slight decrease in rate as SPL increases
% NSPL
% tag 2 (rate decreases as SPL increases, minor noise in SACs)
List = struct('filename','D0120b','iseqp',num2cell([,-76,-76,-76,-76,-76]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 2 (only minor noise in SAC)
List = struct('filename','D0120b','iseqp',num2cell([,-77,-77,-77,-77,-77]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% warning: slight decrease in rate as SPL increases
% NSPL 
% tag 2 (rate decreases as SPL increases, minor noise in SACs)
List = struct('filename','D0120b','iseqp',num2cell([,-78,-78,-78]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % removed subsequence 6: error: "error in subsequence 6"
% % NSPL
% % tag 3
% List = struct('filename','D0120b','iseqp',num2cell([-79,-79,-79,-79,-79]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,82,84,86,88]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;
 
% % % removed subsequence 6: error: "error in subsequence 6"
% % NSPL
% % tag 3
% List = struct('filename','D0120b','iseqp',num2cell([-80,-80,-80,-80,-80]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,82,84,86,88]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline);
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;


% cell 44: CF = 3500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: while the peakshifts are clear, the SACs are extremely noisy
% % NSPL
% % tag 3 (VERY noisy SAC, no rate at 0,10 and 20dB: subseq 0, 10 and 20dB removed)
% List = struct('filename','D0120b','iseqp',num2cell([-93,-93,-93,-93,-93,-93]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60,50,40,30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% warning: slight decrease in rate as SPL increases
% A+
% tag 2 (only minor noise in SAC, decrease in rate as SPL increases)
List = struct('filename','D0120b','iseqp',num2cell([-94,-94]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% warning: slight decrease in rate as SPL increases
% A-
% tag 2 (only minor noise in SAC, decrease in rate as SPL increases)
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-95,-95]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 45: CF = 2943Hz -------------------------------------------------------------------------------------------------------------------------------------------

% warning: slight decrease in rate as SPL increases
% A+
% tag 2 (only minor noise in SAC, decrease in rate as SPL increases)
List = struct('filename','D0120b','iseqp',num2cell([-100,-100,-100,-100,-100,-100]),'isubseqp',num2cell([1,2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 46: CF = 2943Hz -------------------------------------------------------------------------------------------------------------------------------------------

% warning: slight decrease in rate as SPL increases
% A-
% tag 2 (only minor noise in SAC, SLIGHT decrease in rate as SPL increases)
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-102,-102,-102]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (only minor noise in SAC)
List = struct('filename','D0120b','iseqp',num2cell([-103,-103,-103]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 47: CF = 3500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A-
% tag 1 (only minor noise in SAC) 
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-105,-105]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (only minor noise in SAC) 
List = struct('filename','D0120b','iseqp',num2cell([-106,-106]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 50: CF = 2176Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (only minor noise in SAC) 
List = struct('filename','D0120b','iseqp',num2cell([-113,-113]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% commented out due to strange SAC
% % A-
% % tag 1 (only minor noise in SAC) 
% List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-114,-114]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 51: CF = 2176Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A-
% tag 1 (only minor noise in SAC) 
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-116,-116]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (only minor noise in SAC) 
List = struct('filename','D0120b','iseqp',num2cell([-117,-117]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% commented out: rate curve shows large rate-swings
% List = struct('filename','D0120b','iseqp',num2cell([-119,-119,-119,-119,-119,-119,-119]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,15,30,45,60,75,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;


% cell 52: CF = 3536Hz (based on THRright) -------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq's
% NSPL
% tag 3 (VERY noisy SAC)
List = struct('filename','D0120b','iseqp',num2cell([-121,-121,-121,-121,-121]),'isubseqp',num2cell([3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,45,60,75,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 3 (VERY noisy SAC) 
List = struct('filename','D0120b','iseqp',num2cell([-122,-122]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 3 (VERY noisy SAC) 
List = struct('filename','D0120b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-123,-123]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([25,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 54: CF = 2176Hz -------------------------------------------------------------------------------------------------------------------------------------------

% commented out: SAC is pure noise due to low reps/low response rate at low SPL. Dataset should be avoided.
% % NSPL
% % tag 3
% List = struct('filename','D0120b','iseqp',num2cell([-125,-125,-125,-125,-125]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,25,40,55,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 56: no THR recorded -------------------------------------------------------------------------------------------------------------------------------------------
% datasets commented out due to lack of CF and lack of responses (hence lack of useful SACs).

% % NSPL
% List = struct('filename','D0120b','iseqp',num2cell([-134,-134]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;
 
% % NSPL
% List = struct('filename','D0120b','iseqp',num2cell([-135,-135,-135,-135]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % NSPL
% List = struct('filename','D0120b','iseqp',num2cell([-136,-136,-136,-136]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0120c
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 66: CF = 1593Hz -------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 1 (minor noise in SAC)
List = struct('filename','D0120c','iseqp',num2cell([-33,-33,-33]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (minor noise in SAC)
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-34,-34,-34]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([80,70,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% 10 and 30dB subseq removed: no spikes, hence no SAC
% NSPL
% tag 3 (heavy noise in SAC, no spikes at 10 and 30dB)
List = struct('filename','D0120c','iseqp',num2cell([-35,-35,-35]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 67: bad thr curve, no responses at different SPLs ------------------------------------------------------------------------------------------------------------

% cell 70: CF = 1932Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% leave 80dB subsequence out?
% NSPL
% tag 2 (noisy SAC, "dip" in SP at 80dB)
List = struct('filename','D0120c','iseqp',num2cell([-54,-54,-54,-54,-54,-54,-54,-54]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70,60,50,40,30,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (subsequence 8 (20dB) displays problems with trigger in RAS. Subsequence removed. SAC: minor noise)
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-55,-55,-55,-55,-55,-55,-55]),'isubseqn',num2cell([1,2,3,4,5,6,7]),'discernvalue',num2cell([90,80,70,60,50,40,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 75: CF = 17.838Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (VERY noisy SAC)
List = struct('filename','D0120c','iseqp',num2cell([-60,-60,-60,-60,-60,-60,-60]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,70,60,50,40,30,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 77: CF = 1436Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL A+
% ds -63: incomplete data collection.

% NSPL A-
% ds -64: incomplete data collection.

% Left higher SPL subsequence out: rate decreases from 70dB on. 
% removed 30dB subseq: very few spikes, hence bad SAC
% NSPL
% tag 3 (very short duration, noise in SAC, rate decreases from 70dB on)
List = struct('filename','D0120c','iseqp',num2cell([-66,-66,-66,-66]),'isubseqp',num2cell([2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 78: CF = 15.556Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% Left higher SPL subsequence out: rate decreases from 80dB on
% NSPL
% tag 3 (very short duration, VERY noisy SAC, rate decreases from 80dB on)
List = struct('filename','D0120c','iseqp',num2cell([-68,-68,-68,-68,-68,-68,-68]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% Commented out due to lack of useful SACs (no SAC at all at 0 and 10dB)
% % NSPL
% % tag 3 (very short duration, VERY noisy SAC, rate decreases from 80dB on)
% List = struct('filename','D0120c','iseqp',num2cell([-69,-69,-69]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (noise in SAC) 
List = struct('filename','D0120c','iseqp',num2cell([-70,-70]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (noise in SAC)
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-71,-71]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 79: CF = 24.368Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (very short duration, VERY noisy SAC)
List = struct('filename','D0120c','iseqp',num2cell([-73,-73,-73,-73,-73,-73,-73]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];
%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % commented out: SACs are pure noise due to low spike rate
% % NSPL
% % tag 3 (No SACs at 0 or 10dB)
% List = struct('filename','D0120c','iseqp',num2cell([-74,-74,-74]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];
% %groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 2 (60dB lower rate than 40dB, noisy SAC) 
List = struct('filename','D0120c','iseqp',num2cell([-75,-75]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];
%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (60dB lower rate than 40dB, noisy SAC) 
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-76,-76]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];
%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 83: CF = 1593Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (CAVE: 70dB lower rate than 50dB. Good SAC) 
List = struct('filename','D0120c','iseqp',num2cell([-80,-80]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;
 
% A-
% tag 2 (70dB lower rate than 50dB, noisy SAC) 
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-81,-81]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed lowest subseq: lack of rate causes "exotic" SACs
% warning: minor dip in SPL plot at 70dB
% NSPL
% tag 2 (very short duration, noise in SAC, 70dB lower rate than 50dB)
List = struct('filename','D0120c','iseqp',num2cell([-83,-83,-83,-83,-83]),'isubseqp',num2cell([6,7,8,9,10]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause; close all;

% A+
% tag 2 (CAVE: 80dB lower rate than 60dB, noise in SAC) 
List = struct('filename','D0120c','iseqp',num2cell([-84,-84]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 2 (80dB lower rate than 60dB, noise in SAC)
List = struct('filename','D0120c','iseqp',num2cell([-86,-86]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % commented out: extreme noise
% % A+
% % tag 1 (no noise in SAC at 70 and 80dB) 
% List = struct('filename','D0120c','iseqp',num2cell([-99,-99]),'isubseqp',num2cell([5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A-
% tag 1 
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-100,-100]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (CAVE: 80dB lower rate than 70dB)
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-100,-100]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (CAVE: 80dB lower rate than 70dB)
List = struct('filename','D0120c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-101,-101]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (no noise in SAC at 70 and 80dB) 
List = struct('filename','D0120c','iseqp',num2cell([-102,-102]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 83: CF = 795Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 2 (very short duration, noise in SAC, 70 and 90dB rates lower than 50dB rate)
List = struct('filename','D0120c','iseqp',num2cell([-106,-106]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 2 (very short duration, noise in SAC, 70 and 90dB rates lower than 50dB rate)
List = struct('filename','D0120c','iseqp',num2cell([-107,-107,-107,-107]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -108: Incomplete data collection *and* exotic convention of UET var storage: extraction of independent variable may be corrupted.


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0121: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================


% cell 3: CF = 15.157Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (VERY short duration, VERY noisy SAC) 
List = struct('filename','D0121','iseqp',num2cell([-11,-11,-11,-11,-11,-11,-11]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 3 (VERY noisy SAC) 
List = struct('filename','D0121','iseqp',num2cell([-12,-12]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 3 (VERY noisy SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-13,-13]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 7: CF = 4547Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % 0 and 10 dB removed
% % NSPL
% % tag 3 (VERY short duration, VERY noisy SAC: 0 and 10 dB removed) 
% List = struct('filename','D0121','iseqp',num2cell([-22,-22,-22,-22,-22,-22,-22,-22]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% A+
% tag 2 (noise in SAC)  
List = struct('filename','D0121','iseqp',num2cell([-23,-23]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 3 (VERY noisy SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-24,-24]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% B+
% tag 1 (shorter duration, very clean SAC) 
List = struct('filename','D0121','iseqp',num2cell([-25,-25]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% B-
% tag 1 (shorter duration, very clean SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-26,-26]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 8: CF = 22.736Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: no real peak in SAC
% % decrease in rate as SPL incr.
% % NSPL
% % tag 3 (shorter duration, VERY noisy SAC) 
% List = struct('filename','D0121','iseqp',num2cell([-28,-28,-28,-28,-28,-28,-28,-28,-28]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 9: CF = 22.736Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first five subseq: lack of rate causes "flat" SACs
% decrease in rate > 60dB
% NSPL
% tag 3 (VERY noisy SAC, 70dB rate is lower than rate at 60dB) 
List = struct('filename','D0121','iseqp',num2cell([-30,-30,-30,-30]),'isubseqp',num2cell([6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decreases as SPL increases
% A+
% tag 2 (rate decreases as SPL increases, noise in SAC)  
List = struct('filename','D0121','iseqp',num2cell([-31,-31,-31]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (shorter duration, noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-32,-32,-32]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decreases as SPL increases
% NSPL
% tag 2 (noisy SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-33,-33,-33]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decreases as SPL increases
% A-
% tag 2 (shorter duration, noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-34,-34,-34]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 11: CF = 11.368Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out due to exotic SAC
% % minor activity during refractory period in ISI, bad quality SACs
% % NSPL
% % tag 3 ((minor) activity during refract., short duration, VERY noisy SAC) 
% List = struct('filename','D0121','iseqp',num2cell([-38,-38,-38,-38,-38,-38,-38,-38]),'isubseqp',num2cell([1,2,3,4,5,6,7,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% % rate decreases as SPL increases + bad quality SACs: commented out.
% % A+
% % tag 3 (rate decreases as SPL increases, VERY noisy SAC, shorter duration)  
% List = struct('filename','D0121','iseqp',num2cell([-39,-39]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % spikes in refr. period ISI; decrease in rate as SPL incr.; noise in SAC: commented out
% % A+
% % tag 3 (noisy SAC, rate decreases as SPL increases, spikes in refractory period ISI)
% List = struct('filename','D0121','iseqp',num2cell([-40,-40]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 2 (noisy SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-41,-41]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decreases as SPL increases
% A-
% tag 2 (rate decreases as SPL increases, noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-42,-42]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 3 (severe noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-43,-43]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decreases as SPL increases
% A-
% tag 3 (rate decreases as SPL increases, very noisy SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-44,-44]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 3 (noisy SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-45,-45]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 13: CF = 24.259Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out due to noisy SACs: no clear peaks
% % decrease in rate above 50 dB
% % NSPL
% % tag 3 (VERY short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-50,-50,-50,-50,-50,-50,-50,-50,-50]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 3 (VERY noisy SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-51,-51]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 14: CF = 4748Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out due to noisy SACs: no clear peaks
% % NSPL
% % tag 3 (VERY short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-53,-53,-53,-53,-53,-53,-53,-53,-53]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 2 (noise in SAC, shorter duration)  
List = struct('filename','D0121','iseqp',num2cell([-54,-54,-54]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-55,-55,-55]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL
% tag 2 (noise in SACs)
List = struct('filename','D0121','iseqp',num2cell([-56,-56]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (noise in SAC, some activity during refract. period (ISI)) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-57,-57]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 15: CF = 2297Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % SACs too noisy, ISI histograms "dirty", trigger problems
% % NSPL 
% % tag 3 (VERY noisy SACs, low-dB no responses, response at 80dB drops off, spikes in ISI during refr. per., VERY short duration, problems with trigger at 70dB setting)
% List = struct('filename','D0121','iseqp',num2cell([-59,-59,-59,-59,-59,-59,-59,-59,-59]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 2 (noise in SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-60,-60]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-61,-61]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 2 (noise in SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-60,-60]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 16: CF = 22.736Hz (based on THRleft) ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first five subseq: lack of spikes causes noisy SACs
% NSPL 
% tag 3 (VERY noisy SACs)
List = struct('filename','D0121','iseqp',num2cell([-65,-65,-65,-65]),'isubseqp',num2cell([6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 2 (noise in SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-66,-66]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 2 (noise in SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-67,-67]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 17: CF = 5359Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % error in subseq 9: commented out
% % NSPL 
% % tag 3 (VERY short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-71,-71,-71,-71,-71,-71,-71,-71,-71]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 1 (short duration, "normal" noise in SAC)
List = struct('filename','D0121','iseqp',num2cell([-72,-72]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (short duration, "normal" noise in SAC) 
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-73,-73]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 19: CF = 1847Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first three subseq: lack of spike rate causes noisy SACs
% NSPL 
% tag 3 (VERY short duration, VERY noisy SACs)
List = struct('filename','D0121','iseqp',num2cell([-78,-78,-78]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % commented out: excessive noise in SACs (no clear peaks)
% % NSPL 
% % tag 3 (VERY short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-79,-79,-79,-79]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% decrease in rate as SPL incr.
% A+
% tag 1 (good SAC but rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',num2cell([-80,-80]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ISI histogram shows very *short* refractory period...
% A-
% tag 2 (short duration, noise in SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-81,-81]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 22: CF = 1608Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first two subseq: lack of spike rate causes noisy SACs
% NSPL 
% tag 3 (short duration, VERY noisy SACs)
List = struct('filename','D0121','iseqp',num2cell([-84,-84,-84]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % extreme noise in SAC, low information from 0 and 10dB conditions.
% % NSPL 
% % tag 3 (short duration, EXTREME noise in SACs)
% List = struct('filename','D0121','iseqp',num2cell([-85,-85,-85,-85]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % A+
% % tag 3 (VERY noisy SAC)
List = struct('filename','D0121','iseqp',num2cell([-86,-86]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (VERY noisy SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-87,-87]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 23: CF = 3031Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: extreme noise
% % NSPL 
% % tag 3 (short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-95,-95,-95,-95,-95,-95,-95,-95]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 24: CF = 5000Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest three subseq: excessive noise makes SACs useless
% NSPL 
% tag 1 (very short duration, normal noise in SACs)
List = struct('filename','D0121','iseqp',num2cell([-97,-97,-97]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,45,55]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 30: CF = 3078Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC, low information from 0 and 10dB conditions.
% % NSPL 
% % tag 1 (very short duration, EXTREME noise in SACs)
% List = struct('filename','D0121','iseqp',num2cell([-103,-103,-103,-103,-103,-103,-103,-103]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 3 (VERY noisy SAC)
List = struct('filename','D0121','iseqp',num2cell([-104,-104]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% decrease in rate as SPL incr.
% A-
% tag 3 (VERY noisy SAC, rate decreases as SPL increases)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-105,-105]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 32: CF = 10.000Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: excessive noise in SAC
% % rate drops at highest intensity: 80dB subseq. removed!
% % NSPL 
% % tag 3 (very short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-108,-108,-108,-108,-108,-108]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121','iseqp',num2cell([-109,-109]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (VERY noisy SAC, response of 50dB condition "fades out" with repeated presentations)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-110,-110]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 33: CF = 19.793Hz ----------------------------------------------------------------------------------------------------------------------------------------------
% chopper?

% % commented out due to excessive noise (short duration)
% % rate drops at > 50dB intensity
% % NSPL
% % tag 3 (very short duration, VERY noisy SAC)
% List = struct('filename','D0121','iseqp',num2cell([-113,-113,-113,-113,-113,-113,-113]),'isubseqp',num2cell([1,2,3,4,5,6,7]),... 
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% % VERY noisy SAC, shorter duration, ISI histogram at 55dB, rate decreases with increasing SPL: commented out
% % A+
% % tag 3 (VERY noisy SAC, shorter duration, ISI histogram at 55dB, rate decreases with increasing SPL)
% List = struct('filename','D0121','iseqp',num2cell([-115,-115]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,55]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% % excessive noise
% % A-
% % tag 3 (VERY noisy SAC, shorter duration, check ISI histogram at 55dB)
% List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-116,-116]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([35,55]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 35: CF = 1340Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % rate drops off at higher intensities, low response rates, VERY short duration, very noisy SAC: commented out
% % NSPL 
% % tag 3 (very short duration, VERY noisy SACs)
% List = struct('filename','D0121','iseqp',num2cell([-118,-118,-118,-118,-118,-118,-118,-118]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 3 (normal noise in SAC, shorter duration)
List = struct('filename','D0121','iseqp',num2cell([-119,-119]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (spikes in refractory period (ISI), noise in SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-120,-120]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 36: CF = 2031Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: excessive noise makes peak-distinction impossible
% % rate drops off at 60 and 70dB
% % NSPL 
% % tag 3 (rate drops off at higher intensities, low response rates, VERY short duration, very noisy SAC)
% List = struct('filename','D0121','iseqp',num2cell([-122,-122,-122,-122,-122,-122,-122,-122]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% rate drops at 60 dB
% A+
% tag 3 (normal noise in SAC, shorter duration)
List = struct('filename','D0121','iseqp',num2cell([-123,-123]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 ( noise in SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-124,-124]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 37: CF = 583Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed four lowest subseq: lack of spike rates causes bad SACs
% NSPL 
% tag 3 (VERY short duration, very noisy SAC)
List = struct('filename','D0121','iseqp',num2cell([-126,-126,-126,-126]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (very clean SAC)
List = struct('filename','D0121','iseqp',num2cell([-127,-127]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (very clean SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-128,-128]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (very clean SAC)
List = struct('filename','D0121','iseqp',num2cell([-129,-129]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (very clean SAC)
List = struct('filename','D0121','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-130,-130]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 38: CF = 583Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first five subseq: lack of spikes makes SAC very noisy
% NSPL 
% tag 3 (VERY short duration, very noisy SAC, minor "dip" in spl plot at 40dB)
List = struct('filename','D0121','iseqp',num2cell([-143,-143,-143]),'isubseqp',num2cell([6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPL 
% tag 3 (very noisy SAC)
List = struct('filename','D0121','iseqp',num2cell([-144,-144,-144,-144]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0121B
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================


% cell 38: CF = 583Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (some spikes in RP ISI, very clean SAC)
List = struct('filename','D0121b','iseqp',num2cell([-1,-1]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (very clean SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-2,-2]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 39: CF = 17.411Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first two subseq: excessive noise
% NSPL 
% tag 3 (VERY short duration, very noisy SAC, minor "dip" in spl plot at 60dB)
List = struct('filename','D0121b','iseqp',num2cell([-5,-5]),'isubseqp',num2cell([3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first two subseq: excessive noise
% NSPL 
% tag 3 (VERY short duration, very noisy SAC, low response rate at sub-20dB intens.)
List = struct('filename','D0121b','iseqp',num2cell([-6,-6,-6]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% decrease in rate as intensity increases
% A+
% tag 3 (some spikes in RP ISI, decrease in rate as intensity increases, noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-1,-1]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% decrease in rate as intensity increases
% A-
% tag 3 (some spikes in RP ISI, decrease in rate as intensity increases, noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-9,-9]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 43: CF = 36.551Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % very short duration creates very noisy SACs...
% % decrease in rate at 90dB. Subseq left in (decrease very small)
% % NSPL 
% % tag 3 (VERY short duration, very noisy SAC, decreased response at 90dB)
% List = struct('filename','D0121b','iseqp',num2cell([-12,-12,-12,-12,-12]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,30,50,70,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 45: CF = 2639Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % very short duration creates very noisy SACs...
% % NSPL 
% % tag 3 (VERY short duration, VERY noisy SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-16,-16,-16,-16,-16,-16,-16,-16,-16]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-17,-17]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % major decrease in rate as intensity increases: commented out
% % A-
% % tag 2 (decrease in rate as intensity increases, noise in SAC)
% List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-18,-18]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 46: CF = 2639Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % very short duration creates very noisy SACs...
% % NSPL 
% % tag 3 (VERY short duration, VERY noisy SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-21,-21,-21,-21,-21,-21,-21]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,15,30,45,60,75,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-22,-22]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-23,-23]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 48: CF = 15.157Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq: noisy SAC, no clear peaks
% sharp rate drop-off at 70dB: subseq removed!
% NSPL 
% tag 3 (VERY short duration, VERY noisy SAC)
List = struct('filename','D0121b','iseqp',num2cell([-25,-25,-25]),'isubseqp',num2cell([5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-26,-26]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 50: CF = 1895Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC: no clear peaks. Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-30,-30,-30,-30,-30]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 51: CF = 2653Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC: no clear peaks. Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-37,-37,-37,-37,-37,-37]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-38,-38]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-39,-39]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 52: CF = 1436Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC: no clear peaks; decrease in rate as SPL increases: Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC, decreased rate at 70dB)
% List = struct('filename','D0121b','iseqp',num2cell([-44,-44,-44,-44,-44]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,25,40,55,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % major decrease in rate as intensity increases: commented out
% % A+
% % tag 2 (noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-45,-45]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% A-
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-46,-46]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 53: CF = 2121Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC: no clear peaks + spikes in refract. per. ISI: Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC, check ISI)
% List = struct('filename','D0121b','iseqp',num2cell([-44,-44,-44,-44,-44]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,25,40,55,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 54: CF = 3294Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC: no clear peaks + spikes in refract. per. ISI: Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC, check ISI)
% List = struct('filename','D0121b','iseqp',num2cell([-52,-52,-52,-52,-52,-52,-52]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 55: CF = 2378Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SAC + decrease in intensity at 70dB: Commented out
% % NSPL 
% % tag 3 (VERY short duration, EXTREME noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-55,-55,-55,-55,-55,-55,-55]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 3 (short duration, lots of noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-56,-56]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (short duration, lots of noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-57,-57]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 56: CF = 319Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq: excessive noise (short duration!)
% NSPL 
% tag 3 (VERY short duration, noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-59,-59]),'isubseqp',num2cell([6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',num2cell([-60,-60]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (good SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-61,-61]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 64: CF = 2121Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % check 80dB response rate before un-commenting!
% % NSPL 
% % tag 3 (VERY short duration, rate drops at 80dB, noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-84,-84,-84,-84,-84,-84,-84,-84]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-85,-85]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-86,-86]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 65: CF = 1649Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % dip at 60 dB rate plot!
% % NSPL 
% % tag 3 (VERY short duration, rate drops at 60dB, noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-92,-92,-92,-92,-92,-92]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% ds -93: Incomplete data collection *and* exotic convention of UET var storage: extraction of independent variable may be corrupted.

% % incomplete data collection
% % rate drops at higher intensity
% % A-
% % tag 2 (noise in SAC)
% List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-96,-96]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 66: CF = 750Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% commented lowest subseq out: excessive noise (short duration!)
% NSPL 
% tag 2 (VERY short duration, noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-99,-99,-99]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',num2cell([-100,-100]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-101,-101]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 67: CF = 862Hz ----------------------------------------------------------------------------------------------------------------------------------------------
% chopper?

% removed lowest subseq: no spike rate
% NSPL 
% tag 3 (VERY short duration, lots of noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-105,-105,-105,-105]),'isubseqp',num2cell([3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed lowest subseq: no spike rate
% A+
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',num2cell([-108,-108,-108,-108]),'isubseqp',num2cell([2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed lowest subseq: no spike rate
% A-
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-109,-109,-109,-109]),'isubseqn',num2cell([2,3,4,5]),'discernvalue',num2cell([30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 68: CF = 2200Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % dip in rate plot!
% % NSPL 
% % tag 3 (VERY short duration, rate drops as SPL increases, extreme noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-113,-113,-113,-113,-113]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,25,40,55,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-114,-114,-114,-114,-114]),'isubseqp',num2cell([1,2,3,4,5]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,25,40,55,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC)
% List = struct('filename','D0121b','iseqp',num2cell([-115,-115,-115,-115]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',num2cell([-116,-116]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 69: CF = 7716Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed four lowest subseq: low spike rate causes noisy SACs
% NSPL 
% tag 3 (VERY short duration, lots of noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-119,-119,-119,-119]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 70: CF = 4708Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % rate drops off past 50dB
% % NSPL 
% % tag 3 (VERY short duration, rate drops as SPL increases, extreme noise in SAC (no peaks can be distinguished))
% List = struct('filename','D0121b','iseqp',num2cell([-125,-125,-125,-125,-125,-125,-125,-125]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 3 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-126,-126]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-127,-127]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate drops off as intensity increases
% A+
% tag 3 (noise in SAC)
List = struct('filename','D0121b','iseqp',num2cell([-129,-129]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% rate drops off as intensity increases
% A-
% tag 3 (noise in SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-130,-130]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 71: CF = 2567Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC (no peaks can be distinguished))
% List = struct('filename','D0121b','iseqp',num2cell([-132,-132,-132,-132,-132,-132,-132,-132]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',num2cell([-133,-133]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-134,-134]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 73: CF = 9576Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed two lowest subseq: no spike rate
% NSPL 
% tag 3 (VERY short duration, lots of noise in SAC (but clear peaks))
List = struct('filename','D0121b','iseqp',num2cell([-137,-137,-137,-137]),'isubseqp',num2cell([3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,45,60,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',num2cell([-138,-138]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-139,-139]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 75: CF = 2274Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC (no peaks can be distinguished))
% List = struct('filename','D0121b','iseqp',num2cell([-141,-141,-141,-141,-141,-141,-141]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC (no peaks can be distinguished))
% List = struct('filename','D0121b','iseqp',num2cell([-142,-142,-142,-142]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',num2cell([-143,-143]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0121b','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-144,-144]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0121c
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================


% cell 76: CF = 2639Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC)
% List = struct('filename','D0121c','iseqp',num2cell([-2,-2,-2,-2,-2,-2,-2,-2]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % commented out: excessive noise
% % (slight) decrease in rate as SPL increases
% % A+
% % tag 2 (good SAC peaks, some noise)
% List = struct('filename','D0121c','iseqp',num2cell([-3,-3]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% (slight) decrease in rate as SPL increases
% A-
% tag 1 (good SAC)
List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-4,-4]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 77: CF = 2111Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (VERY short duration, extreme noise in SAC)
% List = struct('filename','D0121c','iseqp',num2cell([-9,-9,-9,-9,-9,-9,-9,-9]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 1 (good SAC peaks)
List = struct('filename','D0121c','iseqp',num2cell([-10,-10]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -11: error: Incomplete data collection *and* exotic convention of UET var storage: extraction of independent variable may be corrupted.

% cell 78: CF = 1171Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first three subseq: low spike rate --> noisy SAC
% NSPL
% tag 2 (VERY short duration, noise in SAC)
List = struct('filename','D0121c','iseqp',num2cell([-15,-15,-15,-15,-15,-15]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0121c','iseqp',num2cell([-16,-16]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-17,-17]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 79: CF = 1122Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed four lowest subseq: low spike rate
% NSPL
% tag 3 (VERY short duration, VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-22,-22,-22]),'isubseqp',num2cell([5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,75,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 82: CF = 1320Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq
% slight decrease in rate at 90dB...
% NSPL
% tag 3 (VERY short duration, VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-33,-33,-33,-33,-33,-33]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% decrease in rate as SPL increases
% A+
% tag 2 (good SAC with some noise)
List = struct('filename','D0121c','iseqp',num2cell([-34,-34]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % strange choice of primary peak: check before uncommenting!
% % (slight) decrease in rate as SPL increases
% % A-
% % tag 2 (some noise, good SAC)
% List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-35,-35]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([65,85]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 83: CF = 8919Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed four lowest subseq: lack of spike rate
% NSPL
% tag 3 (VERY short duration; VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-38,-38,-38,-38]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 84: CF = 1523Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest three subseq: lack of spike rate
% slight decrease in rate at 80dB
% NSPL
% tag 3 (VERY short duration; VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-42,-42,-42,-42]),'isubseqp',num2cell([4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 85: CF = 574Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: excessive noise
% % rate drops off at higher intensities
% % NSPL
% % tag 3 (VERY short duration; VERY noisy SAC but clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-44,-44,-44,-44,-44,-44,-44]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,35,45,55,65,75,85]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 86: CF = 758Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest two subseq: low spike rate causes noisy SAC
% minor spikes during refractory period, rate drops off
% NSPL
% tag 3 (VERY short duration; VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-49,-49,-49,-49,-49]),'isubseqp',num2cell([3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % bad triggers in 55dB spikes (+spikes in ISI refr.per.) : don't use seq.!
% % A+
% % tag 1 (good SAC; don't use seq: bad triggers! )
% List = struct('filename','D0121c','iseqp',num2cell([-50,-50]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% minor spikes in ISI refr. per.
% A+
% tag 1 (good SAC)
List = struct('filename','D0121c','iseqp',num2cell([-51,-51]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% (slight) decrease in rate as SPL increases
% A-
% tag 1 (good SAC)
List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-52,-52]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 87: CF = 1137Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -55: bad trigger

% decrease in rate as SPL increases
% NSPL
% tag 3 (VERY short duration; VERY noisy SAC but clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-56,-56]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 90: 2639Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise; no peaks; don't use dataset!
% % NSPL
% % tag 3 (VERY short duration; EXTREME noise in SAC, no clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-73,-73,-73,-73,-73,-73]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % extreme noise; no peaks; don't use dataset!
% % NSPL
% % tag 3 (VERY short duration; EXTREME noise in SAC, no clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-74,-74,-74,-74]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % small trigger problems, bad SACs: don't use ds! 
% % A+
% % tag 3 (extreme noise, trigger problems)
% List = struct('filename','D0121c','iseqp',num2cell([-75,-75]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% ds -76: trigger problems, almost no spikes at 75dB

% cell 93: 9234Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % trigger problems in 60dB subseq; don't use dataset!
% % NSPL
% % tag 3 (VERY short duration; noise in SAC, no clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-88,-88]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % trigger problems in 60dB subseq; don't use dataset!
% % A-
% % tag 2 (noise in SAC, bad trigger problems at 60dB)
% List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-89,-89]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% cell 94: 10.981Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise; no peaks; don't use dataset!
% % NSPL
% % tag 3 (VERY short duration; EXTREME noise in SAC, no clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-91,-91,-91,-91,-91,-91,-91,-91]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% A+
% tag 2 (some noise in SAC, clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-92,-92]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (some noise in SAC, clear peaks)
List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-93,-93]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 95: 10.981Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (some noise in SAC, clear peaks)
List = struct('filename','D0121c','iseqp',num2cell([-95,-95]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (some noise in SAC, clear peaks)
List = struct('filename','D0121c','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-96,-96]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 96: bad SACs

% cell 103: 4243Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise; no peaks; don't use dataset!
% % NSPL
% % tag 3 (VERY short duration; EXTREME noise in SAC, no clear peaks. Minor dip in rate plot)
% List = struct('filename','D0121c','iseqp',num2cell([-105,-105,-105,-105,-105,-105,-105,-105]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;
% 
% % trigger problems in 10dB subseq: subseq removed
% % NSPL
% % tag 3 (VERY short duration; EXTREME noise in SAC, no clear peaks)
% List = struct('filename','D0121c','iseqp',num2cell([-106,-106,-106,-106,-106,-106,-106,-106]),'isubseqp',num2cell([1,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% 105 -> 107: no good SACs.

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0126: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 2: CF = 14.340Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % trigger + spikes in refr. per: commented out!
% % NSPL 
% % tag 3 (short duration, heavy noise in SAC, problems with triggers in all 3 raster plots, spikes in refractory period)
% List = struct('filename','D0126','iseqp',num2cell([-2,-2,-2]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60;70;80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % trigger + spikes in refr. per: commented out!
% % NSPL 
% % tag 3 (short duration, heavy noise in SAC, problems with triggers in all 3 raster plots, spikes in refractory period)
% List = struct('filename','D0126','iseqp',num2cell([-3,-3,-3]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40;50;60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % trigger + spikes in refr. per: commented out!
% % NSPL 
% % tag 3 (short duration, extreme noise in SAC, problems with triggers in all 3 raster plots, spikes in refractory period)
% List = struct('filename','D0126','iseqp',num2cell([-4,-4,-4]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10;20;30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%pause;close all;

% % many spikes during refr. per (isi!) + some trigger problems: commented out!
% % A+
% % tag 2 (spikes in RP ISI, trigger problems; good SAC)
% List = struct('filename','D0126','iseqp',num2cell([-5,-5]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;close all;

% cell 5----------------------------------------------------------------------------------------------------------------------------------------------

% ds -8, ds -9, ds -10: heavy noise and/or spikes during refr. per. of ISI histogram.

% cell 12: CF = 1088Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest two subseq: lack of spike rate
% NSPL 
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-13,-13,-13]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (a few spikes in RP ISI,; good SAC)
List = struct('filename','D0126','iseqp',num2cell([-14,-14]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 13: CF = 1189Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-15,-15]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([45,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 14: CF = 1189Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest three subseq: low spike rate
% NSPL 
% tag 2 (some noise in SAC)
List = struct('filename','D0126','iseqp',num2cell([-20,-20,-20,-20,-20]),'isubseqp',num2cell([4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;,

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-21,-21,-21]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 15: CF = 707Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest two subseq: low spike rate causes noisy sac
% NSPL 
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0126','iseqp',num2cell([-24,-24]),'isubseqp',num2cell([3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed lowest subseq: no spikes
% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-25,-25,-25]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed lowest subseq: almost no spikes
% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-26,-26]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 17: CF = 505Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-29,-29]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed 20dB subseq: low spike rate causes excessive noise
% NSPL 
% tag 1 (good SAC. Cave: almost no spikes at 20 and 35dB)
List = struct('filename','D0126','iseqp',num2cell([-31,-31,-31]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,50,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % sudden drop-off at 70dB: lost cell. DS commented out
% % A+
% % tag 1 (good SAC)
% List = struct('filename','D0126','iseqp',num2cell([-32,-32,-32]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% cell 18: CF = 600Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A-
% tag 2 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-34,-34,-34]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 20: CF = 1500Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % excessive noise: commented out
% % NSPL 
% % tag 3 (very noisy SAC, good peaks)
% List = struct('filename','D0126','iseqp',num2cell([-38,-38,-38,-38]),'isubseqp',num2cell([1,2,3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,30,50,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 22: CF = 812Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-54,-54]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-55,-55]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% B+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-56,-56]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% B-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-57,-57]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% almost no spikes at 30dB...
% A+
% tag 3 (good SAC; cave: almost no spikes at 30dB)
List = struct('filename','D0126','iseqp',num2cell([-61,-61]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cave: slight decrease in rate as SPL increases
% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-62,-62]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cave: slight decrease in rate as SPL increases
% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-63,-63]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed 30dB subseq: low spikerate
% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-64,-64]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: slight decrease in rate as SPL increases
% B+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-65,-65]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% B+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-65,-65]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -66: lost cell

% cell 31: CF = 750Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 3 (good peaks, lots of noise)
List = struct('filename','D0126','iseqp',num2cell([-71,-71]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed 10 and 25dB subseq: almost no spikes --> very noisy SAC
% NSPL 
% tag 3 (good SACS at 55 and 70; almost no spikes/SAC at lower intensities)
List = struct('filename','D0126','iseqp',num2cell([-73,-73,-73]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,55,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 3 (good primary peak, lots of noise in rest of SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-74,-74]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 32: CF = 2000Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -82: extreme noise, no clear peaks can be found in SAC

% A+
% tag 3 (good peaks, lots of noise)
List = struct('filename','D0126','iseqp',num2cell([-83,-83]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (good peaks, lots of noise in rest of SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-84,-84]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 33: extreme noise in all SACs

% cell 34: CF = 3446Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -91: extreme noise in all SACs, ds should be avoided

% A+
% tag 3 (good primary peak, lots of noise)
List = struct('filename','D0126','iseqp',num2cell([-92,-92]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 35: extreme noise in all SACs + spikes in refractory period ISI histogram

% cell 36: lots of spikes in refr. per. ISIh: all ds should be avoided (despite the good SACs)

% cell 37: lots of spikes in refr. per. ISIh: all ds should be avoided (despite the good SACs)

% cell 40: CF = 4199Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % extreme noise in SACs:commented out
% % NSPL 
% % tag 3 (extreme noise in SACs)
% List = struct('filename','D0126','iseqp',num2cell([-125,-125,-125,-125,-125,-125,-125]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 3 (good primary peak, lots of noise)
List = struct('filename','D0126','iseqp',num2cell([-126,-126]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (good peaks, lots of noise in rest of SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-127,-127]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 44: CF = 1100Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq (10dB): lack of spikes --> very noisy SAC
% NSPL 
% tag 3 (lots of noise in SACs, good primary/secondary peaks)
List = struct('filename','D0126','iseqp',num2cell([-131,-131,-131,-131,-131,-131]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-132,-132]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-133,-133]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 45: CF = 1915Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -136: extreme noise in SACs, ds should be avoided

% A+
% tag 2 (good SAC with some noise)
List = struct('filename','D0126','iseqp',num2cell([-137,-137]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (good SAC with some noise)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-138,-138]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 48: CF = 350Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed lowest subseq: not enough spikes to generate proper SAC
% NSPL 
% tag 2 (good SAC, some noise)
List = struct('filename','D0126','iseqp',num2cell([-140,-140,-140,-140]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-141,-141]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 54: extreme noise in all SACs: ds should be avoided

% cell 61: CF = 1979Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % NSPL 
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0126','iseqp',num2cell([-158,-158,-158,-158,-158,-158,-158]),'isubseqp',num2cell([2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-159,-159]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (good SAC with some noise)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-160,-160]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 62: CF = 1600Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -162: spikes in refractory period (ISI)

% ds -163: spikes in refractory period (ISI)

% ds -164: spikes in refractory period (ISI)

% ds -165: spikes in refractory period (ISI)

% A+
% tag 2 (some noise in SAC)
List = struct('filename','D0126','iseqp',num2cell([-166,-166,-166]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([15,30,45]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 65: CF = 2437Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -171: extreme noise in SAC

% NSPL
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0126','iseqp',num2cell([-172,-172]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (noise in SAC, good peaks)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-173,-173]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 70: CF = 1732Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -177: extreme noise in SAC

% A+
% tag 2 (some noise in SAC)
List = struct('filename','D0126','iseqp',num2cell([-178,-178]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 71: CF = 2000Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 3 (noise in SAC)
List = struct('filename','D0126','iseqp',num2cell([-181,-181]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 3 (noise in SAC)
List = struct('filename','D0126','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-182,-182]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 72: CF = 958Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0126','iseqp',num2cell([-183,-183]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0202: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================


%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 7: CF = 1320Hz -------------------------------------------------------------------------------------------------------------------------------------------

% NSPL 
% tag 2 (some spikes in refr. per. ISI histogram...)
List = struct('filename','D0202','iseqp',num2cell([-2,-2]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (some spikes in RP ISI)
List = struct('filename','D0202','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-3,-3]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 8: CF = 1306Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-4,-4]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed lowest subseq: short duration --> noise in SAC
% NSPL 
% tag 3 (very short duration, noise in SAC but clear primary/secondary peaks)
List = struct('filename','D0202','iseqp',num2cell([-5,-5,-5,-5,-5]),'isubseqp',num2cell([3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-6,-6]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 10: CF = 2176Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -10, ds -11: low rate at high intensities (50, 70dB), spikes during refractory period ISI: ds should be avoided

% ds -12: extreme noise in SAC: no clear peaks

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-14,-14,-14,-14]),'isubseqp',num2cell([1,2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 11: CF = 1100Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-15,-15]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -16: extreme noise in SAC (due to short stim. dur.)

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-18,-18]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 12: CF = 380Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (very good SAC)
List = struct('filename','D0202','iseqp',num2cell([-19,-19,-19]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 14: CF = 4950Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-20,-20,-20]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -21: extreme noise in SAC

% cell 15: CF = 2000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-22,-22,-22]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -23: extreme noise in SAC

% cell 16: CF = 1750Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0202','iseqp',num2cell([-24,-24]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 19: CF = 2800Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0202','iseqp',num2cell([-25,-25]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -26: extreme noise in SAC

% A-
% tag 2 (noisy SAC)
List = struct('filename','D0202','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-28,-28,-28]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 20: CF = 1700Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',num2cell([-30,-30,-30]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -31: extreme noise in SAC

% A-
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-33,-33,-33]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 21: CF = 1500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (cave: high spike rate in refr. per. ISI; good SAC)
List = struct('filename','D0202','iseqp',num2cell([-35,-35,-35]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -36: extreme noise in SAC

% cell 24: CF = 2183Hz -------------------------------------------------------------------------------------------------------------------------------------------

% CAVE: decrease in rate as intensity increases, rate activity during refractory period (ISI)
% A+
% tag 2 (cave: high spike rate in refr. per. ISI; good SAC)
List = struct('filename','D0202','iseqp',num2cell([-39,-39]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -40: extreme noise in SAC

% cell 25: CF = 2370Hz -------------------------------------------------------------------------------------------------------------------------------------------

% CAVE: (slight) decrease in rate as intensity increases, rate activity during refractory period (ISI)
% A+
% tag 2 (cave: high spike rate in refr. per. ISI; good SAC)
List = struct('filename','D0202','iseqp',num2cell([-42,-42]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -43: extreme noise in SAC

% A-
% tag 1 (good SAC)
List = struct('filename','D0202','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-45,-45]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0208: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================


%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 5: CF = 1400Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+ 
% tag 1 (some noise in SAC, overall good correlogram)
List = struct('filename','D0208','iseqp',num2cell([-3,-3]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed 5 first subseq.
% NSPL 
% tag 2 (some noise in SAC, very low spike rate at lowest intensities, some spikes in refr. per. ISI)
List = struct('filename','D0208','iseqp',num2cell([-4,-4,-4]),'isubseqp',num2cell([6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% commented out: dominant frequency (49Hz) is nowhere near the CF (1400Hz)
% % A+
% % tag 1 (good SAC)
% List = struct('filename','D0208','iseqp',num2cell([-6,-6]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,85]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% % warning: dominant frequency (49Hz) is nowhere near the CF (1400Hz)
% % A-
% % tag 3 (good SAC, but DF and CF differ significantly)
% List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-7,-7]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([55,75]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 7: CF = 1250Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 3 subseq
% NSPL 
% tag 1 (good SAC, very little noise. Cave: lowest intensities have extremely low spike rates)
List = struct('filename','D0208','iseqp',num2cell([-8,-8,-8,-8]),'isubseqp',num2cell([4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: spike rate decreases as SPL increases
% A+
% tag 2 (good SAC, spike rate decreases as SPL increases)
List = struct('filename','D0208','iseqp',num2cell([-9,-9]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cave: spike rate decreases as SPL increases
% A-
% tag 2 (good SAC, spike rate decreases as SPL increases)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-11,-11]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 10: CF = 1319Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: spike rate decreases as SPL increases
% A+
% tag 2 (good SAC, spike rate decreases as SPL increases)
List = struct('filename','D0208','iseqp',num2cell([-13,-13]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 4 subseq
% cave: spike rate decreases at highest intensities
% NSPL 
% tag 3 (dip in rate at highest intensities, DF trails away from CF at highest intensity, major noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-16,-16,-16,-16]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-17,-17]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (good SAC, spike rate decreases as SPL increases)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-18,-18]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 11: CF = 300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% % A+
% % tag 3 (no peak at 60dB, bad SAC)
% List = struct('filename','D0208','iseqp',num2cell([-19,-19]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% NSPL 
% tag 2 (heavy noise in SAC, clear peak)
List = struct('filename','D0208','iseqp',num2cell([-21,-21,-21,-21,-21,-21,-21]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 2 (clean SAC)
List = struct('filename','D0208','iseqp',num2cell([-22,-22]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (good SAC, spike rate decreases as SPL increases)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-23,-23]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 13: CF = 1000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% warning: minor decrease in spike rate as SPL increases
% A+
% tag 2 (clean SAC,minor decrease in spike rate as SPL increases)
List = struct('filename','D0208','iseqp',num2cell([-25,-25]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first three subseq
% warning: minor decrease in spike rate as SPL increases
% NSPL 
% tag 3 (dip in rate at highest intensities, major noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-26,-26,-26,-26,-26,-26]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 14: CF = 3400Hz -------------------------------------------------------------------------------------------------------------------------------------------

% warning: extreme noise in SAC: comment out?
% removed 0 dB subseq (noise)
% NSPL 
% tag 3 (extreme noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-28,-28,-28,-28,-28,-28,-28]),'isubseqp',num2cell([2,3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 3 (clean peak in SAC, DF doesn't match CF)
List = struct('filename','D0208','iseqp',num2cell([-29,-29]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 15: CF = 2000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first three subseq
% NSPL 
% tag 3 (extreme noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-30,-30,-30,-30,-30,-30]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 2 (clean peak in SAC, DF doesn't match CF)
List = struct('filename','D0208','iseqp',num2cell([-31,-31]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 2 (clean peak in SAC, DF doesn't match CF)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-32,-32]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 16: CF = 500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (clean peak in SAC)
List = struct('filename','D0208','iseqp',num2cell([-36,-36]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 17: CF = 1650Hz -------------------------------------------------------------------------------------------------------------------------------------------

% % removed 0 dB subseq (noise), extreme noise in SAC: commented out
% % NSPL 
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0208','iseqp',num2cell([-37,-37,-37,-37,-37,-37,-37]),'isubseqp',num2cell([2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% warning: minor decrease in rate as SPL increases
% A+
% tag 1 (good SAC, minor decrease in rate as SPL increases)
List = struct('filename','D0208','iseqp',num2cell([-38,-38]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-40,-40]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 19: CF = 2390Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-43,-43]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % extreme noise in SAC, rate decreases as intensity increases
% % removed 0 dB subseq (noise)
% % NSPL 
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0208','iseqp',num2cell([-44,-44,-44,-44,-44,-44,-44,-44]),'isubseqp',num2cell([2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 21: CF = 2600Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 3 subseq
% NSPL 
% tag 3 (heavy noise in SAC, yet with clean peaks)
List = struct('filename','D0208','iseqp',num2cell([-46,-46,-46,-46,-46]),'isubseqp',num2cell([4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 2 (good SAC, some noise. Check ISI)
List = struct('filename','D0208','iseqp',num2cell([-47,-47]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 27: CF = 2600Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: rate decreases as intensity increases
% A+
% tag 2 (good SAC, rate decrease)
List = struct('filename','D0208','iseqp',num2cell([-54,-54]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % commented out: extreme noise in SAC
% % removed 0 dB subseq (noise)
% % NSPL 
% % tag 3 (extreme noise)
% List = struct('filename','D0208','iseqp',num2cell([-55,-55,-55,-55,-55,-55,-55,-55]),'isubseqp',num2cell([2,3,4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,20,30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% rate decrease at 60dB
% A-
% tag 2 (good SAC, rate decrease, some spikes in refr. per. ISI)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-58,-58,-58]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 28: CF = 1800Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC, rate decrease)
List = struct('filename','D0208','iseqp',num2cell([-59,-59]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed 0,10,20,30,40 dB subseq (noise); rate dip at higher intensities
% NSPL 
% tag 3 (clean peaks, rate dip)
List = struct('filename','D0208','iseqp',num2cell([-60,-60,-60,-60]),'isubseqp',num2cell([6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% rate decrease at 60dB
% A-
% tag 2 (good SAC, rate decrease, some spikes in refr. per. ISI)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-63,-63]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 30: CF = 2600Hz -------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: trigger problems at 40dB
% % A+
% % tag 2 (good SAC, rate decrease, trigger problems)
% List = struct('filename','D0208','iseqp',num2cell([-65,-65]),'isubseqp',num2cell([1,2]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
% pause;close all;

% ds -66: extreme noise

% cell 31: CF = 3000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0208','iseqp',num2cell([-69,-69]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % commented out: extreme noise
% % NSPL 
% % tag 3 (extreme noise)
% List = struct('filename','D0208','iseqp',num2cell([-70,-70,-70,-70-70,-70,-70,-70]),'isubseqp',num2cell([1,2,3,4,5,6,7,8]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,10,20,30,40,50,60,70]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-73,-73]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% minor decrease in rate as intensity  increases
% A+
% tag 2 (good SAC, minor decrease in rate)
List = struct('filename','D0208','iseqp',num2cell([-74,-74]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 32: CF = 3000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0208','iseqp',num2cell([-75,-75]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 33: CF = 3300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% minor decrease in rate as intensity  increases
% A+
% tag 2 (good SAC, some noise, minor decrease in rate as intensity increases)
List = struct('filename','D0208','iseqp',num2cell([-77,-77]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-78,-78]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 33: CF = 1650Hz -------------------------------------------------------------------------------------------------------------------------------------------

% minor decrease in rate as intensity  increases
% A+
% tag 2 (good SAC, minor decrease in rate as intensity increases)
List = struct('filename','D0208','iseqp',num2cell([-80,-80]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed subseq 0 -> 20 dB
% NSPL 
% tag 3 (very noisy yet with clear primary peaks)
List = struct('filename','D0208','iseqp',num2cell([-81,-81,-81,-81,-81]),'isubseqp',num2cell([4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 40: CF = 4300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% minor decrease in rate as intensity  increases
% A+
% tag 2 (good SAC, minor decrease in rate as intensity increases)
List = struct('filename','D0208','iseqp',num2cell([-86,-86]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % cave: major dip in rate curve past 40dB: lost cell?
% % removed subseq 0 -> 20 dB
% % NSPL 
% % tag 3 (extreme noise, subsequences 0 to 20 dB are useless, major dip in rate curve)
% List = struct('filename','D0208','iseqp',num2cell([-87,-87,-87,-87,-87,-87]),'isubseqp',num2cell([4,5,6,7,8,9]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% minor decrease in rate as intensity  increases
% A-
% tag 1 (good SAC, dip in rate)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-90,-90]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 41: CF = 2250Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-91,-91]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% warning: minor dip in rate curve
% removed subseq 0 -> 30 dB
% NSPL 
% tag 3 (heavy noise, good peaks)
List = struct('filename','D0208','iseqp',num2cell([-92,-92,-92,-92,-92]),'isubseqp',num2cell([5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-94,-94]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 44: CF = 950Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-97,-97]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed subseq 0 -> 30 dB
% NSPL 
% tag 3 (heavy noise, good peaks)
List = struct('filename','D0208','iseqp',num2cell([-92,-92,-92,-92,-92]),'isubseqp',num2cell([5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 53: CF = 1080Hz -------------------------------------------------------------------------------------------------------------------------------------------

% decrease in rate as intensity  increases
% A+
% tag 1 (minor trigger problems in 60dB subseq,decrease in rate as intensity  increases, good SAC)
List = struct('filename','D0208','iseqp',num2cell([-101,-101]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% (very!) slight dip in rate curve
% NSPL 
% tag 2 (some noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-102,-102,-102,-102,-102,-102]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% (very!) slight dip in rate curve
% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-105,-105]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-106,-106]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% decrease in rate as intensity  increases
% B+
% tag 1 (good SAC, decrease in rate as intensity  increases)
List = struct('filename','D0208','iseqp',num2cell([-107,-107]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% slight decrease in rate as intensity  increases
% B-
% tag 1 (good SAC, slight decrease in rate as intensity  increases)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-108,-108]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 55: Not accepted! -------------------------------------------------------------------------------------------------------------------------------------------

% cell 57: CF = 2800Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-113,-113]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% (very!) slight dip in rate curve, removed first 3 subseq
% NSPL 
% tag 2 (some noise in SAC)
List = struct('filename','D0208','iseqp',num2cell([-102,-102,-102,-102,-102,-102]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -114: extreme noise

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-117,-117,-117]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-118,-118,-118,-118]),'isubseqn',num2cell([1,2,3,4]),'discernvalue',num2cell([10,30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 58: CF = 2600Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -119: extreme noise

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-120,-120,-120]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-124,-124,-124]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 59: CF = 1723Hz -------------------------------------------------------------------------------------------------------------------------------------------

% (very!) slight dip in rate curve, removed first 3 subseq
% NSPL 
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-125,-125,-125,-125,-125]),'isubseqp',num2cell([4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% slight decrease in rate as intensity  increases
% A+
% tag 1 (good SAC, slight decrease in rate as intensity  increases)
List = struct('filename','D0208','iseqp',num2cell([-126,-126]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 63: CF = 375Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-129,-129]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -130: cell lost

% cell 66: CF = 570Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-132,-132]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cell 70: CF = 2300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-135,-135]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 3 subseq
% NSPL 
% tag 3 (heavy noise in SAC, good primary/secondary peaks
List = struct('filename','D0208','iseqp',num2cell([-136,-136,-136,-136]),'isubseqp',num2cell([4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 71: CF = 1700Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-138,-138]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 3 subseq
% NSPL 
% tag 3 (heavy noise in SAC, good primary/secondary peaks
List = struct('filename','D0208','iseqp',num2cell([-139,-139,-139,-139]),'isubseqp',num2cell([4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 72: CF = 2000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-141,-141]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 4 subseq
% NSPL 
% tag 3 (heavy noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-142,-142,-142,-142]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-145,-145]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 76: CF = 1300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% (very!) slight decrease in rate as intensity increases
% A+
% tag 1 (very good SAC)
List = struct('filename','D0208','iseqp',num2cell([-148,-148]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % trigger problems, no refr.per.: commented out
% % A-
% % tag 1 (good SAC)
% List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-149,-149]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,30]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 78: CF = 7500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-150,-150]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-151,-151]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-152,-152]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-153,-153]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 81: CF = 2170Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-154,-154]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -155: extreme noise

% % peak in SAC disappears at 70dB: commented out
% % (very!) slight decrease in rate as intensity increases
% % A-
% % tag 3 (very small peaks in SAC, rate decreases as intensity increases)
% List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-158,-158]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 83: CF = 2600Hz -------------------------------------------------------------------------------------------------------------------------------------------

% (very!) slight decrease in rate as intensity increases
% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-160,-160]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 2 subseq
% NSPL 
% tag 2 (noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-161,-161,-161,-161,-161,-161]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 87: CF = 862Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-164,-164]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 5 subseq
% NSPL 
% tag 2 (noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-165,-165,-165]),'isubseqp',num2cell([6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % trigger problems in 60 dB subseq: commented out
% % A-
% % tag 1 (good SAC)
% List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-170,-170]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([60,40]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 88: CF = 1306Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-171,-171]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 5 subseq
% NSPL 
% tag 2 (noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-172,-172,-172]),'isubseqp',num2cell([6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-175,-175]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 89: CF = 989Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-176,-176]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 4 subseq
% NSPL 
% tag 2 (noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-177,-177,-177,-177]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -180: cell lost

% cell 90: CF = 1900Hz -------------------------------------------------------------------------------------------------------------------------------------------

% slight decrease in rate as SPL  increases
% A+
% tag 1 (good SAC, slight decrease in rate as SPL  increases)
List = struct('filename','D0208','iseqp',num2cell([-182,-182]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% dip in rate curve at higher intensities: losing cell
% removed first 3 and last 1 subseq
% NSPL 
% tag 2 (noise in SAC, good primary/secondary peaks)
List = struct('filename','D0208','iseqp',num2cell([-183,-183,-183,-183]),'isubseqp',num2cell([4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 91: CF = 652Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-185,-185]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 4 subseq
% NSPL 
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-186,-186,-186,-186]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-189,-189]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 94: CF = 3000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-190,-190]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 2 subseq
% NSPL 
% tag 3 (heavy noise, clear peaks)
List = struct('filename','D0208','iseqp',num2cell([-191,-191,-191,-191,-191,-191]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-194,-194]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 95: CF = 1741Hz -------------------------------------------------------------------------------------------------------------------------------------------
 
% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-195,-195]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % trigger problems in 70dB subseq: commented out 
% % A-
% % tag 1 (good SAC)
% List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-196,-196]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 98: CF = 1115Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-200,-200]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 5 subseq
% NSPL 
% tag 3 (heavy noise, clear primary peaks)
List = struct('filename','D0208','iseqp',num2cell([-201,-201,-201,-201,-201]),'isubseqp',num2cell([5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 100: CF = 540Hz -------------------------------------------------------------------------------------------------------------------------------------------

% A+
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',num2cell([-203,-203]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed 30 dB subseq: no spikes
% A-
% tag 1 (good SAC)
List = struct('filename','D0208','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-206,-206]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0212: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 2: CF = 345Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed first 2 subseq (no SAC due to lack of spikes)
% NSPL 
% tag 2 (noise in SAC, clear peaks)
List = struct('filename','D0212','iseqp',num2cell([-1,-1,-1]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SAC)
List = struct('filename','D0212','iseqp',num2cell([-2,-2]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A+
% tag 1 (very small peak at 40dB)
List = struct('filename','D0212','iseqp',num2cell([-4,-4]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% removed first 2 subseq (no SAC due to lack of spikes) and last subseq (sudden drop in rate, cell lost)
% nspl S
% tag 1 (good SAC, sudden drop in rate curve at 80 dB: losing cell?)
List = struct('filename','D0212','iseqp',num2cell([-5,-5,-5]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% sudden drop at highest intensity: losing cell? Last subseq removed
% A-
% tag 2 (sudden drop at highest intensity: losing cell?)
List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-6,-6]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 4: CF = 1650Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % lost cell: don't use dataset (hence: commented out)
% % NSPL 
% % tag 2 (noise in SAC, clear peaks)
% List = struct('filename','D0212','iseqp',num2cell([-10,-10,-10,-10,-10,-10]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 5: CF = 824Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% SAC: pure noise
% % NSPL 
% % tag 3 (nothing but noise in SAC)
% List = struct('filename','D0212','iseqp',num2cell([-11,-11,-11,-11,-11,-11]),'isubseqp',num2cell([1,2,3,4,5,6]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;


% ds -12 : extreme noise in SAC

% A+
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',num2cell([-13,-13,-13]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% ds -15: extreme noise in SAC

% A-
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-16,-16,-16]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-17,-17]),'isubseqn',num2cell([1,2]),'discernvalue',num2cell([30,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -18: extreme noise in SAC

% cell 8: CF = 900Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% sudden drop in rate at 80dB: cell lost. Removed subseq
% first 2 subseq removed: noisy SAC
% NSPL 
% tag 1 (noise in SAC, clear peaks)
List = struct('filename','D0212','iseqp',num2cell([-21,-21,-21]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% check raster plot at 60dB: trigger problems?
% A+
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',num2cell([-23,-23,-23]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% A-
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-24,-24,-24]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 10: CF = 500Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% first 2 subseq removed: no peak in SAC (due to lack of spikes at lower intensities)
% NSPL 
% tag 2 (lots of noise in SAC, clear peaks)
List = struct('filename','D0212','iseqp',num2cell([-33,-33,-33,-33]),'isubseqp',num2cell([3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+
% tag 1 (good SACs)
List = struct('filename','D0212','iseqp',num2cell([-34,-34,-34]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% cave: rate drops slightly at 80dB intensity
% A-
% tag 1 (good SACs, rate drops slightly at 80dB intensity)
List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-36,-36,-36]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 11: CF = 530Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% ds -40: extreme noise in SAC

% ds -41: extreme noise in SAC

% cell 15: CF = 454Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% first 3 subseq removed: no peak in SAC (due to lack of spikes at lower intensities)
% NSPL 
% tag 2 (clear peaks)
List = struct('filename','D0212','iseqp',num2cell([-45,-45,-45]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% check ISI histogram at 70dB: spikes during refr. per.!
% A+
% tag 2 (good SACs, spikes during refr. per. ISI)
List = struct('filename','D0212','iseqp',num2cell([-46,-46,-46]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);
pause;close all;

% % spikes during refr.per. at all intensities: commented out.
% % A-
% % tag 1 (good SACs, rate drops slightly at 80dB intensity)
% List = struct('filename','D0212','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-48,-48,-48]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,70,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% ds -51: extreme noise in SAC

% ds -53: extreme noise in SAC

% ds -56: extreme noise in SAC

% cell 21: CF = 600Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % commented out: spikes in refr. per.
% % first 2 subseq removed: no peak in SAC (due to lack of spikes at lower intensities)
% % last 2 subseq removed: cell lost (no more spikes)
% % NSPL 
% % tag 2 (clear peaks)
% List = struct('filename','D0212','iseqp',num2cell([-57,-57]),'isubseqp',num2cell([3,4]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% ds -58: cell lost

% ds -61: extreme noise in SAC

% ds -62: cell lost

% ds -63: no SACs (no spikes)

% ---------------------------------------------------------------------------------|
% 33 to 40: datasets should not be used for analysis (check experiment log book)|
% ---------------------------------------------------------------------------------|


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0215: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 6: CF = 955Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 2 subseq.
% NSPL 
% tag 1 (some noise in SAC, clear peaks)
List = struct('filename','D0215','iseqp',num2cell([-1,-1,-1,-1,-1,-1]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 9: CF = 517Hz -------------------------------------------------------------------------------------------------------------------------------------------

% (slight) decrease in rate as intensity increases!
% removed first 3 subseq.
% NSPL 
% tag 1 (some noise in SAC, clear peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-2,-2,-2,-2,-2,-2]),'isubseqp',num2cell([4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-4,-4]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 14: CF = 1071Hz -------------------------------------------------------------------------------------------------------------------------------------------

% first 2 subseq removed (lack of spikes)
% NSPL 
% tag 1 (some noise in SAC, clear peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-6,-6,-6,-6,-6,-6]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-7,-7,-7]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,40,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-9,-9,-9]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,40,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 15: CF = 1189Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: rate drops at highest intensity: losing cell?
% first subseq removed (lack of spikes)
% NSPL 
% tag 1 (some noise in SAC, clear peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-11,-11,-11,-11,-11,-11]),'isubseqp',num2cell([2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-12,-12]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,40]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-14,-14]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-15,-15,-15,-15]),'isubseqn',num2cell([1,2,3,4]),'discernvalue',num2cell([30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 18: CF = 1610Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds 18: extreme noise in SAC

% ds 19: extreme noise in SAC

% cell 19: CF = 1610Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: rate drops at higher intensities
% first 2 subseq removed (lack of spikes)
% NSPL 
% tag 2 (noise in SAC, good peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-20,-20,-20,-20,-20,-20,-20]),'isubseqp',num2cell([3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: rate drops at higher intensity
% A+ 
% tag 1 (good SAC. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-21,-21]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 22: CF = 588Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: rate drops at highest intensity
% first 2 subseq removed (lack of spikes)
% NSPL 
% tag 2 (noise in SAC, good peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-23,-23,-23,-23,-23,-23]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-25,-25]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,30]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 26: CF = 4500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds  -30: extreme noise in SAC

% cave: rate drops at highest intensity
% first 2 subseq removed (lack of spikes)
% NSPL 
% tag 2 (noise in SAC, good peaks. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-31,-31,-31,-31,-31,-31]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% slight decrease in rate at 60dB
% A+ 
% tag 1 (good SAC, some spikes in refr. per. ISI)
List = struct('filename','D0215','iseqp',num2cell([-32,-32,-32]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,40,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % lots of spike activity during refr. per: commented out
% % A-
% % tag 1 (good SAC)
% List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-33,-33,-33]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([20,40,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% ds -35: spikes during refr. per.

% ds -37: dip in rate curve, extremely noisy SAC

% ds -37: dip in rate curve, spikes during refr. per

% ds -41: lost cell

% ds -42: lost cell, extremely noisy SAC

% ds -43: extreme noise in SAC

% ds -44: dip in rate curve, extreme noise in SAC (no peaks)

% ds -45: losing cell, spikes in refr. per.

% ds -48: losing cell, spikes in refr. per.
% cell 32: CF = 1486Hz -------------------------------------------------------------------------------------------------------------------------------------------

% cave: rate drops at highest intensity
% removed first 2 subseq
% NSPL 
% tag 2 (good SACs. Cave: slight decrease in rate as intensity increases)
List = struct('filename','D0215','iseqp',num2cell([-53,-53,-53,-53,-53,-53,-53]),'isubseqp',num2cell([3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 36: CF = 1340Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 6 subseq (insufficient spikes)
% NSPL 
% tag 1 (good SACs)
List = struct('filename','D0215','iseqp',num2cell([-57,-57,-57,-57]),'isubseqp',num2cell([7,8,9,10]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% trigger problems in 30dB subseq: subseq removed
% A+ 
% tag 1 (good SAC, third subseq displays trigger problems)
List = struct('filename','D0215','iseqp',num2cell([-58,-58]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 38: CF = 3920Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -61: extreme noise in SAC

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-62,-62,-62]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -63: spikes in refr. per.

% ds -64: spikes in refr. per.

% cell 41: CF = 1100Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 4 subseq
% NSPL 
% tag 3 (noise in SACs, good peaks)
List = struct('filename','D0215','iseqp',num2cell([-66,-66,-66,-66]),'isubseqp',num2cell([5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 44: CF = 3920Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -70: extreme noise in SAC (no peaks)

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-71,-71,-71]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-72,-72,-72]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 46: CF = 14.860Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 5 subseq (insufficient spikes)
% NSPL 
% tag 3 (heavy noise in SACs, clear peaks)
List = struct('filename','D0215','iseqp',num2cell([-76,-76,-76,-76]),'isubseqp',num2cell([6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-77,-77]),'isubseqp',num2cell([2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq
% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-78,-78]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 47: CF = 7135Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -80: extreme noise in SAC (no peaks)

% removed first subseq
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-81,-81]),'isubseqp',num2cell([2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq
% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-83,-83]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 48: CF = 24.367Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -85: extreme noise in SAC (no peaks)

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-86,-86,-86]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq
% A-
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-87,-87]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 49: CF = 2639Hz -------------------------------------------------------------------------------------------------------------------------------------------

% commented out: bad WF
% % A+ 
% % tag 1 (good SAC)
% List = struct('filename','D0215','iseqp',num2cell([-89,-89,-89]),'isubseqp',num2cell([1,2,3]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% % commented out: bad WF
% % A-
% % tag 1 (good SAC)
% List = struct('filename','D0215','iseqp',NaN,'isubseqp',NaN,...
%     'iseqn',num2cell([-90,-90,-90]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,80,100]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% cell 53: CF = 20.306Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -94: extreme noise in SAC: no peaks

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0215','iseqp',num2cell([-95,-95]),'isubseqp',num2cell([1,2]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0217: no NRHObb data
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 2: CF = 38.000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -3: extreme noise in SAC

% cave: drop in rate at highest intensity: losing cell?
% removed first three subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-4,-4,-4]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,100,110]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: drop in rate at highest intensity: losing cell? removed last subseq
% removed first two subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-5,-5]),'isubseqn',num2cell([2,3]),'discernvalue',num2cell([90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -7: extreme noise in SAC

% ds -8: extreme noise in SAC

% cell 5: CF = 3300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -13: extreme noise in SAC

% removed first three subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-14,-14,-14]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 6: CF = 9612Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -16: extreme noise in SAC

% removed first three subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-17,-17,-17]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first two subseq (no SAC due to lack of spikes)
% B+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-18,-18,-18,-18]),'isubseqp',num2cell([3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 8: CF = 5305Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -21: extreme noise in SAC

% removed first three subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-22,-22,-22,-22,-22,-22,-22,-22]),'isubseqp',num2cell([4,5,6,7,8,9,10,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 9: CF = 4921Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -24: extreme noise in SAC

% removed first three subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-25,-25,-25]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,100,110]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 10: CF = 10.000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -27: extreme noise in SAC

% removed first two subseq (no SAC due to lack of spikes)
% A+ 
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0217','iseqp',num2cell([-28,-28,-28,-28,-28,-28]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -30: extreme noise in SAC

% ds -31: extreme noise in SAC

% cell 12: CF = 11.500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -33: extreme noise in SAC

% ds -34: inexplicable "dip" in rate curve, lots of noise in SAC, losing cell at highest intensity

% ds -37: extreme noise in SAC (no peaks)

% ds -39: extreme noise in SAC (no peaks)

% ds -40: cell lost

% cell 18: CF = 12.300Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -43: extreme noise in SAC (no peaks)

% A+ 
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0217','iseqp',num2cell([-44,-44,-44,-44,-44,-44,-44]),'isubseqp',num2cell([1,2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-45,-45,-45,-45,-45,-45,-45]),'isubseqn',num2cell([1,2,3,4,5,6,7]),'discernvalue',num2cell([30,40,50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 20: CF = 6500Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -47: extreme noise in SAC (no peaks)

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-48,-48,-48,-48,-48,-48]),'isubseqp',num2cell([2,3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,40,55,70,85,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-49,-49,-49,-49,-49,-49]),'isubseqn',num2cell([2,3,4,5,6,7]),'discernvalue',num2cell([25,40,55,70,85,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 21: CF = 5360Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -51: extreme noise in SAC (no peaks)

% removed first 2 subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-52,-52,-52,-52,-52,-52,-52]),'isubseqp',num2cell([3,4,5,6,7,8,9]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 22: CF = 6155Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -54: extreme noise in SAC 

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-55,-55,-55,-55,-55]),'isubseqp',num2cell([2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: slight drop in rate curve at highest intensity: losing cell?
% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-56,-56,-56,-56,-56]),'isubseqn',num2cell([2,3,4,5,6]),'discernvalue',num2cell([20,30,40,50,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 23: CF = 1350Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -58: extreme noise in SAC

% cave: slight drop in rate curve at highest intensity
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-59,-59,-59]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: drop in rate curve at highest intensity: losing cell
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-60,-60,-60]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([40,60,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 24: CF = 11.400Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -62: extreme noise in SAC

% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-63,-63,-63]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 25: CF = 5305Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -65: extreme noise in SAC 

% removed first 2 subseq (no SAC due to lack of spikes)
% A+ 
% tag 2 (good SAC, minor noise)
List = struct('filename','D0217','iseqp',num2cell([-66,-66,-66,-66,-66]),'isubseqp',num2cell([3,4,5,6,7]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 26: CF = 5305Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -68: extreme noise in SAC (no peaks)

% cave: drop in rate at highest intensity: losing cell?
% removed first 2 subseq (no SAC due to lack of spikes)
% A+ 
% tag 2 (good SAC, minor noise)
List = struct('filename','D0217','iseqp',num2cell([-69,-69,-69]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 28: CF = 1723Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -71: extreme noise in SAC

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-72,-72,-72,-72]),'isubseqp',num2cell([2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first 2 subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-73,-73,-73]),'isubseqn',num2cell([3,4,5]),'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first 2 subseq (no SAC due to lack of spikes)
% B+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-74,-74,-74]),'isubseqp',num2cell([3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first 2 subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-75,-75,-75]),'isubseqn',num2cell([3,4,5]),'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 30: CF = 1218Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -78: extreme noise in SAC (peaks, but noise makes SACs useless)

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-79,-79,-79,-79,-79]),'isubseqp',num2cell([2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,50,65,80,95]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-80,-80,-80,-80]),'isubseqn',num2cell([2,3,4,5]),'discernvalue',num2cell([35,50,65,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 33: CF = 5734Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -85: extreme noise in SAC (peaks, but noise makes SACs useless)

% ds -86: lots of spikes in refr. per. ISI

% ds -87: lots of spikes in refr. per. ISI

% cell 34: CF = 1218Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -89: extreme noise in SAC (peaks, but noise makes SACs useless)

% cave: slight decrease in rate at highest intensity
% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-90,-90,-90]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 37: CF = X Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -94: extreme noise in SAC (no peaks)

% ds -95: extreme noise in SAC (no peaks) + cell lost at higher intensities

% ds -96: extreme noise in SAC (no peaks) + cell lost at higher intensities

% cell 39: CF = 10.800Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -98: extreme noise in SAC (no peaks)

% ds -99: extreme noise in SAC: peaks, but noise makes SAC useless

% ds -100: stimulusproblem: check experiment log book

% cave: triggerproblems in 60 and 70dB ISI
% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-101,-101,-101,-101]),'isubseqn',num2cell([2,3,4,5]),'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 40: CF = 1326Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -103: extreme noise in SAC (no peaks)

% ds -104: lots of spikes in refr. per. ISI, cell lost at higher intensities

% ds -105: incomplete data collection

% cell 41: CF = 21.760Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -107: extreme noise in SAC (no peaks)

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-108,-108,-108]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-109,-109,-109]),'isubseqn',num2cell([2,3,4]),'discernvalue',num2cell([50,70,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -111: extreme noise in SAC

% cell 47: CF = 284Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 3 subseq (no SAC due to lack of spikes)
% NSPL
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-117,-117,-117]),'isubseqp',num2cell([4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-118,-118,-118,-118,-118]),'isubseqp',num2cell([2,3,4,5,6]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,90,100,110]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -119: lost cell

% cell 48: CF = 9000Hz -------------------------------------------------------------------------------------------------------------------------------------------
% chopper

% ds -121: extreme noise in SAC (peaks, but noise makes SAC useless)

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',num2cell([-122,-122,-122]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% slight decrease in rate at highest intensity: losing cell?
% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-123,-123,-123]),'isubseqn',num2cell([2,3,4]),'discernvalue',num2cell([30,50,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 49: CF = 28.000Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -125: extreme noise in SAC, no peaks

% ds -126: losing cell + very small peaks in SAC (calculated shifts are inaccurate due to small peaks)

% ds -127: losing cell + very small peaks in SAC (calculated shifts are inaccurate due to small peaks)

% cell 51: CF = 2640Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -129: extreme noise in SAC

% removed first subseq (no SAC due to lack of spikes)
% A+ 
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',num2cell([-130,-130,-130]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-131,-131,-131]),'isubseqn',num2cell([2,3,4]),'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 52: CF = 895Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed first 2 subseq (no SAC due to lack of spikes)
% NSPL
% tag 3 (very noisy SAC, good peaks)
List = struct('filename','D0217','iseqp',num2cell([-133,-133,-133,-133,-133,-133]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,60,70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A+
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-134,-134,-134,-134]),'isubseqp',num2cell([2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 53: CF = 13.641Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -136: extreme noise in SAC (no peaks)

% A+
% tag 1 (good SAC)
List = struct('filename','D0217','iseqp',num2cell([-137,-137,-137,-137,-137]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,70,80,90,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 54: CF = 2640Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -139: extreme noise in SAC (no peaks)

% A+
% tag 3 (lots of noise in SAC, small (but clear) peaks)
List = struct('filename','D0217','iseqp',num2cell([-140,-140,-140]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% A-
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-141,-141,-141]),'isubseqn',num2cell([1,2,3]),'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 55: CF = 7800Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -143: extreme noise in SAC (peaks become useless due to excessive noise)

% removed first subseq (no SAC due to lack of spikes)
% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',num2cell([-144,-144,-144]),'isubseqp',num2cell([2,3,4]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed first subseq (no SAC due to lack of spikes)
% A-
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-145,-145,-145]),'isubseqn',num2cell([2,3,4]),'discernvalue',num2cell([60,80,100]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 56: CF = 2760Hz -------------------------------------------------------------------------------------------------------------------------------------------

% ds -147: extreme noise in SAC (peaks become useless due to excessive noise)

% cave: rate decreases (slightly) at highest intensity: losing cell?
% A+
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',num2cell([-148,-148,-148,-148,-148]),'isubseqp',num2cell([1,2,3,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cave: rate decreases (slightly) at highest intensity: losing cell?
% A-
% tag 2 (good SAC, some noise)
List = struct('filename','D0217','iseqp',NaN,'isubseqp',NaN,...
    'iseqn',num2cell([-149,-149,-149,-149,-149]),'isubseqn',num2cell([1,2,3,4,5]),'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0408
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPLBB data
%==============================================================================================================================================================

% % NSPLBB 
% % tag 3 (very noisy SACs, no clear peaks)
% List = struct('filename','D0408','iseqp',num2cell([-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% NSPLBB 
% tag 2 (sub-50dB: small firing rates, hence bad SACs. Subsequences removed)
List = struct('filename','D0408','iseqp',num2cell([-15,-15,-15,-15,-15,-15,-15,-15,-15]),'isubseqp',num2cell([9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,55,60,65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 2 (sub-60dB: small firing rates, hence bad SACs. Subsequences removed)
List = struct('filename','D0408','iseqp',num2cell([,-15,-15,-15,-15,-15,-15,-15]),'isubseqp',num2cell([9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 12: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0408', [16;19;22], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 17: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0408', [33;36;37], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 18: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0408', [41;45], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0409
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPLBB data
%==============================================================================================================================================================

% NSPLBB 
% tag 3 (very noisy SACs but clear peaks)
List = struct('filename','D0409','iseqp',num2cell([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% Cave: removed all sub-50dB subsequences!
% NSPLBB 
% tag 3 (very noisy SACs, no clear peaks below 50dB, okay peaks above 50dB)
List = struct('filename','D0409','iseqp',num2cell([-13,-13,-13,-13,-13,-13,-13]),'isubseqp',num2cell([2,4,7,9,10,13,14]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,80,50,55,70,60,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% !! Cave: removed subsequences 0, 5 and 10dB: excessive noise causes Matlab to pick the "wrong" peak as primary peak
% NSPLBB 
% tag 2 (noisy SACs but clear peaks)
List = struct('filename','D0409','iseqp',num2cell([-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17]),'isubseqp',num2cell([1,3,4,5,6,7,8,9,11,12,13,14,15,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([75,25,15,80,40,30,65,55,35,45,70,50,20,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% !! Cave: removed 5 lowest-intensity subsequences due to excessive noise
% NSPLBB 
% tag 3 (SACs but clear peaks; 5 lowest intensity subseq removed)
List = struct('filename','D0409','iseqp',num2cell([-21,-21,-21,-21,-21,-21,-21,-21]),'isubseqp',num2cell([1,5,6,7,8,10,11,13]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,65,80,60,50,45,75,55]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 2 (noisy SACs but clear peaks (warning: 2 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-28,-28,-28,-28,-28,-28,-28,-28,-28,-28,-28,-28,-28,-28,-28]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,55,25,65,40,15,70,35,80,30,75,10,60,45,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 1 (clear peaks (warning: 2 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,60,45,20,40,15,30,80,5,50,25,35,75,70,10,65]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 1 (clear peaks (warning: 2 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-34,-34,-34,-34,-34,-34,-34,-34,-34,-34,-34]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([75,60,40,85,55,65,35,45,70,80,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 1 (good peaks (warning: 2 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37,-37]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([5,80,55,25,20,50,35,70,10,75,60,65,45,30,15,40,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 1 (good peaks (warning: 2 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42,-42]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,75,5,45,10,0,30,15,80,60,40,35,25,65,20,55,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 1 (good correlograms (warning: 4 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45,-45]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([75,5,10,55,25,0,65,40,30,20,70,50,15,60,80,35,45]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% NSPLBB 
% tag 3 (noisy corr. (warning: 3 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-62,-62,-62,-62,-62,-62,-62,-62,-62,-62,-62,-62,-62,-62,-62]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,10,60,15,55,45,75,25,65,35,80,30,40,70,20]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% % NSPLBB 
% % tag 3 (very noisy)
% List = struct('filename','D0409','iseqp',num2cell([-69,-69,-69,-69,-69,-69,-69,-69,-69,-69,-69,-69,-69,-69,-69]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,35,75,45,50,80,40,30,70,25,20,65,10,15,60]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% % NSPLBB 
% % tag 3 (extremely noisy)
% List = struct('filename','D0409','iseqp',num2cell([-72,-72,-72,-72,-72,-72,-72,-72,-72,-72,-72,-72,-72,-72,-72]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([20,50,45,70,35,15,65,75,80,30,55,25,60,40,10]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
% pause;close all;

% !! 6 lowest intensities should be commented/edited out (excessive noise --> incorrect peakshift)
% NSPLBB 
% tag 3 (noisy corr. (warning: 6 lowest intensities have "no" primary peak)
List = struct('filename','D0409','iseqp',num2cell([-87,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87,-87]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([70,80,50,60,55,75,40,30,10,25,20,65,15,35,45]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 1: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [2;5;9;10], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 3: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [21;25], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 4: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [27;28], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 5: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0409', [32;42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 6: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [44;46], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 7: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [48;50], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 10: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [58;60;63;64], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 12: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0409', [69;72;74], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 19: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0409', [99;101], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 41: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0409', [143;146;149], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0412
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% ds -10: extremely noisy SAC

% cell 13: CF = 27.460Hz -------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 50dB and 60dB (no SAC)
% NSPL 
% tag 3 (warning: some subseq have "no" SAC)
List = struct('filename','D0412','iseqp',num2cell([-18,-18,-18]),'isubseqp',num2cell([2,4,5]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([90,80,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% removed three lowest intensities
% NSPL 
% tag 3 (extremely noisy SAC)
List = struct('filename','D0412','iseqp',num2cell([-19,-19,-19]),'isubseqp',num2cell([1,2,3]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,60,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% ds -20: extremely noisy SAC

%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 7: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [13;14], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 8: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [17;18;19], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 9: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [25;27], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 12: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [34;35;36], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 13: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [39;40;41;47;48], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 14: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [75;76;77;78;79], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 15: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [84;85;86], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 16: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [90;91;92;93;99], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 17: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [101;102;103;104;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 21: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [113;114], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 22: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [116;117], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 28: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [124;126;127;128], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 29: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [130;131;132;133], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 32: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [139;140;141], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 33: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [144;146], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 35: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [151;152], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 36: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [155;156], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 38: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [159;160], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 39: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [164;165], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 41: tag 2 (needs check-up)-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [169;170;173;177], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 48: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [186;187;188], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 49: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [190;191;192], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 54: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [202;203;204], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 58: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [206;208], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 59: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [211;212;213;214], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 61: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [218;219], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 62: tag 2 (needs check-up!)-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0412', [221;222], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 63: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [226;227], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 66: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0412', [231;232], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0413
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% ds -15 and ds -16: extremely noisy SAC. ds should be avoided

%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 5: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0413', [12;13], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 6: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0413', [17;18;19], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 14: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0413', [42;44], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 19: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0413', [51;52], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 24: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0413', [58;59], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0414
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 5: 10.584Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0414','iseqp',num2cell([-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6,-6]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 7: 10.755Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (extreme noise in SAC, good peaks)
List = struct('filename','D0414','iseqp',num2cell([-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9,-9]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 9: 17.924Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% NSPL
% tag 3 (extreme noise in SAC, good peaks)
List = struct('filename','D0414','iseqp',num2cell([-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14,-14]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 10: 7701Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % subseq 1 = -5 SPL: removed. Extreme noise in SACs: commented out
% % NSPL
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0414','iseqp',num2cell([-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17,-17]),'isubseqp',num2cell([2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 12: 4547Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SACs: commented out
% % NSPL
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0414','iseqp',num2cell([-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20,-20]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 19: 2532Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% % Extreme noise in SACs: commented out
% % NSPL
% % tag 3 (extreme noise in SAC)
% List = struct('filename','D0414','iseqp',num2cell([-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26,-26]),'isubseqp',num2cell([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]),...
%     'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80]));
% T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','no','smoothing',smoothing,'spline',spline); 
% D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 22: 592Hz. Not used: all SACs are noisy, or cells are lost at higher dB's

%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 3: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [9;10;11], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 4: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [13;14;15], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 5: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [18;19;20], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 10: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [33;36;37], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 12: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [41;42], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 19: tag 1! -------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0414', [54;56;63], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 33: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [92;93;94], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 34: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0414', [96;97], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 35: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [101;102], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 38: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0414', [106;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                      
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 43: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [114;115], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 44: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [122;123;124], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 63: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [157;158], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                        
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 65: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [163;165], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;
% 
% % cell 73: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0414', [179;180;181], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 75: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0414', [186;189], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

%==============================================================================================================================================================
%==============================================================================================================================================================
% D0418
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 1: 28.700Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 45 to 80dB as well as 90dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-6,-6,-6]),'isubseqp',num2cell([8,9,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([80,85,95]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 5: 14.948Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 10 to 35dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-6,-6,-6,-6,-6,-6,-6,-6,-6]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 6: 10.200Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq -5 to 25dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-18,-18,-18,-18,-18,-18,-18,-18,-18,-18,-18]),'isubseqp',num2cell([8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 8: 887Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 0 to 40dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-26,-26,-26,-26,-26,-26,-26,-26]),'isubseqp',num2cell([10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 11: 13.300Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 0 to 35dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-32,-32,-32,-32,-32,-32,-32,-32,-32]),'isubseqp',num2cell([9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 36: 37.371Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 0dB to 55dB
% cave: dip in rate curve at higher intensities
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-74,-74,-74,-74,-74,-74,-74]),'isubseqp',num2cell([10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([60,65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 43: 6105Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 0dB to 30dB as well as 90dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-94,-94,-94,-94,-94]),'isubseqp',num2cell([4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,50,60,70,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 48: 1948Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% removed subseq 0dB to 40dB
% NSPLBB
% tag 3 (noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-104,-104,-104,-104,-104,-104,-104,-104,]),'isubseqp',num2cell([10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,50,55,60,65,70,75,80]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 51: 556Hz ----------------------------------------------------------------------------------------------------------------------------------------------

% cave: small decrease in rate at higher intensities: losing cell?
% removed subseq 0dB to 45dB
% NSPLBB
% tag 2 (some noise in SAC, good peaks)
List = struct('filename','D0418','iseqp',num2cell([-110,-110,-110,-110,-110,-110,-110,-110,]),'isubseqp',num2cell([7,8,9,10,11,12,13,14]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% cell 3: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [7;8], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 5: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [16;17;18], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 7: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [21;22], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 8: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [24;25], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 9: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [27;28], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 11: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [31;32;33;40], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 16: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [80;81], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 20: tag 1-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [94;95;96], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 33: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [113;114], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 36: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [121;122], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 37: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [124;125;126], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 38: tag 1-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [128;129;130], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 39: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [132;133;134], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 47: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [149;150;152], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 48: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [155;156;157;158], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 51: tag 1-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0418', [164;166;167], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 53: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0418', [171;172], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0419
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 1: CF = 14.122Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPLBB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-2,-2,-2,-2,-2,-2]),'isubseqp',num2cell([7,8,9,10,11,12]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 2: CF = 25.621Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPLBB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-10,-10,-10,-10,-10,-10,-10,-10]),'isubseqp',num2cell([11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([40,45,50,55,60,65,70,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 3: CF = 4467Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-14,-14,-14,-14,-14,-14,-14,-14,-14,-14]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 6: CF = 14.025Hz -------------------------------------------------------------------------------------------------------------------------------------------
% cave: slight decrease in rate as SPL increases
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-28,-28,-28,-28,-28,-28,-28,-28,-28]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 19: CF = 1296Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 3 (extreme noise yet peaks are clearly distinguishable)
List = struct('filename','D0419','iseqp',num2cell([-64,-64,-64,-64,-64,-64,-64,-64]),'isubseqp',num2cell([4,5,6,7,8,9,10,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([55,60,65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 26: CF = 3415Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPLBB 
% tag 2 (some noise, overall good SAC)
List = struct('filename','D0419','iseqp',num2cell([-77,-77,-77,-77,-77,-77,-77,-77,-77,-77,-77]),'isubseqp',num2cell([8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 27: CF = 24974Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, overall good SAC)
List = struct('filename','D0419','iseqp',num2cell([-80,-80,-80,-80,-80,-80,-80,-80,-80,-80,-80,-80]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 28: CF = 3660Hz -------------------------------------------------------------------------------------------------------------------------------------------
% cave: (slight) decrease in rate at highest intensities
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, overall good SAC)
List = struct('filename','D0419','iseqp',num2cell([-84,-84,-84,-84,-84,-84,-84,-84,-84,-84,-84,-84]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 29: CF = 13.453Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-90,-90,-90,-90,-90,-90,-90,-90,-90,-90,-90,-90]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 33: CF = 11.687Hz -------------------------------------------------------------------------------------------------------------------------------------------
% cave: (slight) decrease in rate at highest intensities
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, overall good SAC)
List = struct('filename','D0419','iseqp',num2cell([-95,-95,-95,-95,-95,-95,-95,-95,-95,-95,-95]),'isubseqp',num2cell([8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 35: CF = 3035Hz -------------------------------------------------------------------------------------------------------------------------------------------
% cave: dip in rate curve (at about 60 to 75 dB)
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-106,-106,-106,-106,-106,-106,-106,-106,-106,-106,-106]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16,17]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 38: CF = 3922Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-114,-114,-114,-114,-114,-114,-114,-114,-114,-114,-114,-114]),'isubseqp',num2cell([5,6,7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([30,35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 39: CF = 31.384Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-117,-117,-117,-117,-117,-117,-117]),'isubseqp',num2cell([8,9,10,11,12,13,14]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([45,50,55,60,65,70,75]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 40: CF = 8350Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-122,-122,-122,-122,-122,-122,-122,-122,-122,-122]),'isubseqp',num2cell([7,8,9,10,11,12,13,14,15,16]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([25,30,35,40,45,50,55,60,65,70]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 45: CF = 200Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-133,-133,-133,-133,-133,-133]),'isubseqp',num2cell([3,4,5,6,7,8]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 46: CF = 233Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-142,-142,-142,-142,-142,-142]),'isubseqp',num2cell([6,7,8,9,10,11]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([65,70,75,80,85,90]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;

% cell 47: CF = 738Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419','iseqp',num2cell([-148,-148,-148,-148,-148,-148,-148,-148,-148]),'isubseqp',num2cell([2,3,5,6,7,8,9,10,12]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([50,45,40,65,70,75,55,80,60]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 1: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [1;2;3;4;6], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 3: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [11;13;14], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 6: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [19;20;21;23;24], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 9: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [30;31;32], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 10: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [36;37;38], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 12: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [44;45], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 13: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [47;48;49;50;51], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 21: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [68;69], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 28: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [80;81;82], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 33: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [90;91;92;93], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 34: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [97;98], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 35: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [104;107], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 37: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [110;111], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 39: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [116;119;120;123], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 40: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [126;128;131;133;135;136], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 44: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [147;148;149], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 45: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [152;154;157], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 46: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [170;172;175], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 47: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [178;182;183], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 48: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [185;186;187], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 50: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [211;212;213], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 51: tag 2-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [216;220;221], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 53: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [225;226], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 56: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [230;231;232;239], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 59: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [245;246], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 60: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [249;250;251], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 61: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [254;255], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% cell 64: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [268;270], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 65: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [273;274;276;277], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% cell 66: tag 1!-------------------------------------------------------------------------------------------------------------------------------------------
List = GenWFList(struct([]), 'D0419', [281;282;285], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
close all;

% % cell 67: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [289;290;291;297], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 69: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419', [303;304;305], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;


%==============================================================================================================================================================
%==============================================================================================================================================================
% D0419B
%==============================================================================================================================================================
%==============================================================================================================================================================

%==============================================================================================================================================================
%                                                               NSPL data
%==============================================================================================================================================================

% cell 97: CF = 19.792Hz -------------------------------------------------------------------------------------------------------------------------------------------
% removed several subseq (rate drop-off, lack of SAC,...)
% NSPL BB
% tag 2 (some noise, good peaks)
List = struct('filename','D0419b','iseqp',num2cell([-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,-31,]),'isubseqp',num2cell([8,9,10,11,12,13,14,15,16,17,18]),...
    'iseqn',NaN,'isubseqn',NaN,'discernvalue',num2cell([35,40,45,50,55,60,65,70,75,80,85]));
T = genwfplotTF(List, 2, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline); 
D = [D; concatto1Row(ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm),'xval','yval','lag','normco','ppnormmagn','spnormmagn','spdelay')];%groupplot(D(numel(D)),'xval','yval','xlim',[30 90],'ylim',[-0.4 0.4]);%
pause;close all;


%==============================================================================================================================================================
%                                                               NRHOBB data
%==============================================================================================================================================================

% % cell 84: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419B', [17;18;22], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;

% % cell 97: tag 3-------------------------------------------------------------------------------------------------------------------------------------------
% List = GenWFList(struct([]), 'D0419B', [60;61], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');               
% T = genwfplotTF(List, 1, 'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL','plot','yes','smoothing',smoothing,'spline',spline);                       
% D = [D; ExtractPSentryTF(T, XFieldName, YFieldName, lagfn, normcofn, ppnm, spd, spnm)];groupplot(D(numel(D)), 'xval', 'yval','xlim',[30 90],'ylim',[-0.4 0.4]);pause;
% close all;


%================================================================================================================================================================
%================================================================================================================================================================


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
  
    g = getCF4Cell(D(i).ds1.filename, D(i).fibernr);
    D(i).cf = g.thr.cf;
end

%add new field 'difcor' to D and fill it
D(1).difcor=NaN;
for i=1:nd
    if (~isnan(D(i).ds1.iseqn))&(~isnan(D(i).ds1.iseqp)), D(i).difcor=1;
    else, D(i).difcor=0;
    end
end

%=====================================================================================================================================================
DLATTBCAT = D; clear('D');
save('pslatTBcatPM', 'DLATTBCAT');
%=====================================================================================================================================================

Ddif=DLATTBCAT;
Dnodif=DLATTBCAT;

%groupplot delay as a function of intensity
groupplot(Ddif, 'xval', 'yval', Dnodif, 'xval', 'yval', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('Intensity (dB SPL)');
ylabel('Delay (ms)');
title(['Plot-(delay,intensity) for TB data']);
hold off;

%groupplot slopes as a function of cf
groupplot(Ddif, 'cf', 'slope', Dnodif, 'cf', 'slope', 'markers', {'o', '*'}, 'colors', {'b','r'});
hold on;
xlabel('CF (Hz)');
ylabel('Slope (\mus/dB)');
title('Plot-(cf,slope) for TB data');
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


