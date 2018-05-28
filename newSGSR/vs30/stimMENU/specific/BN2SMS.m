function SMS=BN2SMS(pp);
% BN2SMS - convert BN menu parameters to SMS XXX

stimname = 'bn';

prepareBNstim(pp); 

global BNbuffer
StimParam = pp;

% -------------------presentation--------------
if pp.BNversion<9, Nsubseq = length(pp.MidFreq);
else, Nsubseq = size(pp.SPL,1);
end
Nrep = 1;
chan = channelChar(pp.active);
SPL = pp.SPL;
% collect in struct
PRES = CollectInStruct(Nrep, Nsubseq, chan, SPL);

% ---------PRP info------------
playOrder = createPlayOrder(Nsubseq, pp.order);
PlotMode = 'lin';
if pp.BNversion<9, Nsubseq = length(pp.MidFreq);
   plotInfo = createPlotInfo('Freq (Hz)', pp.MidFreq(playOrder), PlotMode, NaN, 'BurstOnly');
else,
   ichan = max(1,pp.active);
   plotInfo = createPlotInfo('Level (dB SPL)', pp.SPL(playOrder,ichan), PlotMode, NaN, 'BurstOnly');
end
PRP = createPRPinfo(plotInfo, playOrder);

% ----------global info-----------
global CALIB SGSR
var1v = pp.SPL(playOrder,:);
var2v = 0*var1v;
GI = createGlobalInfo('', CALIB.ERCfile, var1v, var2v, 1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'noiseToken';
GI.StimParams = pp;
GI.SamFreqs = SGSR.samFreqs;
GI.maxSampleRatio = SGSR.maxSampleRatio;
GlobalInfo = GI;
createdby = mfilename;

StimCat = 'bn';
SMS = CollectInStruct(StimCat, StimParam, Nsubseq, PRES, GlobalInfo, PRP, createdby);
