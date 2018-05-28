function CS = CalibStim(BWreg, Fhighest, highestBW, Force);

% get current calibration parameters

if nargin<1, BWreg=[]; end; 
if nargin<2, Fhighest=[]; end; 
if nargin<3, highestBW=[]; end; 
if nargin<4, Force=0; end;
   
if isempty(BWreg), BWreg=4000; end; % 4 kHz BW of regular bands
if isempty(Fhighest), Fhighest=1e6; end; % no narrower HF bands
if isempty(highestBW), highestBW=400; end; % 400-Hz HF-band bandwidth
   
params = calibParams;
params.version = 7;
%       SampleFreqs: [6.0096e+004 1.2500e+005]
%       maxSampleRatio: 0.4000
%           maxDAvalue: 32000
%       ADC_VoltPerBit: 3.0518e-004
%              maxFreq: 5.0000e+004
%              minFreq: 50
%             burstDur: 200
%              rampDur: 20
%    maxNoiseBandWidth: 4000
params.maxNoiseBandWidth = BWreg; % max bandwidth of regular noise bands
params.Nlowest = 2; % # lowest-freq bands that are narrower to avoid rumble
params.lowestBW = 100; % Hz bandwidth of lowest bands
params.Fhighest = Fhighest; % Hz freq above which to use highestBW
params.highestBW = highestBW; % Hz bandwidth of highest bands
params.type = 'noise calibration';

% decide if new stimuli must be generated; quit if not
if ~Force,
   CS = FromCacheFile('calibStim', params);
   if ~isempty(CS), return; end;
end

% initialize new calStim, generate stimuli, and save
CS.params = params;

global SGSR
Fmin = params.minFreq;
Fmax = params.maxFreq; % Hz
burstDur = params.burstDur; % ms
rampDur = params.rampDur; % ms 
BWreg = params.maxNoiseBandWidth ; % Hz
% duration is approx burstDur ms;
Nsam = round(1e-3*burstDur*SGSR.samFreqs);
% round to next radix-2 # samples for faster FFT
Nsam = 2.^ceil(log(Nsam)/log(2));
DF = SGSR.samFreqs./Nsam; % freq spacing in Hz
rampDur = params.rampDur; % ms 
NsamRamp = round(1e-3*rampDur*SGSR.samFreqs);
Nlowest = params.Nlowest; % # lowest-freq bands that are narrower to avoid rumble
Nhighest = max(0,ceil((Fmax-Fhighest)./highestBW)); % # highest-freq bands that are narrower to avoid noise floor
lowestBW = params.lowestBW; %bandwidth of lowest bands in Hz
Nreg = ceil((Fhighest-Fmin-Nlowest*lowestBW)./BWreg); % # regular bands
Nfilt = length(Nsam); % # different sample freqs or filters

% now determine the components in each band
NcompLB = round(lowestBW./DF); % # comp in lowest-freq bands
NcompReg = round(BWreg./DF); %  # comp in regular bands
NcompHB = round(highestBW./DF); % # comp in highest-freq bands

% components of the individual bands (columns: different samfreqs)
% counting is one-based, i.e. a given component k corresponds to a freq DF*(k-1)
Ncomp = [ones(Nlowest,1)*NcompLB;   ones(Nreg,1)*NcompReg; ones(Nhighest,1)*NcompHB];
iHigh = cumsum(Ncomp);  % highest component
iLow = iHigh - Ncomp+1;
Nband = size(Ncomp,1);
% there's a minimum freq - shift all components upward
nUp = round(Fmin*ones(Nband,1)*(1./DF));
iLow = iLow + nUp;
iHigh = iHigh + nUp;
% there's a hard upper freq limit  for each samfreq - impose it on ...
% ... iHigh and re-evaluate Ncomp
maxFreq = SGSR.samFreqs.*SGSR.maxSampleRatio;
iMax = ones(Nband,1)*floor(maxFreq./DF);
iHigh = min(iHigh, iMax);
Ncomp = iHigh-iLow+1;
Ncomp = max(Ncomp, 0);
% eliminate empty entries
empen = find(sum(Ncomp,2)==0);
if ~isempty(empen), % non-empty emptiness - eliminate.. 
   Nband = min(empen)-1;
   iLow=iLow(1:Nband,:);
   iHigh=iHigh(1:Nband,:);
   Ncomp=Ncomp(1:Nband,:);
end

% now compute the complex noise buffers from which the
% heterodyned bands can be computed at calib time
pool = 0;
WaveIndex = 0*Ncomp;
for iband=1:Nband,
   for ifilt = 1:Nfilt,
      ncomp = Ncomp(iband, ifilt);
      iden = ncomp+i*ifilt; % unique identifier for unheterodyned waveform
      matching = find(iden==pool);
      if isempty(matching) & (ncomp>0), % new - generate it
         nonzero = exp(2*pi*i*rand(ncomp,1)); % random-phase, equal-amplitude
         nsam = Nsam(ifilt); % total # samples
         trailzeros = zeros(nsam-1-ncomp,1);
         Spec = [0; nonzero; trailzeros]; % avoid DC component
         WaveForm = ifft(Spec);
         WaveForm = WaveForm * (maxmagDA/max(abs(WaveForm))); % avoid D/A clipping
         nsr = NsamRamp(ifilt);
         WaveForm(1:nsr) = WaveForm(1:nsr).*sin(linspace(0,pi/2,nsr)').^2;
         WaveForm(end-nsr+1:end) = WaveForm(end-nsr+1:end).*cos(linspace(0,pi/2,nsr)').^2;
         Spec = fft(0.5*WaveForm);
         Spec = Spec(2:ncomp+1); % the non-zero components only
         % plot(real(WaveForm)); return
         % update bookkeeping and store waveform and spectrum
         pool = [pool iden];
         matching = find(iden==pool);
         CS.WavePool(length(pool)) = collectInstruct(WaveForm, Spec);
      end
      if isempty(matching), matching = 1; end;
      WaveIndex(iband, ifilt) = matching;
   end
end

CS.bands = collectInstruct(DF, Ncomp, iLow, iHigh, WaveIndex);

% store in cache
ToCacheFile('calibStim', 2, params, CS);

