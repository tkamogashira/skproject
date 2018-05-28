function [DAdata, GENdata] = stimevalNClicks(pe);

% STIMevalNClicks - stimulus evaluator for 'NClicks' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'nclicks';
DAdata = []; GENdata = [];
SampleFreq = pe.stimpar.samFreq; % in Hz
filterIndex = pe.stimpar.filterIndex;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(pe.channel); % L|R -> 1|2
Cdur = pe.stimpar.clickDur; % in us
ast = abs(pe.stimpar.clickType);
Ncsam = max(ast, ast*round(Cdur/SamP/ast));
Cdur = Ncsam*SamP*1e-3; % in ms, exact now
% compute # samples per portion of stimulus
onset = pe.stimpar.T';
offset = pe.stimpar.T' + Cdur;
events = vectorzip(onset, offset);
NC = length(onset);
durs = diff([0 events pe.stimpar.repDur]);
Portions = NsamplesOfChain(durs, SamP, 1);
% rep silence
N_RepSil = Portions(end);
% number of samples for single repetition (including rep silence)
N_Play = sum(Portions);
% rep silence doesn't beling to buffer
Portions = Portions(1:(end-1));
bufSizes=sum(Portions);
bufReps=1;
MaxSPL = pe.stimpar.maxSPL;
clickAmp = MaxMagDA*db2a(pe.stimpar.RL);
clickType = pe.stimpar.clickType;

% remove empty stuff
emptyBufs = find((bufSizes==0)|(bufReps==0));
bufSizes(emptyBufs) = [];
bufReps(emptyBufs) = [];
% Max SPL is computed at stim-menu time; it is stored in global NoiseBuffer
TimeWarp = NaN;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)
GENdata = GENdataStruct(pe.channel, clickType, clickAmp, Portions, StimCat, mfilename);

%---------locals----------------
function gd = GENdataStruct(channel, clickType, clickAmp ,Portions, GENfun, createdby);
% GENdata structure (specific for click stimtype)
numAtt = 0; % will be set by levelchecking
gd =CollectInStruct(channel,  clickType, clickAmp, Portions, GENfun);
gd.createdby = createdby;

