function SMS=NRHO2SMS(pp);
% PS2SMS - convert PS menu parameters to SMS 

stimname = 'ps';
StimCat = 'ps';

[maxSPL, PS] = preparePSstim(pp); 

% -------------------presentation--------------
Nsubseq = pp.Nphase;
Nrep = pp.reps;
chan = channelChar(pp.active);
SPL = pp.SPL; if size(SPL,2)==1, SPL = [SPL, SPL]; end
% collect in struct
PRES = CollectInStruct(Nrep, Nsubseq, chan, SPL);

% ---------PRP info------------
playOrder = createPlayOrder(Nsubseq, pp.order);
phaseval = PS.startPhase(playOrder)/2/pi; % values of phase in plat order
phaseval = phaseval(:);
PlotMode = 'lin';
plotInfo = createPlotInfo('Starting phase (cycle)', phaseval, PlotMode, NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ---------IndepVar info------------
IndepVar = CreateIndepVarStruct('Starting phase', 'Startphase', phaseval, 'cycle', 'linear');
% ---------stimulus specials--------
StimSpecials = CreateSpecialVarStruct(...
   NaN, pp.burstDur, pp.freq, nan, nan, nan, pp.active);

% ----------global info-----------
global CALIB SGSR
var1v = phaseval*[1 1];
var2v = 0*var1v;
GI = createGlobalInfo('', CALIB.ERCfile, var1v, var2v, 1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'startphase';
GI.StimParams = pp;
GI.SamFreqs = SGSR.samFreqs;
GI.maxSampleRatio = SGSR.maxSampleRatio;
GlobalInfo = GI;
createdby = mfilename;

StimParam = pp;
SMS = CollectInStruct(StimCat, StimParam, Nsubseq, PRES, ...
   GlobalInfo, PRP, IndepVar, StimSpecials, createdby);
