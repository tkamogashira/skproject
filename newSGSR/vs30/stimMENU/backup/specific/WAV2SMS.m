function SMS=WAVSMS(params, WAVdetails);

% WAVSMS - convert WAV menu parameters to SMS

if ~isequal(params.stimtype, 'wav'),
   error('not a ''wav'' stimulus type');
end

% collect params from WAVdetails
Nseq = WAVdetails.Nwav;
Fsample = zeros(Nseq,1);
FilterIndex = zeros(Nseq,1);
Fsample = WAVdetails.NewFsample;
FilterIndex = WAVdetails.FilterIndex;
% burst durations
burstDur = WAVdetails.Durations;
% play order
playOrder = CreatePlayorder(Nseq, params.order);
% plotInfo
Xlabel = 'WAV file #';
VVlabels = strvcat(WAVdetails.ShortName);
varValues = playOrder';
plotInfo = createPlotInfo(Xlabel, varValues, 'linear', NaN, 'BurstOnly', VVlabels);
% conversion channel number -> letter
if isequal(params.active,0), chan = 'B';
elseif isequal(params.active,1), chan = 'L';
elseif isequal(params.active,2), chan = 'R';
end

% --------StimCat
StimCat = 'WAVlist';
% --------MON
scalor = WAVdetails.Scalor;
repDur = params.interval;
MON = CollectInStruct(Fsample, FilterIndex, repDur, burstDur, scalor);
% --------BIN
Nhead = zeros(Nseq,2);
BIN = CollectInStruct(Nhead, chan);
% --------ATTEN
ATTEN = params.atten;
% --------NREP
NREP = params.reps;
% --------COVAR
COVAR = [];
% --------GlobalInfo
global SGSR
dd=round(datevec(now)); 
today=dd([3 2 1 4 5 6]);
calib = ERCfile;
SGSRversion = SGSR.version;
var1Values = varValues;
stimName = 'wav';
nonPDP11 = 1; % indicate non-compatibility with PDP-11 format
GlobalInfo = CollectInStruct(today, calib, SGSRversion, ...
   var1Values, stimName, nonPDP11);
% --------PRP
PRP = CollectInStruct(plotInfo, playOrder);

% ---------IndepVar info------------
IndepVar = CreateIndepVarStruct('WavFile number', 'fileNumber', varValues, '', 'linear');
% ---------stimulus specials--------
StimSpecials = CreateSpecialVarStruct(...
   NaN, params.WAVdetails.Durations, nan, nan, nan, nan, params.active);
% by convention, carrier freq is identified with the probe, ....
% suppressor freq with modulator, and beat freq with their difference


% --------sign this form, please
createdby = mfilename;

SMS = CollectInstruct(StimCat, MON, BIN, ATTEN, NREP, COVAR, ...
   GlobalInfo, PRP, IndepVar, StimSpecials, createdby);


