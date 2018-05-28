function [MaxSPL, BERT, Modulator] = prepareBERTstim(pp, force, nocalib);

if nargin<2, force=0; end;
if nargin<3, nocalib=0; end;
global BERTbuffer
markBuffer BERTbuffer; % mark global buffer for deletion after use

% check if previous call had identical params
try, % if exactly same params have been issued before, return stored BERTbuffer
   if isequal(BERTbuffer.pp, pp) & ~force & (nargout<3),
      BERT = BERTbuffer;
      MaxSPL = BERTbuffer.MaxSPL;
      return
   end; 
end

global SGSR
BERT = [];
BERT.pp = pp;
[fsam, ifilt] = safeSamplefreq(pp.CarrierFreq+pp.NoiseHF);
 % compute uncalibrated modulator noise; RMS = 1;
[Nsam,Spec,Wc,fAxis]  = GenWhiteNoise(pp.NoiseLF, pp.NoiseHF, ifilt, pp.burstDur, pp.Rseed);
Nbuf = length(Wc); % radix2 buffer size
RadPerSam = 2*pi*pp.CarrierFreq/fsam; % angular freq of tone in radians per sample
RadPerSam = round(RadPerSam*Nbuf)/Nbuf; % round so that integer # cycles fit in buffer
Tone = cos(RadPerSam*(1:Nbuf)'); % ampl = 1
Modulator = real(Wc);
ModTone = sqrt(2)*(1+1e-2*pp.modDepth*Modulator).*Tone; % modulated tone; RMS of car is 1
ModToneSpec = fft(ModTone);
% compute index of highest meaningfull spectral component that canbe calibrated
maxFreq = SGSR.samFreqs(ifilt)*SGSR.maxSampleRatio;
NmaxFreq = 1+round(Nbuf*maxFreq/fsam);
% discard freq beyond that (including neg freqs)
ModToneSpec(NmaxFreq+1:end) = 0;

sr = 1:Nsam; % total sample range
[RiseWin, samRise] = SimpleRamp(Nsam, fsam, pp.riseDur, 'rise');
[FallWin, samFall] = SimpleRamp(Nsam, fsam, pp.fallDur, 'fall');
Chans = pp.active; if Chans==0, Chans=[1 2]; end;
for ichan=Chans,
   if nocalib, calFac = 1;
   else, calFac = 2*calibrate(fAxis(NmaxFreq),ifilt,ichan, 0, 1); % complex calib factor
   end
   spec = ModToneSpec; % temp copy; other channel needs same uncalibrated spec
   % calibrate meaningful freqs (factor 2 makes up for deleting neg-freq components)
   spec(1:NmaxFreq) = calFac.*spec(1:NmaxFreq);
   % return to time domain
   wf = real(ifft(spec));
   % gate & ramp
   wf = wf(sr); 
   wf(samRise) =  wf(samRise).*RiseWin;
   wf(samFall) =  wf(samFall).*FallWin;
   Modulator(samRise) =  Modulator(samRise).*RiseWin;
   Modulator(samFall) =  Modulator(samFall).*FallWin;
   BERT.ModTone{ichan} = wf;
   % the tone is 0 dB SPL. How much can it be scaled up?
   MaxSPL(ichan) = a2db(maxMagDA/max(abs(BERT.ModTone{ichan})));
end

% store various params 
BERT.MaxSPL = MaxSPL;
BERT.fsam = fsam;
BERT.ifilt = ifilt;
BERT.Nsam = Nsam;
BERTbuffer = BERT; % store globally to save time upon next, ...
%               ... possibly identical, call


