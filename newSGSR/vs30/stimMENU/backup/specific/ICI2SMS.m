function SMS=ICI2SMS(idfSeq,calib);

% ICI2SMS - convert ICI menu parameters to SMS XXX

stimname = idfStimName(idfSeq.stimcntrl.stimtype);
StimCat = 'nclicks';
if ~isequal(stimname,'ici') ,
   error('not an ''ici'' stimulus type');
end

if nargin<2, calib = 'none'; end;
if nargin<3, randomize = 0; end;
[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);


% ICI sweep
RelTol = 0.1; % relative deviation of 10 % is tolerated without warning
[ICI, mess, newStartICI] = ...
   LogSweepChecker(scmn.start_ici, scmn.delta_ici, scmn.end_ici, 1, RelTol, 'start');
ICI=ICI(:,1); % linsweepchecker always returns Nx2 matrix
Nsubseq = size(ICI,1);

% ITDs

%------------frequencies---------------
% compute safe samplefreqs and filter indices
[samFreq, filterIndex] = safeSamplefreq(maxStimFreq); % highest sample rate available
samp = 1e6/samFreq;
% collect freq info in struct var
FREQ = CollectInStruct(samFreq, filterIndex);

% ----------CLICK TIMING-----------
% translate ICI/ITD combinations in per-channel timing of indiv clicks
ITD1 = scmn.itd1; % in ms contra vs ipsi
ITD2 = scmn.itd2; % in ms contra vs ipsi
delay1 = doubleDelay(ITD1); % [left right]
delay2 = doubleDelay(ITD2); % [left right]
ITD1 = delay1*[1; -1];  % left minus right
ITD2 = delay2*[1; -1];  % left minus right
LL = 1; RR = 2;
TclickLeft = [ICI*0 + ITD1/2, ICI + ITD2/2, ]; % columns: subseq; row: conseq clicks
TclickRight = [ICI*0 - ITD1/2, ICI - ITD2/2, ]; % columns: subseq; row: conseq clicks
% now shift so that first click is at t=0
GrandMin = min([TclickLeft(:); TclickRight(:)]);
Tleft = TclickLeft - GrandMin;
Tright = TclickRight - GrandMin;

%-----------various TIMING-----------------
repDur= sc.interval; 
clickDur = [s1.click_dur s2.click_dur]; 
burstDur = 2e-3*clickDur;
clickType = 2*(scmn.polarity-1/2); % 0|1 -> -1 | 1
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(repDur, burstDur, clickDur, clickType, onset);

% -------------------presentation, SPL--------------
PT = pulseTrain(0, burstDur, 'B', clickDur, clickType);
maxSPL = PT.maxSPL;
Nrep = sc.repcount;
SPL1 = [s1.spl1 s2.spl1];
SPL2 = [s1.spl2 s2.spl2];
SPL = max([SPL1 ; SPL2]);
% collect in struct
PRES = CollectInStruct(Nrep, SPL, maxSPL, Nsubseq, chan);

%--------individual info about clicks
LL = 1; RR = 2;
RelLevLeft = [SPL1(LL) SPL2(LL)] - SPL(LL);
RelLevRight = [SPL1(RR) SPL2(RR)] - SPL(RR);
INDIV = CollectInStruct(Tleft, Tright, RelLevLeft, RelLevRight);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotInfo = createPlotInfo('ICI (ms)', ...
   ICI(playOrder), 'log', NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
GlobalInfo = createGlobalInfo('ICI', calib, repmat(ICI(playOrder),1,2));
GlobalInfo.variedParam = 'ICI';

createdby = mfilename;
SMS = CollectInStruct(StimCat, Nsubseq, FREQ, INDIV, TIMING, PRES, PRP, GlobalInfo, createdby);
