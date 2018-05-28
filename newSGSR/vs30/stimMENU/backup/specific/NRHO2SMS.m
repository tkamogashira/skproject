function SMS=NRHO2SMS(pp);
% NRHO2SMS - convert NRHO menu parameters to SMS 

stimname = 'nrho';
StimCat = 'nrho';

prepareNRHOstim(pp); 

global NRHObuffer

% -------------------presentation--------------
Nsubseq = length(pp.rho);
Nrep = pp.reps;
chan = channelChar(pp.active);
SPL = pp.SPL; if size(SPL,2)==1, SPL = [SPL, SPL]; end
% collect in struct
PRES = CollectInStruct(Nrep, Nsubseq, chan, SPL);

% ---------PRP info------------
playOrder = createPlayOrder(Nsubseq, pp.order);
rhoval = pp.rho(playOrder); % values of rho in plat order
PlotMode = 'lin';
plotInfo = createPlotInfo('Interaural correlation', rhoval, PlotMode, NaN, 'BurstOnly');
PRP = createPRPinfo(plotInfo, playOrder);

% ---------IndepVar info------------
IndepVar = CreateIndepVarStruct('Interaural correlation', 'Rho', rhoval, '', 'linear');
% ---------stimulus specials--------
StimSpecials = CreateSpecialVarStruct(...
   NaN, pp.burstDur, nan, nan, nan, nan, pp.active);

% ----------global info-----------
global CALIB SGSR
var1v = rhoval*[1 1];
var2v = 0*var1v;
GI = createGlobalInfo('', CALIB.ERCfile, var1v, var2v, 1);
GI = rmfield(GI,'cmenu');
GI.stimName = stimname;
GI.nonPDP11 = 1;
GI.variedParam = 'rho';
GI.StimParams = pp;
GI.SamFreqs = SGSR.samFreqs;
GI.maxSampleRatio = SGSR.maxSampleRatio;
GlobalInfo = GI;
createdby = mfilename;

StimParam = pp;
SMS = CollectInStruct(StimCat, StimParam, Nsubseq, PRES, ...
   GlobalInfo, PRP, IndepVar, StimSpecials, createdby);
