function WaveFormIndex = ComputeNoiseWaveform(Chan, WavDelay, PhaseLag, Rho);

% ComputeNoiseWaveform - ifft of spectra in global RnoiseBuffer
% SYNTAX:
% WF = ComputeNoiseWaveform(Chan, WavDelay, PhaseLag, Rho);
% Chan = L|R
% WavDelay in us
% PhaseLag in cycles
% WF is *complex* waveform.


% oscor: parallel rotation: one ear is complex conjugated before rotation

if nargin<1, Chan='L'; end;
if nargin<2, WavDelay=0; end;
if nargin<3, PhaseLag=0; end;
if nargin<4, Rho=[]; end;

global RnoiseBuffer

% check type of RnoiseBuffer and compatibilty with current set of params
if IsAnalyticBuf, % analytic signal. Only pos freqs in spectrum.
   if ~isempty(Rho) & ~isequal(Rho, RnoiseBuffer.Rho),
      error('fixed-rho (analytical) RnoiseBuffer does not allow new rho values');
   end
   Rho = RnoiseBuffer.Rho;
else, % pos & neg frequences
   if isempty(Rho), Rho = 1; end
end

% put args in struct for bookkeeping purposes
Params = CollectInStruct(Chan, WavDelay, PhaseLag, Rho);
% now look if this exact set of params has been used before
[WaveFormIndex, ParamsAreNew] = local_LookupInRnoiseBuffer(Params);

if ~ParamsAreNew, return; end % work has been done before, we're ready

scaleFactor = db2a(RnoiseBuffer.MaxSPL(local_colIndex(Chan))); % full 16-bit range
Nbuf = length(RnoiseBuffer.Buf);
for ibuf=1:Nbuf, 
   % manipulate spectrum according to parameters and compute ifft
   ManSpec = local_manipulatedSpec(ibuf, Chan, WavDelay, PhaseLag, Rho);
   % inverse FFT and rotation
   rot = RnoiseBuffer.Buf(ibuf).Rotator;
   NsamT = RnoiseBuffer.Buf(ibuf).NsamT;
   rr = scaleFactor*exp(rot*(1:NsamT)); rr = rr(:);
   RnoiseBuffer.Buf(ibuf).Waveform(:,WaveFormIndex) = rr.*ifft(ManSpec, NsamT);
end

%--------------------------
function icol = local_colIndex(Chan);
global RnoiseBuffer
if RnoiseBuffer.Buf(1).nchan==2, icol = channelNum(Chan);
else, icol = 1;
end

function disX = local_distributeOverFreq(X, freq);
NN = length(X);
if NN==1, disX = X;
else, % X-values and freq edges alternate in vector X
   if rem(NN,2)~=1, error('bad freq-distributed value'); end;
   edges = X(2:2:end);
   edges = [-inf, edges(:).' inf];
   Xvalues = X(1:2:end);
   Nval = length(Xvalues);
   disX = NaN + 0*freq(:); % right length - column
   for ival=1:Nval,
      ii = find((freq>edges(ival)) & (freq<=edges(ival+1)));
      disX(ii) = Xvalues(ival);
   end
end

function ManSpec = local_manipulatedSpec(ibuf, Chan, WavDelay, PhaseLag, Rho);
global RnoiseBuffer
if IsAnalyticBuf, ManSpec = local_manipulatedAnaSpec(ibuf, Chan, WavDelay, PhaseLag);
else, ManSpec = local_manipulatedFullSpec(ibuf, Chan, WavDelay, PhaseLag, Rho);
end

function ManS = local_manipulatedAnaSpec(ibuf, Chan, WavDelay, PhaseLag);
% manipulates analytical spectrum (pos freqs only)
global RnoiseBuffer
DAchannel = RnoiseBuffer.Params.DAchannel;
tBuf = RnoiseBuffer.Buf(ibuf); % temp copy of spectral buffer
icol = local_colIndex(Chan);
df = tBuf.df;
iLow = tBuf.iLow;
NnonZero = tBuf.NnonZero;
freq = df*(iLow-1+(1:NnonZero)); % freq axis in Hz of nonZero components
freq = freq(:);
WD = local_distributeOverFreq(WavDelay, freq)*1e-6; % us->s
PL = local_distributeOverFreq(PhaseLag, freq); % in cycles
phasor = exp(2*pi*i*(-PL-freq.*WD));
tBuf.CalibSpecPos = phasor.*tBuf.CalibSpecPos(:,icol);
tBuf.nchan = 1;
ManS = CompleteNoiseSpectrum(tBuf);

function ManS = local_manipulatedFullSpec(ibuf, Chan, WavDelay, PhaseLag, Rho);
% manipulates full spectrum (pos & neg freqs)
global RnoiseBuffer
DAchannel = RnoiseBuffer.Params.DAchannel;
tBuf = RnoiseBuffer.Buf(ibuf); % temp copy of spectral buffer
icol = local_colIndex(Chan);
df = tBuf.df;
iLow = tBuf.iLow;
NnonZero = tBuf.NnonZero;
freq = df*(iLow-1+(1:NnonZero)); % freq axis in Hz of nonZero components
freq = freq(:);
WD = local_distributeOverFreq(WavDelay, freq)*1e-6; % us->s
PL = local_distributeOverFreq(PhaseLag, freq); % in cycles
RHO = local_distributeOverFreq(Rho, freq); % in cycles
phasor = exp(2*pi*i*(-PL-freq.*WD));
RhoSign = sign(channelNum(Chan)-1.5);
RhoAngle = RhoSign.*0.5*acos(RHO);
RhoPhasor = exp(i*RhoAngle);
tBuf.CalibSpecPos = RhoPhasor.*phasor.*tBuf.CalibSpecPos(:,icol);
% negative freqs: reverse order of phasor and take complex conjugate for phase-related stuff
phasor = conj(phasor(end:-1:1));
RhoPhasor = RhoPhasor(end:-1:1);
tBuf.CalibSpecNeg = RhoPhasor.*phasor.*tBuf.CalibSpecNeg(:,icol);
tBuf.nchan = 1;
ManS = CompleteNoiseSpectrum(tBuf);

function [WaveFormIndex, ParamsAreNew] = local_LookupInRnoiseBuffer(Params);
global RnoiseBuffer
ParamsAreNew = 1; % default
% now look if current param set happens to have been used before
Nwf = length(RnoiseBuffer.WaveFormPool);
for iwvf=1:Nwf, % visit all stored waveform param sets and compare
   if isequal(Params, RnoiseBuffer.WaveFormPool(iwvf)),
      WaveFormIndex = iwvf;
      ParamsAreNew = 0;
      return;
   end
end
% we haven't returned yet .. params are new - store them
WaveFormIndex = Nwf+1; % append the current param set
if Nwf==0, RnoiseBuffer = rmfield(RnoiseBuffer, 'WaveFormPool'); end;
RnoiseBuffer.WaveFormPool(WaveFormIndex) = Params; % initialize waveform pool and return




