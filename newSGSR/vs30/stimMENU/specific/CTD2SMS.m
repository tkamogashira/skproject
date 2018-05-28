function SMS=CTD2SMS(idfSeq,calib);

% CTD2SMS - convert CSPL menu parameters to SMS XXX
% SYNTAX:

stimname = idfStimName(idfSeq.stimcntrl.stimtype);
StimCat = 'click';

if nargin<2, calib = 'none'; end;
if nargin<3, randomize = 0; end;
[chan sc s1 s2 scmn chanNum order] = idfStimFields(idfSeq);

%------------frequencies---------------
pulseFreq = [0 0]; % single pulses
% compute safe samplefreqs and filter indices
[samFreq, filterIndex] = safeSamplefreq(maxStimFreq); % highest sample rate available
samp = 1e6/samFreq;
% freq tolerances
carTol = -5e-4; % max cumulative phase error in cycles over total burst duration
% collect freq info in struct var
FREQ = CollectInStruct(pulseFreq, samFreq, filterIndex, carTol);

% ----------durations, phases, and interaural timing-----------
[dummy, ITD, mess, newStartITD] = ...
   CTDcheck('local_ITD',scmn.start_itd, scmn.delta_itd, scmn.end_itd);
Nsubseq = size(ITD,1); % Note: the ITD thus obtained is ipsi-lead
% for clicks, all ITDs are  realized by sample delays
ITDset = 0;
ITDindex = repmat(1,Nsubseq,1);
Nhead = round(1e3*doubleDelay(ITD)/samp); % 2-col left/right delays
% Nhead = [max(Nhead,0), max(-Nhead,0)];
totalITD = struct(...
   'ITDset', ITDset, ...
   'ITDindex', ITDindex,...
   'Nhead', Nhead...
   );

% -------------------presentation, SPL--------------
Nrep = sc.repcount;
SPL = [s1.spl s2.spl];
% collect in struct
PRES = CollectInStruct(Nrep, SPL, Nsubseq, chan);

% ------instructions for stim definition (i.e. conversion to SD struct)
ITDsaving = 0; % no tricks with waveform vs sample delays
LeftConstant = 1;
RightConstant = 1;
ITDchan = 'LEFT';
% collect in struct
SD_INSTR = CollectInStruct(ITDsaving, ...
   LeftConstant, RightConstant, ITDchan);

repDur= sc.interval; 
totDur = [0 0]; % will be set by stimeval
clickDur = [s1.click_dur s2.click_dur]; 
burstDur = 2e-3*clickDur;
clickType = 2*scmn.polarity-1;
onset = [0 0]; % will be set by stimeval
% collect timing info in struct
TIMING = CollectInStruct(totalITD, repDur, totDur, burstDur, clickDur, clickType, onset);

% ---------PRP info------------
% order: L->R|R->L|random = 0|1|2 
playOrder = CreatePlayOrder(Nsubseq, order);
plotInfo = createPlotInfo('ITD (\mus)', ITD(playOrder), 'linear', NaN, 'Interval');
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
% farmington convention: store delays in contralateral channel
if ipsiside=='L', ddd=[0 1]; else, ddd=[1 0]; end;
var1values = kron(ITD(playOrder),ddd);
GlobalInfo = createGlobalInfo('CTD', calib, var1values);
GlobalInfo.variedParam = 'ITD';

createdby = mfilename;
SMS = CollectInStruct(StimCat, Nsubseq, FREQ, TIMING, PRES, SD_INSTR, PRP, GlobalInfo, createdby);
