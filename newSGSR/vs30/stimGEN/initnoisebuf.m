function [MaxSPL, Params] = initNoiseBuf(fLow, fHigh, Fsample, RandSeed, Rho);

% initNoiseBuf - sets up a collection of RnoiseBuffers to generate noise
% SYNTAX
%    MaxSPL = initNoiseBuf(fLow, fHigh, Fsample, RandSeed, Rho);
% where:
%   fLow, fHigh:   low and high cutoff freqs in Hz
%   Fsample:       sample frequency in Hz. If unspecified or zero, a safe sample freq is
%                  chosen from the standard set of SGSR sample frequencies
%   RandSeed:      random number as returned by SetRandState. If unspecified of [],
%                  a new one is picked using the clock
%   Rho:           statistical correlation between left and right-channel noise waveforms
%                  If unspecified or empty, "full-complex" noise is generated, so that
%                  the correlation can be manipulated in the time domain by using
%                  complex factors (either statically or dynamically). If Rho is 
%                  specified, so-called analytic spectra are generated containing
%                  only *positive* frequencies. Now Rho is fixed, but the inter-channel
%                  phase can be manipulated in the time domain by using complex factors
%                  (again, either statically or dynamically).
%   MaxSPL:        the maximum SPL of noise tokens to be derived from the current RnoiseBuffer 
%                  
% InitNoiseBuf sets up a number of (calibrated) noise spectra having incommensurate
% lenghts, from which many quasi-independent noise tokens can be
% derived. A global variable RnoiseBuffer  stores these buffers;
% use ComputeNoiseWaveForm and CutFromNoiseBuf to get the tokens.
% unspecified rho: pos & negative frequencies -> rho can be determined by
% complex factors in the time domain (for fast, non-ifft rho manipulations or dynamical
%   rho manipulations such as used by Grantham).
% specified rho: positive frequency components only -> rho is fixed, but
% overall phase (including dynamic phase changes) can be manipulated in time domain.

% binaural params like ITD, IPD are not implemented at this stage;
% only at stimgen time they will be realized
% initNoiseBuf generates a number of noncommensurate noise spectra.
% They can be mixed with random onsets to produce a set of quasi-independent
% noise tokens with identical bandwidths.
% If both DAchannels are active (determined by global SESSIO N) then two independent 
% versions of each noise buffer are generated. 
% Weighted interaural mixing of these pairs then leads to 
% noise stimuli with arbitrary values of interaural correlation.
% Calibration is taken into account in order to predict maximum 
% levels.

% defaults
if nargin<3, Fsample = 0; end % safe sample freq from fixed set in global SGSR
if nargin<4, RandSeed = []; end % setRandomState is used to pick random seed
if nargin<5, Rho = []; end % rho can be picked later by mixing real & imag parts: full spectrum

RandSeed = SetRandState(RandSeed); % if RandSeed is empty, the clock is used to produce a new seed
% zero Fsample: provide a safe sample freq
if Fsample==0, [Fsample, FiltIndex]=safeSampleFreq(fHigh);
else, FiltIndex = NaN;
end;

% If a fixed rho is given, generate "analytical spectrum," i.e., spectrum containing only positive ...
% ... frequencies. Otherwise, generate "full spectrum," i.e., spectrum containing independent ...
% ... and negative frequencies. In the time domain, this will result in independent real and ...
% ... imaginary waveforms which can then be mixed to produce any inter-channel correlation, ...
% ... inculding dynamically varying ones.
if isempty(Rho), BufType = 'fullSpec';
else, BufType = 'anaSpec';
end

% set up a fixed number of incommensurate buffer lengths
NSAM = 2^13;
Nbuf = 5;
pp = primes(100); pp = pp(1:Nbuf);
NSAM = pp.^round(log(2^0.3*NSAM)./log(pp)); % powers of small primes -> fast fft
% convention zero bandwidth: single tone, i.e., use only a single buffer
BW = fHigh-fLow;
if BW<0, error('Fhigh<Flow'); end;
if BW==0, NSAM=NSAM(1); end;

% collect sessio specifics
DAchannel = SessioDAchan;
ERCfile = ercfile; % RHS is mfile .. sorry
Params = CollectInStruct(fLow, fHigh, Fsample, FiltIndex, Rho, RandSeed, NSAM, ERCfile, DAchannel);

% if RnoiseBuffer  exists and the Params match, no action is needed. 
% But outargs need to be returned anyway
global RnoiseBuffer  
markBuffer RnoiseBuffer  ; % mark for deletetion at next stimmenu
if ~isempty(RnoiseBuffer),
   if isfield(RnoiseBuffer ,'Params'),
      if isequal(Params, RnoiseBuffer.Params),
         MaxSPL = RnoiseBuffer.MaxSPL;
         return;
      end
   end
end

% examine if duplicate buffers are needed
if DAchannel=='B', nchan = 2;
else, nchan=1;
end

% compute the indices of the first and last nonzero spectral components
% for each of the spectra
Nbuf = length(NSAM);
for ibuf=1:Nbuf,
   NsamT = NSAM(ibuf); % number of samples in time domain in current buffer
   df = Fsample/NsamT; % freq spacing
   samPeriod = 1e6/Fsample; % sample period of waveform in us
   iLow = max(2,round(0.5+fLow/Fsample*NsamT)); % DC components are taboo
   iHigh = round(0.5+fHigh/Fsample*NsamT);
   NnonZero = max(1,iHigh-iLow); % convention: zero BW -> single tone
   CalibSpecPos = []; % to be computed
   CalibSpecNeg = []; % to be computed
   Rotator = 0.5*pi*i/NsamT;
   Buf(ibuf) = CollectInStruct(NsamT, df, samPeriod, iLow, NnonZero, nchan, ...
      CalibSpecPos, CalibSpecNeg, Rotator);
end

% Compute calibrated complex spectra
maxMagSam = 1e-40 + zeros(Nbuf, nchan);
for ibuf=1:Nbuf,
   NnonZero = Buf(ibuf).NnonZero;
   NsamT = Buf(ibuf).NsamT;
   % The expected RMS after ifft depends only on the *number* of non-zero components
   % and the total number of components (provided the zero-freq component is zero).
   % scale this expected RMS to unity for the SUM of all uncalibrated buffers (PlainSpec).
   NormFactor = NsamT/((2*NnonZero)^0.5*(Nbuf)^0.5);
   df = Buf(ibuf).df;
   % store the spectra in columns: MatLab fft is column-wise
   % positive frequencies
   PlainSpecPos = NormFactor*(randn(NnonZero,1) + i*randn(NnonZero,1)); 
   % negative frequencies (or just independent noise spectrum if Rho is fixed)
   PlainSpecNeg = NormFactor*(randn(NnonZero,1) + i*randn(NnonZero,1)); 
   % compute freq axis for calibration
   f1 = df*(Buf(ibuf).iLow-1); % freq in Hz of lowest component
   freq = f1 - df + df*(1:NnonZero);
   % perform calibration of spectra
   [Buf(ibuf).CalibSpecPos, Buf(ibuf).CalibSpecNeg] ...
      = local_calSpec(PlainSpecPos, PlainSpecNeg, freq, DAchannel, Rho, FiltIndex);
   % now perform ifft of calibrated spectrum in order to evaluate max sample magnitude
   WaveForm = ifft(CompleteNoiseSpectrum(Buf(ibuf)), NsamT);
   maxMagSam(ibuf,:) = max(abs(WaveForm));
end;
% noise stimuli are created by adding noise tokens cut from all Nbuf buffers
% using complex weights of unity norm. From the max magnitude of the samples of each buffer,
% we can compute the max scaling that may be applied to such a sum.
maxScaleFactor = MaxMagDA./sum(maxMagSam);
% the RMS of the plain spectrum corresponds (by construction) with the SPL of the sound.
% (this correspondence is realized by the calibration procedures)
% Since we have scaled the Plain Spectra in such a way that the sum of their iffts has
% an RMS of 1 (corresponding to 0 dB SPL), we immediately know the max SPL:
MaxSPL = a2db(maxScaleFactor);

WaveFormPool = [];
createdby = mfilename;
RnoiseBuffer = CollectInStruct(Params, BufType, Rho, Buf, MaxSPL, WaveFormPool, createdby);

%---------------------locals----------------
function [csPos, csNeg] = local_calSpec(sPos, sNeg, freq, Chan, Rho, FiltIndex);
% calibrates spectrum. sPos (sNeg) contains positive (negative) freq components in column vector
% calibrated spectra are returned as column vectors (Chan==L|R) or Nx2 matrix (Chan==B)

freq = freq(:); % make sure freq is a column vector
N = length(freq);
% compute complex calibration factors
if Chan=='B',
   [AmpL PhaseL] = calibrate(freq, FiltIndex, 'L');
   [AmpR PhaseR] = calibrate(freq, FiltIndex, 'R');
   calfL = db2a(AmpL).*exp(2*pi*i*PhaseL); % calibration Phase is in cycles
   calfR = db2a(AmpR).*exp(2*pi*i*PhaseR); % calibration Phase is in cycles
else,
   [Amp Phase] = calibrate(freq, FiltIndex, Chan);
   calf = db2a(Amp).*exp(2*pi*i*Phase); % calibration Phase is in cycles
end
% compute the calibrated spectra. Fixed Rho requires entirely different approach
if isempty(Rho), % xxPos and xxNeg are indeed positive & negative frequency components
   if Chan=='B',
      csPos = [calfL.*sPos, calfR.*sPos]; % two columns are [left right]
      csNeg = [calfL(N:-1:1).*sNeg, calfR(N:-1:1).*sNeg]; % reversed because freq>Nyquist
   else,
      csPos = calf.*sPos;
      csNeg = calf(N:-1:1).*sNeg, calf(N:-1:1).*sNeg; % reversed because freq>Nyquist
   end
else, % fixed Rho value: sNeg is indep noise spectrum; use it to mix
   % compute weight factors to arrive at correct correlation (see MvdH & Trahiotis, 1997)
   rPlus = (1+Rho)^0.5; % squares of coeffs add up to 2 - they should because ...
   rMin =  (1-Rho)^0.5; % the normalization of the spectra is based on equal contributions of Pos & Neg freq components
   sLeft = rPlus*sPos + rMin*sNeg; 
   sRight = rPlus*sPos - rMin*sNeg; 
   % now compute calibrated spectrum. Note: because rho is fixed, there are only positive frequencies
   if Chan=='B',
      csPos = [calfL.*sLeft, calfR.*sRight]; % two columns are [left right]
   elseif Chan=='L',
      csPos = calf.*sLeft;
   elseif Chan=='R',
      csPos = calf.*sRight;
   end
   csNeg = [];
end











