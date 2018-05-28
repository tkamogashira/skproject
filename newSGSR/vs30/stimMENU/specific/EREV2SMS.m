function SMS=EREV2SMS(pp,FakeCal, forceComp);
% THR2SMS - convert EREV menu parameters to SMS XXX

if nargin<2, FakeCal = 0; end
if nargin<3, forceComp=0; end;

stimname = 'erev';

prepareEREVstim(pp,FakeCal, forceComp); % make sure noise stimulus is there

BV = ErevBufVar;
TONE.freq = BV.TrueToneFreq;
TONE.dur = 4*BV.TrueNoiseDur;

SpecTypes = {'EqAmp','Gauss'};
ispt = getFieldOrDef(pp,'SpecType',2); % default: 2=Gauss
NOISE.dur = BV.TrueNoiseDur;
NOISE.Ncyc = pp.NoiseRep;
NOISE.BW = pp.NoiseBW;
NOISE.SpecType = SpecTypes{ispt};
NOISE.Rseed = pp.Rseed;

BOTH.Ramp = pp.RampDur;
BOTH.Adapt = pp.AdaptDur;
BOTH.Fsam = BV.Fsam;
BOTH.iFilt = BV.iFilt;


% -------------------presentation--------------
Ntoken = pp.Ntoken;
Nrep = 1;
chan = channelChar(pp.active);
SPLtone = pp.SPLtone;
LevelNoise = pp.SPLnoise(:);
% collect in struct
PRES = CollectInStruct(Nrep, Ntoken, chan, SPLtone, LevelNoise);


% ---------PRP info------------
NnoiseLevel = length(LevelNoise);
Nsubseq = max(pp.Ntoken, NnoiseLevel);
playOrder = 1:Nsubseq;
PlotMode = 'lin';
if NnoiseLevel>1, 
   plotInfo = createPlotInfo('Noise Level (dB re Tone)', LevelNoise(playOrder), PlotMode, NaN, ...
      'BurstOnly', '', 'erevMod', 'CycleDur', NOISE.dur, ...
      'AdaptDur', BOTH.Adapt, 'Nbin', 20); 
else, 
   plotInfo = createPlotInfo('Time (ms)', 1:Nsubseq, PlotMode, NaN, ...
      'BurstOnly', '', 'erev', 'CycleDur', NOISE.dur, ...
      'AdaptDur', BOTH.Adapt, 'BinWidth', 3); % 3 ms binwidth
end;
% tracking stuff
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
global CALIB
GI = createGlobalInfo('', CALIB.ERCfile, repmat(0,Nsubseq,2),[],1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'noiseToken';
GI.StimParams = pp;
GlobalInfo = GI;
createdby = mfilename;

StimCat = 'erev';
SMS = CollectInStruct(StimCat, Nsubseq, TONE, NOISE, BOTH, PRES, GlobalInfo, PRP, createdby);
