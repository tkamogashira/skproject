function BufDBNs = stimgennoise(wf, storage);

% STIMGENnoise -  computes (realizes) noise waveform
% SYNTAX:
% function SD = stimgennoise(wf, storage);
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
channel = gd.channel;
onset = gd.onset;
burstDur = gd.burstDur;
riseDur = gd.riseDur;
fallDur = gd.fallDur;
NburstBuf = gd.NburstBuf;
NoiseBufferIndex = gd.NoiseBufferIndex;
numAtt = gd.numAtt;
nbi = gd.NoiseBufferIndex;

% collect spectral parameters & spectrum itself from global NoiseBuffer
SpecParams = local_NBC(nbi, 'SpecParams');
nchan = SpecParams.nchan;
scaleFactor = SpecParams.scaleFactor;
NheadZero = SpecParams.NheadZero;
NnonZero = SpecParams.NnonZero;
NtrailZero = SpecParams.NtrailZero;
NsamF = SpecParams.NsamF;
NsamT = SpecParams.NsamT;
df = SpecParams.df; % frequency spacing in Hz of spectrum
samPeriod =  SpecParams.samPeriod; % sample period of waveform in us
% spectrum itself
ichan = min(channelNum(channel),nchan); % row index of channel in calibSpec
scaleFactor = scaleFactor(ichan) * db2a(-numAtt); % also incorporate numerical attenuation
cstr = num2str(ichan);
calibSpec = local_NBC(nbi, ['calibSpec(' cstr ',:)']);

% onset refers to a waveform delay which is realized as
% a linear phase shift in the spectrum: phaseshift(freq) = -2*pi*freq*delay
PhaseSlope = -2*pi*df*onset*1e-3; % in rad/sample
PhaseFactor = exp(i*PhaseSlope*((NheadZero-1)+(1:NnonZero))); % only for nonzero components

% now we obtain waveform by ifft-ing the phase-shifted spectrum 
% zeros must be padded and the scalefactor included (see also GaussNoiseBand).
Waveform = real(ifft([zeros(1,NheadZero), ...
      scaleFactor*(PhaseFactor.*calibSpec), ...
      zeros(1,NtrailZero+NsamF)]));
Waveform = Waveform(1:NburstBuf);

% gating: onset also affects gating window - the whole gated burst is delayed
% compute the gating windows and their ranges of application
[Rise Fall] = GatingRecipes(onset, burstDur, riseDur, fallDur, NburstBuf, samPeriod);
% apply the gating windows just obtained

sts = Rise.StartSample;
ens = Rise.EndSample;
Waveform(sts:ens) = Rise.Window.*Waveform(sts:ens);
sts = Fall.StartSample;
ens = Fall.EndSample;
Waveform(sts:ens) = Fall.Window.*Waveform(sts:ens);

BufDBNs = storeSamples(Waveform, storage);

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

