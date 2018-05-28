function SMS=TTS2SMS(pp);
% TTS2SMS - convert TTS menu parameters to SMS 

stimname = 'tts';
StimCat = 'tts';

prepareTTSstim(pp); 

global TTSbuffer
StimParam = pp;
suppSPL = TTSbuffer.suppSPL;

% -------------------presentation--------------
Nsubseq = size(suppSPL,1);
Nrep = pp.reps;
chan = channelChar(pp.active);
SPL = suppSPL;
% collect in struct
PRES = CollectInStruct(Nrep, Nsubseq, chan, SPL);

% ---------PRP info------------
playOrder = createPlayOrder(Nsubseq, pp.order);
PlotMode = 'lin';
[sspl, ch] = leastboringcolumn(suppSPL); ch = channelChar(ch);
sspl = sspl(playOrder);
plotInfo = createPlotInfo('Suppressor Level (dB SPL)', sspl, PlotMode, NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ---------IndepVar info------------
IndepVar = CreateIndepVarStruct('Suppressor Level', 'L_supp', sspl, 'dB SPL', 'linear');
% ---------stimulus specials--------
StimSpecials = CreateSpecialVarStruct(...
   NaN, pp.burstDur, pp.probefreq, pp.suppfreq, pp.probefreq-pp.suppfreq, nan, pp.active);
% by convention, carrier freq is identified with the probe, ....
% suppressor freq with modulator, and beat freq with their difference

% ----------global info-----------
global CALIB SGSR
var1v = suppSPL(playOrder,:);
var2v = 0*var1v;
GI = createGlobalInfo('', CALIB.ERCfile, var1v, var2v, 1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'SuppLevel';
GI.StimParams = pp;
GI.SamFreqs = SGSR.samFreqs;
GI.maxSampleRatio = SGSR.maxSampleRatio;
GlobalInfo = GI;
createdby = mfilename;

SMS = CollectInStruct(StimCat, StimParam, Nsubseq, PRES, ...
   GlobalInfo, PRP, IndepVar, StimSpecials, createdby);
