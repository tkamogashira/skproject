function SMS=BERT2SMS(pp);
% BERT2SMS - convert BERT menu parameters to SMS 

stimname = 'bert';
StimCat = 'bert';

prepareBERTstim(pp); 

global BERTbuffer
StimParam = pp;

% -------------------presentation--------------
Nsubseq = 1;
Nrep = pp.reps;
chan = channelChar(pp.active);
SPL = pp.SPL; if size(SPL,2)==1, SPL = [SPL, SPL]; end
% collect in struct
PRES = CollectInStruct(Nrep, Nsubseq, chan, SPL);

% ---------PRP info------------
playOrder = createPlayOrder(Nsubseq, pp.order);
PlotMode = 'lin';
plotInfo = createPlotInfo('Suppressor Level (dB SPL)', 0, PlotMode, NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ---------IndepVar info------------
IndepVar = CreateIndepVarStruct('Nope', 'Nope', 0, '', 'linear');
% ---------stimulus specials--------
StimSpecials = CreateSpecialVarStruct(...
   NaN, pp.burstDur, pp.CarrierFreq, nan, nan, nan, pp.active);

% ----------global info-----------
global CALIB SGSR
var1v = [0 0];
var2v = 0*var1v;
GI = createGlobalInfo('', CALIB.ERCfile, var1v, var2v, 1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'Nope';
GI.StimParams = pp;
GI.SamFreqs = SGSR.samFreqs;
GI.maxSampleRatio = SGSR.maxSampleRatio;
GlobalInfo = GI;
createdby = mfilename;

SMS = CollectInStruct(StimCat, StimParam, Nsubseq, PRES, ...
   GlobalInfo, PRP, IndepVar, StimSpecials, createdby);
