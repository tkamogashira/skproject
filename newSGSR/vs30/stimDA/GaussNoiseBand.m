function [StimParams, MaxSPL, Waveform, NoiseStruct] = ...
   GaussNoiseBand(fLow, fHigh, dur, Fsample, Chan, Rho, RandSeed, Nsign);

% GAUSSNOISEBAND - generates gaussian bandpass noise

% multiple values in stimparams -> independent tokens of noise, UNLESS
% a numeric randSeed is explicitly passed as inarg - in that
% case, this random seed is used for each and every token.
% dur is mininum dur; true dur is rounded upward to yield 2^N # samples

global NoiseBuffer 
MarkBuffer NoiseBuffer; % mark for deletion at next stim menu
if nargin < 8, Nsign=1; end;

if nargin==1, % params are passed in single StimParams struct
   sp = fLow; 
   fLow = sp.fLow;
   fHigh = sp.fHigh;
   dur = sp.dur;
   Fsample = sp.Fsample;
   FiltIndex = sp.FiltIndex;
   Chan = sp.Chan;
   Rho = sp.Rho;
   RandSeed = sp.RandSeed;
   Nsign = sp.Nsign;
else,
   FiltIndex = NaN + Fsample;
   if nargin<7,
      RandSeed = NaN;
   end
end
if isnumeric(Chan), % convert to character B|L|R
   Chan = ChannelChar(Chan);
end

if isequal(0,Fsample), % pick from available set
   [Fsample, FiltIndex] = safeSampleFreq(fHigh);
end

% single, NaN-valued randomSeed -> pick a new random seed
if isequal(length(RandSeed),1) & isnan(RandSeed), 
   RandSeed = SetRandState; 
end;

% collect all input parameters in single structure. Make sure that
% vector-valued args are stored as column vectors
noiseGenerator = mfilename;
fLow=fLow(:);fHigh=fHigh(:);dur=dur(:);Fsample=Fsample(:);
FiltIndex=FiltIndex(:);Chan=Chan(:);Rho=Rho(:);RandSeed=RandSeed(:);
StimParams = CollectInStruct(fLow, fHigh, dur, Fsample, FiltIndex, ...
   Chan, Rho, RandSeed, noiseGenerator, Nsign);
if nargout<2, return; end; % don't need to compute noise itself

% Before starting to crunch numbers, look if the stimparams 
% are identical to those of the previous call: if that is 
% the case, we don't need to compute the noise, because the 
% noise of the previous call is always stored in the global 
% variable NoiseBuffer
if ~isempty(NoiseBuffer),
   if isfield(NoiseBuffer, 'StimParams'),
      if isequal(StimParams, NoiseBuffer.StimParams),
         MaxSPL = NoiseBuffer.MaxSPL;
         Waveform = NoiseBuffer.Waveform;
         NoiseStruct = NoiseBuffer.NoiseStruct;
         return;
      end
   end
end

% next look if multiple waveforms are needed. If so, handle them
% by recursive calls to GaussNoiseBand
Mult = MultOfStruct(StimParams,1); % only # rows count as multiplicity; strings are single values per definition
if Mult>1, % recursive calls will do the job
   % owing to their possibly different sizes, outargs
   % cannot be put in a simple vector - so return in
   % cell arrays:
   MaxSPL = cell(1,Mult);
   Waveform = cell(1,Mult);
   NoiseStruct = cell(1,Mult);
   Rseeds = NaN + zeros(Mult,1);
   % recursive call to GaussNoiseBand. Store the random seeds.
   for iToken = 1:Mult,
      [dummy MaxSPL{iToken}, Waveform{iToken}, NoiseStruct{iToken}] ...
         = GaussNoiseBand(NthElemOfStruct(iToken,StimParams));
      Rseeds(iToken) = dummy.RandSeed;
   end
   % put the random seeds of the individual tokens in stimparams struct
   StimParams.RandSeed = Rseeds(:);
   % store al previous computations in global NoiseBuffer, so that 
   % a next call to GaussNoiseBand with identical StimParams
   % does not trigger any computations
   NoiseBuffer = CollectInStruct(StimParams, MaxSPL, Waveform, NoiseStruct);
   return;
end

% from here, a single noise token is to be computed.


NeedTwoWaveForms = isequal(Chan,'B') & (abs(Rho)~=1); % mixing is called for

% # spectral points upto Nyquist freq; round to next power of two to increase computational  speed
NsamF = pow2(ceil(log2(0.5*dur*1e-3*Fsample))); 
NsamT = 2*NsamF;
df = Fsample/NsamT; % freq spacing
samPeriod = 1e6/Fsample; % sample period of waveform in us
freq = linspace(0,Fsample-df,NsamT); % freq axis BUG before Nov 8, 2001: NsamF i.s.o. NsamT
iLow = max(1,round(0.5+fLow/Fsample*NsamT)); % avoid negative indices
iHigh = round(0.5+fHigh/Fsample*NsamT);
Flimits = freq([iLow iHigh]);
NheadZero = iLow-1; % # zero-valued spectral points at low-freq side 
NnonZero = max(1,iHigh-iLow); % convention: zero BW -> single tone
% # zero-valued spectral points at high-freq side (upto Nyquist):
NtrailZero = NsamF-NheadZero-NnonZero;

% compute passband portion of uncalibrated spectrum
SetRandState(RandSeed);
plainSpec = randn(1,NnonZero)+ i*randn(1,NnonZero);
if NeedTwoWaveForms,
   MixplainSpec = randn(1,NnonZero)+ i*randn(1,NnonZero);
   % Nmp = norm(MixplainSpec);
   % Np = norm(plainSpec);
   % ccr = sum(plainSpec.*MixplainSpec)/Nmp/Np;
   % MixplainSpec = MixplainSpec - ccr*plainSpec;
end
% The waveform associated with plainSpec is supposed to
% correspond to the exact sound waveform - calibration will take care of that.
% The RMS re 1 of this waveform, expressed in dB, equals the
% SPL of the sound by convention.
% The waveform is deduced from the complex spectrum as follows:
% 1. complete spectrum by heading/trailing zeros
% 2. provide zero-valued negative frequencies
% 3. inverse fft
% 4. real part
% These steps are all linear, so it doesn't matter that in reality they
% are performed on the calibrated version of the stimulus.
% The expected RMS depends only on the *number* of non-zero components
% and the total number of components (provided the zero-freq component is zero):
% Note: mixing is done such as to preserve the expected RMS
RMSwaveform = NnonZero^0.5/NsamT;
SPLwaveform = A2DB(RMSwaveform);

if isequal(Chan,'B'), 
   % calibration factors: per channel
   [calAmpLeft calPhaseLeft] = calibrate(freq(iLow-1+(1:NnonZero)), FiltIndex, 'L');
   [calAmpRight calPhaseRight] = calibrate(freq(iLow-1+(1:NnonZero)), FiltIndex, 'R');
   calibFacLeft = Nsign*db2a(calAmpLeft).*exp(2*pi*i*calPhaseLeft); % calPhase is in cycles
   calibFacRight = Nsign*db2a(calAmpRight).*exp(2*pi*i*calPhaseRight); % calPhase is in cycles
   if NeedTwoWaveForms,
      % mix noises so as to obtain correct rho (see MvdH & Trahiotis, 1997)
      rPlus = ((1+Rho)/2)^0.5;
      rMin =  ((1-Rho)/2 )^0.5;
      plainSpecLeft =  (rPlus*plainSpec + rMin*MixplainSpec);
      plainSpecRight = (rPlus*plainSpec - rMin*MixplainSpec);
   else, % trivial rho = +-1
      plainSpecLeft =  plainSpec;
      plainSpecRight =  Rho*plainSpec;
   end
   % calibrated version of passband portion of spectrum
   calibSpecLeft = plainSpecLeft.*calibFacLeft;
   calibSpecRight = plainSpecRight.*calibFacRight;
   % convert to waveform using the above mentioned steps
   WaveformLeft = real(ifft([zeros(1,NheadZero), calibSpecLeft, zeros(1,NtrailZero), zeros(1,NsamF)]));
   WaveformRight = real(ifft([zeros(1,NheadZero), calibSpecRight, zeros(1,NtrailZero), zeros(1,NsamF)]));
   Waveform = [WaveformLeft; WaveformRight];
   plainSpec = [plainSpecLeft; plainSpecRight];
   calibSpec = [calibSpecLeft; calibSpecRight];
else,
   % calibration factors
   [calAmp calPhase] = calibrate(freq(iLow-1+(1:NnonZero)), FiltIndex, Chan);
   calibFac = Nsign*DB2A(calAmp).*exp(2*pi*i*calPhase); % calPhase is in cycles
   % calibrated version of passband portion of spectrum
   calibSpec = plainSpec.*calibFac;
   % convert to waveform using the above mentioned steps
   Waveform = real(ifft([zeros(1,NheadZero), calibSpec, zeros(1,NtrailZero), zeros(1,NsamF)]));
end

nchan = size(Waveform,1);
for ichan=1:nchan,
   % compute scaling factor that leads to just hitting maxMagDA
   scaleFactor(ichan) = MaxMagDA/max(abs(Waveform(ichan,:)));
   % blow up until it hits the maxMagDA limit
   Waveform(ichan,:) = Waveform(ichan,:)* scaleFactor(ichan);
   % the scalefactor also changes the SPL
   MaxSPL(ichan) = SPLwaveform + A2DB(scaleFactor(ichan));
end

% collect all relevant info in noiseStruct if asked
if nargout>1,
   SpecParams = CollectInStruct(nchan, scaleFactor, ...
      NheadZero, NnonZero, NtrailZero, NsamF, NsamT, df, samPeriod);
   createdby = mfilename;
   NoiseStruct = CollectInStruct(StimParams, SpecParams, MaxSPL, ...
      plainSpec, calibSpec, createdby);
end

% store al precious computations in global NoiseBuffer, so that 
% a next call to GaussNoiseBand with identical StimParams
% does not trigger any computations
NoiseBuffer = CollectInStruct(StimParams, MaxSPL, Waveform, NoiseStruct);

