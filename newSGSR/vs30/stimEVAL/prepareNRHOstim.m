function  [maxSPL, NRHO] = prepareNRHOstim(pp);
% check if previous call had identical params
global NRHObuffer
MarkBuffer NRHObuffer; % mark global buffer for deletion after use

% strip non-essential parameters from pp struct, i.e., those parameters
% that do not effect the computation of NRHObuffer.
pp = localStrip(pp);
% add calibration data (these ARE critical to the waveform computation!)
global CALIB
pp.calibFile = CALIB.ERCfile;

try, % if exactly same params have been isuued before, return stored AKbuffer
   if isequal( NRHObuffer.pp, pp),
      maxSPL = NRHObuffer.maxSPL;
      NRHO =  NRHObuffer.maxSPL;
      return
   end; 
end
% look in cache
CacheFilename = 'RecentStim';
NRHO = FromCacheFile(CacheFilename,pp);
if ~isempty(NRHO), % found in cache - ready
   NRHObuffer = NRHO;
   maxSPL = NRHO.maxSPL;
   return;
else, clear NRHO; % start from scratch
end

[NRHO.Fsam, NRHO.iFilt] = safeSamplefreq(pp.highFreq); % Nyquist
samperiod = 1e6/NRHO.Fsam;

% generate the noise vectors if needed
maxMag = nan*[1 1];

Chans = pp.active; if Chans==0, Chans=[1 2]; end;
effDur = max(pp.burstDur+abs(pp.delay)); % effective duration for non-gated noise
bufDur = max(effDur, 200); % buffer duration should not be to short or ensemble props are ill-represented
NRHO.Nburst = round(effDur*NRHO.Fsam*1e-3);
phafac = [1 1]; % default: trivial
try, % pp.NRHOversion might not exist
    if pp.NRHOversion>2, % nontrivial IPD
        if pp.varchan==1, phafac = [pp.IPD 0]; else, phafac = [0 -pp.IPD];end;
        phafac = exp(2*pi*i*phafac/360); % deg -> phasor
    else, phafac = [1 1]; % trivial
    end % if
end; % try
for ichan=Chans,
   pf = phafac(ichan); % phase factor for this channel
   % two independent sources per ear;  need to compute them separately for each channel due to calibration differences
   [NRHO.N(ichan), dum,  wf] = GenWhiteNoise(pp.lowFreq, pp.highFreq, NRHO.iFilt, bufDur, pp.Rseed, ichan, pp.delay(ichan));
   wf = real(pf*wf);
   [NRHO.N(ichan), dum,  wfi] = GenWhiteNoise(pp.lowFreq, pp.highFreq, NRHO.iFilt, bufDur, pp.Rseed+1, ichan, pp.delay(ichan));
   wf = wf + i*imag(pf*wfi); % real and imag parts are independent noise waveforms
   wf = wf(1:NRHO.Nburst); % restrict to max burst duration of both channels
   BurstDur = pp.burstDur(min(ichan,end)); % burstdur of current channel
   % apply gating now; include ITD
   [RiseWin, FallWin] = gatingrecipes(...
      pp.delay(ichan), BurstDur, pp.riseDur, pp.fallDur, NRHO.Nburst, samperiod);
   NRHO.Wv{ichan} = applyGating(wf, RiseWin, FallWin);
   maxMag(ichan) = 1e-100 + sqrt(2)*max(abs(NRHO.Wv{ichan})); % sqrt(2): real and imag part will be mixed eventually
end

% upper limit for sample magnitudes
NRHO.maxSPL = a2db(maxMagDA./maxMag);
maxSPL = NRHO.maxSPL;

NRHO.pp = pp;
NRHObuffer = NRHO; % store globally to save time upon next, ...
%               ... possibly identical, call

% store in cache to speed up stimulus generation of frequently used stuff
ToCacheFile(CacheFilename, 10, pp, NRHO);


%---------------------------
function pp = localStrip(pp);
% strip non-critical params from struct, not by removing them,
% but by assigning to them nonsense values. In this way,
% errors will result if the non-critical params are ever used -
% indicating that they were critical after all.
noncrit = {'interval', 'order', 'SPL', 'noisePolarity', 'rho'};
for ii=1:length(noncrit),
   eval(['pp.' noncrit{ii} ' = inf;'])
end



