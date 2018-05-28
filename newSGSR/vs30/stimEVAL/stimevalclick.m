function [DAdata, GENdata] = stimevalClick(pe);

% STIMevalClick - stimulus evaluator for 'Click' stimulus category
% stimcat-independent info is stored in struct DAdata
% (this info will be used at D/A time: buffer sizes, 
% # reps of cyclic buffers, # samples to play, etc)
% stimtype-dependent info stored in struct GENdata:
% SYNTAX:
% function [DAdata, GENdata] = stimevalClick(wv);
% wv is single waveform element from stimdef struct.
% NOTE: this function should only be called implicitly
% by stimeval - no complete type checking here.

StimCat = 'click';
DAdata = []; GENdata = [];
SampleFreq = pe.stimpar.samFreq; % in Hz
filterIndex = pe.stimpar.filterIndex;
SamP = 1e6./SampleFreq; % sample period in us
i_chan = ChannelNum(pe.channel); % L|R -> 1|2
global clickData
CDI = pe.stimpar.clickDataIndex;
cdata = chanOfStruct(clickData(CDI),pe.channel);
cdata = rmfield(cdata,'CycBuf'); % don't need these now; save memory

% compute # samples per portion of stimulus
N_stored = cdata.BufLen*cdata.NrepCyc + cdata.Nremain;
N_TotalBurst = cdata.NsamTotal;
N_missing = N_TotalBurst - N_stored;
RepSilDur =  pe.stimpar.repDur - N_TotalBurst*1e-3*SamP;
N_RepSil = round(RepSilDur*1e3/SamP) + N_missing;
% number of samples for single repetition (including rep silence)
N_Play = N_stored + N_RepSil;
% we will stick to these numbers, even if they contain rounding errors
% compute buffer sizes, etc
bufSizes = [cdata.BufLen; cdata.Nremain];
bufReps = [cdata.NrepCyc; 1];
% remove empty stuff
emptyBufs = find((bufSizes==0)|(bufReps==0));
bufSizes(emptyBufs) = [];
bufReps(emptyBufs) = [];
% Max SPL is computed at stim-menu time; it is stored in global NoiseBuffer
MaxSPL = cdata.maxSPL;
TimeWarp = NaN;

% fill DAdata structure (identical for all stimtypes)
DAdata = DAdataStruct(SamP, filterIndex,bufSizes, bufReps, ...
   N_RepSil, N_Play, TimeWarp-1, MaxSPL, mfilename);
% fill the GENdata structure (particular for each stimtype)
GENdata = GENdataStruct(pe.channel, CDI, cdata, StimCat, mfilename);

%---------locals----------------
function gd = GENdataStruct(channel, clickDataIndex, cdata, GENfun, createdby);
% GENdata structure (specific for click stimtype)
numAtt = 0; % will be set by levelchecking
gd =CollectInStruct(channel,  clickDataIndex, GENfun);
gd  = combineStruct(gd, cdata); 
gd.createdby = createdby;

