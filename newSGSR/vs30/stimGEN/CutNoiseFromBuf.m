function token=CutNoiseFromBuf(Chan, WavDelay, PhaseLag, Rho, NburstBuf, CutOffset, ...
   NumAtt, OnsetDelay, BurstDur, RampDur, PhasorSpeed);

% CutNoiseFromBuf - cuts single token from pre-computed RnoiseBuffer

if nargin<6, CutOffset=[]; end

% if CutOffset is not specified (empty), make one up
CutOffset = SetRandState(CutOffset);

global RnoiseBuffer

persistent LastCutOffset
if isempty(LastCutOffset), % initialize it to zero
   LastCutOffset = zeros(size(RnoiseBuffer.Params.NSAM)); 
end

if CutOffset<0, % continue where we stopped last time
   CutOffset = LastCutOffset;
end

CutOffset = rem(CutOffset, 4*RnoiseBuffer.Params.NSAM);
startIfactor = i.^floor(CutOffset./RnoiseBuffer.Params.NSAM);

if IsAnalyticBuf, 
   if isempty(Rho), Rho = RnoiseBuffer.Rho; end
end


[WaveFormIndex, ExtraAngle] = local_findWaveForm(Chan, WavDelay, PhaseLag, Rho);
phasor = exp(i*ExtraAngle);
scaleFactor = phasor*db2a(-NumAtt);
Nbuf = length(RnoiseBuffer.Buf);
token = zeros(NburstBuf,1);
for ibuf=1:Nbuf,
   % the code below can be formulated much more elegantly, but speed is more important here
   Nsam = RnoiseBuffer.Params.NSAM(ibuf);
   remainder = NburstBuf;
   miniOffset =  rem(CutOffset(ibuf), RnoiseBuffer.Params.NSAM(ibuf));
   currentIFactor = startIfactor(ibuf);
   firstIndex = []; lastIndex = []; Sfactor = [];
   Npatch = 0;
   while remainder>0,
      Npatch = Npatch+1;
      firstIndex(Npatch) = miniOffset+1;
      lastIndex(Npatch) = min(Nsam, firstIndex(Npatch)-1+remainder);
      Sfactor(Npatch) = scaleFactor*currentIFactor;
      NSamPatch(Npatch) = lastIndex(Npatch) - firstIndex(Npatch) + 1;
      remainder = remainder-NSamPatch(Npatch);
      currentIFactor = currentIFactor*i;
      miniOffset = 0;
   end
   tokenOffset = 0;
   for ipatch = 1:Npatch,
      ti1 = tokenOffset + 1;
      ti2 = tokenOffset + NSamPatch(ipatch);
      i1 = firstIndex(ipatch);
      i2 = lastIndex(ipatch);
      if ibuf==1,
         token(ti1:ti2) = real(Sfactor(ipatch)*RnoiseBuffer.Buf(ibuf).Waveform(i1:i2,WaveFormIndex));
      else,
         token(ti1:ti2) = token(ti1:ti2) + real(Sfactor(ipatch)*RnoiseBuffer.Buf(ibuf).Waveform(i1:i2,WaveFormIndex));
      end
      tokenOffset = tokenOffset + NSamPatch(ipatch);
   end
end
% update LastCutOffset
LastCutOffset = CutOffset + NburstBuf;

% now we have a "raw" token, i.e., not provided with ramps, onset and heading and trailing silence.
% this is all figured by GatingRecipes
SamPeriod = 1e6/RnoiseBuffer.Params.Fsample; % sample period in us
GatingDelay = OnsetDelay*1e-3; % us -> ms
riseDur = RampDur(1);
fallDur = RampDur(end);
[RisePresc, FallPresc] = ...
   GatingRecipes(GatingDelay, BurstDur, riseDur, fallDur, [NburstBuf 1], SamPeriod);
% apply the gating recipes and turn into row vector
token = ApplyGating(token, RisePresc, FallPresc).';


%-------------locals----------------------------
function Matching = local_WaveformsMatch(wv1, wv2, Analytical);
Matching = isequal(wv1.Chan, wv2.Chan) ...
   & isequal(wv1.WavDelay, wv2.WavDelay);
if Analytical, % analytical stimulus: Rho must match
   Matching = Matching & isequal(wv1.Rho, wv2.Rho);
   % if rho is multiple-valued, the values should differ at most by a constant
   if (length(wv1.PhaseLag)>1) | (length(wv2.PhaseLag)>1),
      p1 = wv1.PhaseLag;
      p2 = wv2.PhaseLag;
      Matching = Matching ...
         & isequal(p1(2:2:end),p2(2:2:end)) ... % boundary freqs must match
          & (norm(diff(p1(1:2:end)-p2(1:2:end)))<eps); % values should differ by overall constant
   end
else, % full spectrum: Rho is free; phase must match
   Matching = Matching & isequal(wv1.PhaseLag, wv2.PhaseLag);
end

function [WaveFormIndex, ExtraAngle] = local_findWaveForm(Chan, WavDelay, PhaseLag, Rho);
% returns index of WaveForm containing desired params. If non-existing, a new one is generated
desiredWf = CollectInStruct(Chan, WavDelay, PhaseLag, Rho);
global RnoiseBuffer
Nwf = length(RnoiseBuffer.WaveFormPool);
WaveFormIndex = NaN;
for iwf=1:Nwf,
   if local_WaveformsMatch(desiredWf, RnoiseBuffer.WaveFormPool(iwf), isAnalyticBuf),
      WaveFormIndex = iwf;
      break;
   end
end
if isnan(WaveFormIndex), % not found - make it
   WaveFormIndex = ComputeNoiseWaveForm(Chan, WavDelay, PhaseLag, Rho);
end
if isAnalyticBuf, % extra phase angle is determined by PhaseLag mismatch ...
   % ... in case of multiple (freq dependent) phase lags, we take the 1st one by convention
   ExtraAngle = -2*pi*(PhaseLag(1) - RnoiseBuffer.WaveFormPool(WaveFormIndex).PhaseLag(1));
else, % extra phase angle is determined by Rho mismatch
   % ... in case of multiple (freq dependent) rho values, we take the 1st one by convention
   RhoSign = sign(channelNum(Chan)-1.5);
   DesiredAngle = RhoSign*0.5*acos(Rho);
   PresentAngle = RhoSign*0.5*acos(RnoiseBuffer.WaveFormPool(WaveFormIndex).Rho(1));
   ExtraAngle = DesiredAngle - PresentAngle;
end





