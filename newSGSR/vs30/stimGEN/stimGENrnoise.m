function BufDBNs = stimgenRnoise(wf, storage);

% STIMGENrnoise -  computes (realizes) rnoise waveform
% SYNTAX:
% function SD = stimgenRnoise(wf, storage);
% INPUTS:
%    wf: waveform stimdef cell element.
%    storage: 'AP2' or 'MatLab' (where to store the samples)
%
% OUTPUT:
% BufDBNs is array holding AP2 or SampleLib indices (see stimGen)
% This function should only be called implicitly via stimGen -
% no complete arg checking.

% collect generating params from GENdata field of waveform
gd = wf.GENdata;
Chan = gd.channel;
onset = gd.onset;
BurstDur = gd.burstDur;
riseDur = gd.riseDur;
fallDur = gd.fallDur;
NburstBuf = gd.NburstBuf;
NumAtt = gd.numAtt;
Nrep = gd.Nrep;
% compute or fix oderived params
OnsetDelay = onset*1e3; % ms->us
WavDelay = OnsetDelay; % will be decoupled in future versions
RampDur = [riseDur, fallDur];
% cut-offsets are quasi-random numbers that are uniquely determined by CutSeeds
CutOffsets = NrandNumbers(Nrep, gd.cutSeed);
% collect noise parameters itself from global RnoiseBuffer
global RnoiseBuffer;
PhaseLag = 0;
PhasorSpeed = 0; % not yet implemented
Rho = RnoiseBuffer.Params.Rho;
samPeriod =  1e6/RnoiseBuffer.Params.Fsample; % sample period of waveform in us

% now we have all inargs for CutNoiseFromBuf - delegate

BufDBNs = zeros(1,Nrep); % a ROW vector - this indicates that "reps" different (see playInstr2)
for irep = 1:Nrep,
   token=CutNoiseFromBuf(Chan, WavDelay, PhaseLag, Rho, NburstBuf, CutOffsets(irep), ...
      NumAtt, OnsetDelay, BurstDur, RampDur, PhasorSpeed);
   BufDBNs(1,irep) = storeSamples(token(:).', storage); % row vecor
end


%-------------locals-------------
function y=local_NBC(bufferIndex,CompString);
% returns specified component of NoiseStruct field of
% global NoiseBuffer variable.
% Used to avoid memory load by making a local copy of NoiseBuffer
global NoiseBuffer
if bufferIndex==0, % NoiseBuffer is single struct variable
   CompName = ['NoiseBuffer.NoiseStruct.' CompString];
else, % cell array; pick element
   CompName = ['NoiseBuffer.NoiseStruct{' num2str(bufferIndex) '}.' CompString];
end
eval(['y = ' CompName ';']);

