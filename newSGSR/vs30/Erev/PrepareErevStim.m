function MaxSPL = PrepareErevStim(pp, FakeCal, forceCompu);
% PrepareErevStim - prepares Erev Noise stimulus
if nargin<2, FakeCal=0; end;
if nargin<3, forceCompu=0; end;
global EREVnoiseL EREVnoiseR
markbuffer EREVnoiseL; markbuffer EREVnoiseR;  % mark global buffers for deletion after use

UMPS = [];
if pp.active==0,
   M1 = PrepareErevStim(setfield(pp,'active',1));
   M2 = PrepareErevStim(setfield(pp,'active',2));
   MaxSPL = [M1(1), M2(2)];
   return;
end

if ~isfield(pp,'SpecType'),
   pp.SpecType = 2; % default is Gauss
end
if ~isfield(pp,'ErevVersion'),
   pp.ErevVersion = 1; 
end
if ~isfield(pp,'RejectAtt'),
   pp.RejectAtt = 0; 
end
if ~isfield(pp,'RejectFreq'),
   pp.RejectFreq = [nan nan]; 
end

chacha = channelChar(pp.active);
Gname = ['EREVnoise' chacha];

if pp.Ntoken>MaxNerevBuffers, % use mixing instead of literal buffers
   pp.Ntoken=MaxNerevBuffers; 
   Mix = 1;
else, Mix = 0;
end 

% the following selected params determine the noise exactly
noiseParam = SelectFromStruct(pp, 'active', 'NoiseDur', 'NoiseBW',...
   'FreqPos' ,'ToneFreq', 'Rseed', 'Ntoken', 'SpecType', ...
   'ErevVersion', 'RejectAtt', 'RejectFreq');
% the real work is computation of the noise - only do that when new noise type is needed
if localNewNP(noiseParam) | forceCompu,
   BufVar = localPrepNoise(noiseParam, chacha, Mix, FakeCal);
else, % previously computed noise is okay - pick up params
   eval(['BufVar = ' Gname '.BufVar;']);
end;

% consider sum of noise and tone and compute max SPL of tone
nomNoiseLevel = max(pp.SPLnoise) + BufVar.MaxSPLtone - BufVar.MaxSPLnoise;
BufVar.MaxSPL = BufVar.MaxSPLtone - a2db(1 + db2a(nomNoiseLevel));
% put BufVar back in EREVnoiseX
eval([Gname '.BufVar = BufVar;']);
% the output arg MaxSPL is always a 2-vector [left right]; supply infs
if chacha=='L', MaxSPL = [BufVar.MaxSPL inf];
else, MaxSPL = [inf, BufVar.MaxSPL];
end
%-----------------------------------------------------------------------
function ISN = localNewNP(noiseParam);
global EREVnoiseL EREVnoiseR
ISN = 1;
try %  don't  crash but return default when EREVnoisX is empty
   if noiseParam.active==1,
      ISN = ~isequal(noiseParam, EREVnoiseL.noiseParam);
   else,
      ISN = ~isequal(noiseParam, EREVnoiseR.noiseParam);
   end
end
%------
function BufVar=localPrepNoise(pp, chacha, Mix, FakeCal);
Gname = ['EREVnoise' chacha];
eval(['global ' Gname]);
% start finding out details about stimulus
[Fsam, iFilt] = safeSamplefreq(pp.ToneFreq+0.5*pp.NoiseBW);
NsamNoise = round(Fsam*1e-3*pp.NoiseDur);
% round # samples to speed up FFTs
NsamNoise = lowFacApprox(NsamNoise,13);
df = Fsam/NsamNoise; % freq spacing
fAxis = (0:NsamNoise-1)*df; % freq axis in Hz
Flow = pp.ToneFreq + (pp.FreqPos-3)*0.5*pp.NoiseBW;
Fhigh = Flow + pp.NoiseBW;
n0 = 1+round(Flow/df); % first non-zero sample in spectrum
NnonZero = round((Fhigh-Flow)/df);
n1 = n0+NnonZero-1; % last non-zero sample in spectrum
Spec = [];
[CalAmp, CalPhase] = calibrate(fAxis(n0:n1),iFilt, chacha,FakeCal);
CalPhase = 2*pi * CalPhase; % cyc->rad
CalibFac = db2a(CalAmp).*exp(i*CalPhase);
SetRandState(pp.Rseed);
for itok=1:pp.Ntoken
   rr = randn(NnonZero,1)+i*randn(NnonZero,1);
   if pp.SpecType==1, % eq amp
      rr = sqrt(2)*rr./abs(rr);
   end
   Spec = [Spec, rr.*CalibFac(:)];
end
upZero = zeros(n0-1,pp.Ntoken);
downZero = zeros(NsamNoise-n1,pp.Ntoken);
Spec = [upZero; Spec; downZero];
% attenuation band
if pp.RejectAtt>0,
   Irej = 1+round(pp.RejectFreq/df); 
   Irej = Irej(1):Irej(2); % indices of rejected components
   Spec(Irej,:) = Spec(Irej,:)*db2a(-pp.RejectAtt); % all columns
end
% compute expected SPL (see GaussNoiseBand for explanation)
RMSwaveform = NnonZero^0.5/NsamNoise;
SPLwaveform = a2db(RMSwaveform);
% compute waveform without taking real part - we need ....
% ... analytical signal for erev trick
% columnwise FFT
Wv = ifft(Spec);
maxSam = max(abs(real(Wv)),[],1); % max along columns
grandMaxSam = max(maxSam);
if Mix, TotMaxSam = sum(maxSam);
else, TotMaxSam = max(maxSam);
end
ScaleFactor = MaxMagDA/TotMaxSam;
MaxSPLnoise = SPLwaveform + a2db(ScaleFactor) + Mix*p2db(pp.Ntoken);
MaxSPLtone = maxNumToneLevel - calibrate(pp.ToneFreq,iFilt, chacha,FakeCal);
eval([Gname '.NoiseWaveform = ScaleFactor*Wv; ']);
TrueNoiseDur = NsamNoise*1e3/Fsam;
NtoneCycles = round(1e-3*TrueNoiseDur*pp.ToneFreq);
switch pp.ErevVersion
case 1, % tone rotates, noise is repeated
   NtoneCycles = NtoneCycles + 0.25;
   NoiseTwistor = 0;
case 2, % tone fits in one period but noise cycles
   NoiseTwistor = -0.5*pi*i/NsamNoise;
end
% (N+0.25) tone periods must fit in noise buffer
TrueToneFreq = NtoneCycles/(1e-3*TrueNoiseDur);
% store secondary params in EREVnoise global filed BufVar
BufVar = collectInStruct(MaxSPLnoise, MaxSPLtone, Mix, NsamNoise, Fsam, iFilt, ...
   TrueNoiseDur, TrueToneFreq, NoiseTwistor);
% store current stimulus params to save computation time
% when called with identical parameter values
eval([Gname '.noiseParam = pp; ']);
% store faits divers
eval([Gname '.BufVar = BufVar; ']);


