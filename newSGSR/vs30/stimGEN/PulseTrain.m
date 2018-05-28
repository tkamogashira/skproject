function PT = PulseTrain(Freq, Dur, Chan, PulseWidth, PulseType, fsam, Tol);
% PulseTrain - generate pulse train
%    PT = PulseTrain(Freq, Dur, Chan, PulseWidth, PulseType)
%    generates a pulse train, where:
%      Freq: pulse rate in Hz
%      Dur:  duration in ms
%      Chan: channel (L|R)
%      PulseWidth: total pulse width in us (default 100 us)
%      PulseType: +1 (-1): single pos (neg) sample among zeros
%                 +2 (-2): biphasic, pos (neg) sample leads
%    PT is a struct containing the fields
%      CycBuf: cyclic sample buffer (col vector) scaled to just below MaxMagDA
%      fsam: sample rate in Hz
%      BufLen: # samples in cyclic buffer
%      NrepCyc: # reps of cyclic buffer
%      Nremain: # remainning samples out of buffer of last, incomplete rep
%      Chan: equal to input Chan

persistent maxSPL
if (nargin==1) & isequal(inf,Freq), % query for most recently computed maxSPL
   PT = maxSPL;
   return;
end

if nargin<4, PulseWidth=[]; end;
if nargin<5, PulseType=[]; end;
if nargin<6, fsam=[]; end;
if nargin<7, Tol=[]; end;


if isempty(PulseWidth), PulseWidth = 100; % us
elseif PulseWidth>10e3, error('Pulse width cannot exceed 10000 us.'); end
if isempty(PulseType), PulseType = 1; end; % monophasic, positive
tempRes = 2; % us temporal resolution of sub-sample waveform delays
Dur = max(Dur,1e-3*PulseWidth);
if isempty(fsam), fsam = safeSamplefreq(MaxStimFreq); end;
if isempty(Tol), Tol = -5e-4; end; % max cumulative phase difference over burst dur in cycles

if isequal(Chan,'B'),
   PT = PulseTrain(Freq(1), Dur(1), 'L', PulseWidth(1), PulseType(1));
   PTR = PulseTrain(Freq(end), Dur(end), 'R', PulseWidth(end), PulseType(end));
   PT.CycBuf = {PT.CycBuf PTR.CycBuf}; 
   PT.BufLen = [PT.BufLen PTR.BufLen]; 
   PT.NrepCyc = [PT.NrepCyc PTR.NrepCyc]; 
   PT.Nremain = [PT.Nremain PTR.Nremain]; 
   PT.NsamTotal = max(PT.NsamTotal, PTR.NsamTotal);
   PT.Chan = Chan;
   maxSPL = [PT.maxSPL PTR.maxSPL]; % reember persistent varaible
   PT.maxSPL = maxSPL;
   return;
else, % make sure no multiple-valued args are used below
   if isequal(Chan,'L'),
      Freq = Freq(1); Dur = Dur(1); PulseWidth = PulseWidth(1); PulseType = PulseType(1); Tol=Tol(1);
   else,
      Freq = Freq(end); Dur = Dur(end); PulseWidth = PulseWidth(end); PulseType = PulseType(end); Tol=Tol(end);
   end
end

PbufWidth = max(2, 1.5e-3*PulseWidth); % ms duration of single-pulse buffer

global SGSR
fmax = fsam*SGSR.maxSampleRatio;
samp = 1e6/fsam; % sample period in us
NsamT = round(PbufWidth*1e3/samp); % # samples in single-pulse buffer
NsamF = 2^nextpow2(NsamT); % # samples in fft buffer
df = fsam/NsamF;
freq = linspace(0,fsam-df,NsamF).'; % freq axis (column vector)
calFreq = find(freq<=fmax); % frequencies for which calibration is defined
toohighFreq = find(freq>fmax); % frequencies for which calibration is NOT defined
[Amp Phase] = calibrate(freq(calFreq),NfiltInsetup, Chan);
calibrator = 1e40+freq*0; % correct size; hughe default values (out-of-range values)
calibrator(calFreq) = db2a(Amp).*exp(2*pi*i*Phase); % SPL -> DAC spectral multiplier

% build single-pulse spectrum; start in time domain
pulseBuf = zeros(NsamF,1);
monophase = isequal(abs(PulseType),1);
if monophase,
   NsamP = round(PulseWidth/samp);
   NsamP = max(NsamP,2);
   pulseBuf(1:NsamP) = sign(PulseType);
else,
   NsamP = round(PulseWidth/samp);
   NsamP = max(NsamP,1);
   pulseBuf(1:NsamP) = sign(PulseType);
   pulseBuf(NsamP+(1:NsamP)) = -sign(PulseType);
end
pulseSpec = fft(pulseBuf);
% SPL corresponds to RMS w/o calibration
SFreq = Freq;
if Freq==0,
   SFreq = 100; % convention: single clicks are calibrated re 100 Hz trains
   Freq = 1e3/Dur/2;
end
SPLtheor = 6+p2db(mean(real(ifft(pulseSpec./calibrator)).^2)); % calibration-weighted sum of all components of click
SPLtheor = SPLtheor + p2db(NsamF/NsamT); % compensate for truncation in time domain
SPLtheor = SPLtheor + p2db(SFreq*PbufWidth*1e-3); % compensate for the fact that true rate ~= 1/MaxWidth
pulseBuf = pulseBuf(1:NsamT);

% evaluate cyclic buffer usage ..
% .. and determine timing of individual pulses in buffer
info = evalCyclicStorage2(Freq, Dur, fsam, Tol);
Ntot = round(info.LiteralNsample);
if isequal(info.StorageAdvice,'Cyclic'),
   Ncyc = info.NcycleInCycBuf;
   BufLen = info.NsamInCycBuf;
else,
   Ncyc = floor(Freq*Dur*1e-3);
   if Ncyc==0, Ncyc=1; end;
   BufLen = round(info.LiteralNsample);
end

BufDur = BufLen*samp*1e-3; % buffer duration in ms
% determine Offsets of different pulses in cyclic buffer
TotOffsets = (0:(Ncyc-1))*BufDur/Ncyc; % in ms
% integer number of samples contained in offsets
IntOffsets = round(1e3*TotOffsets/samp);

% now set up the periodic buffer and fill it with the various, time-shifted, pulses
CycBuf = zeros(BufLen,1);
for ii=1:Ncyc,
   tRange = IntOffsets(ii)+(1:NsamT);
   tRange = tRange(find(tRange<=BufLen));
   CycBuf(tRange) = CycBuf(tRange) + pulseBuf(1:length(tRange));
end
% If the pulses do not overlap, or else add incoherently, the RMS
% of the train is equal to RMStheor (see above). Compensate
% for the fact that the pulses may in fact add somewhat coherently.
SumSquarePulse = mean(sum(pulseBuf.^2))*Ncyc; % estimate from incoherent addition
SumSquareTrain = sum(CycBuf.^2); % true value
OverLapCorrection = 0; % p2db(SumSquareTrain/SumSquarePulse);

ScaleFactor = MaxMagDA/max(abs(CycBuf));
CycBuf = CycBuf * ScaleFactor;
maxSPL = a2db(ScaleFactor) + SPLtheor + OverLapCorrection;

% return everything in struct variable
NrepCyc = info.NrepOfCycBuf;
Nremain = info.NsamInRemBuf;
NsamTotal = length(CycBuf)*NrepCyc + Nremain;
PT = collectInStruct(CycBuf, fsam, BufLen, NrepCyc, Nremain, NsamTotal, Chan, maxSPL);

