function BN = prepareBNstim(pp);
% check if previous call had identical params
global BNbuffer
markBuffer BNbuffer % mark global buffer for deletion after use

try, % if exactly same params have been isuued before, return stored BNbuffer
   if isequal(BNbuffer.pp, pp),
      BN = BNbuffer;
      return
   end; 
end
  
BN.mess = '';


if pp.DDfreq<0.25, % Hz
   BN.mess = 'smallDD';
   return;
end
Kmeansepa = round(pp.MeanSepa/pp.DDfreq);
if Kmeansepa<1,
   BN.mess = 'separatio';
   return;
end

if ~isfield(pp,'Tilt'),
   pp.Tilt = 0;
end

% handle multiplicity by recursive calls
if length(pp.MidFreq)>1,
   BN = []; % initialize
   for ifreq=1:length(pp.MidFreq),
      freq = pp.MidFreq;
      pp_i = pp;
      pp_i.MidFreq = pp.MidFreq(ifreq);
      BN = vcatstruct(BN,prepareBNstim(pp_i)); % field-wise vertcat
   end
   BN.pp = pp;
   BNbuffer = BN; % store globally 
   return
elseif size(pp.SPL,1)>1,
   BN = []; % initialize
   spl = pp.SPL;
   pp.SPL = max(pp.SPL);
   BN = prepareBNstim(pp); % field-wise vertcat
   BN.pp.SPL = spl;
   BNbuffer = BN; % store globally 
   return
end

% zwuis numerology
N4 = 4*ceil(pp.Ncomp/4);
sepa = 1:N4;
sepa = reshape(sepa,4,N4/4);
sepa = sepa([3 4 1 2],:);
sepa = reshape(sepa,1,N4);
sepa = sepa(1:pp.Ncomp-1);
sepa = sepa - round(mean(sepa)) + Kmeansepa;
if any(sepa<1),
   BN.mess = 'crowded';
   return;
end

minDF = min(sepa)*pp.DDfreq;
maxDF = max(sepa)*pp.DDfreq;

% compute component frequencies as multiples of DDfreq
Kmidf = round(pp.MidFreq/pp.DDfreq);
Kfreq = [0 cumsum(sepa)];
Kfreq = Kfreq - round(mean(Kfreq)) + Kmidf;
Ncomp = pp.Ncomp;

toss = [];
if (pp.BNversion>6), % throw away components that have a Tilt of 888
   if ~isempty(pp.Tilt),
      toss = find((pp.Tilt==888) | (pp.Tilt==88));
   end
   if pp.BNversion>7,
      if ~isempty(toss),
         Kfreq(toss) = [];
         pp.Tilt(toss) = [];
         Ncomp = length(Kfreq);
      end
   end
end

% build complex spectrum, calibrated
if pp.BNversion>6, % let factors other than Rseed codetermine randomization
   RS = pp.Rseed + 31*round(pp.MidFreq+pp.MeanSepa.^2+Ncomp.^3);
else,
   RS = pp.Rseed;
end
SetRandState(RS);
NonZeroSpec = sqrt(2)*exp(2*pi*i*rand(1,Ncomp)); % rms=1 (~0 dBnum); random phase
if length(pp.Tilt)==1,
   if pp.Tilt<0, 
      PreEmp = linspace(0,pp.Tilt,Ncomp);
   else,
      PreEmp = linspace(-pp.Tilt,0,Ncomp);
   end
else,
   att = pp.Tilt;
   PreEmp = zeros(1,Ncomp);
   for ii=1:length(att),
      PreEmp(ii) = att(ii);
   end
   PreEmp = -PreEmp + min(PreEmp); % never amplify, always attenuate
end
if pp.BNversion>7,
   % most intense component has correct SPL
   PreEmp = PreEmp-max(PreEmp);
   AmpFactor = db2a(PreEmp);
else,
   % scale preEmp such that total power is unchanged
   AmpFactor = db2a(PreEmp);
   oldNorm = norm(AmpFactor);
   AmpFactor = sqrt(Ncomp)*AmpFactor/norm(AmpFactor);
   newNorm = norm(AmpFactor);
   PreEmp = round(a2db(AmpFactor));
end
% disp('-------------');
NonZeroSpec = NonZeroSpec.*AmpFactor;
if (pp.BNversion>9) & (pp.NoiseEar~=3), % noise co-determines sample rate
   [Fsam, ifilt] = safeSampleFreq(max(pp.NoiseCutoff(end), pp.DDfreq*max(Kfreq)));
else,
   [Fsam, ifilt] = safeSampleFreq(pp.DDfreq*max(Kfreq));
end
NsamCyc = round(Fsam/pp.DDfreq); % cycle must divide sample rate
if pp.BNversion>5,
   NsamCyc = lowFacApprox(NsamCyc,13); % small factors -> fast fft
end
DDfreq = Fsam/NsamCyc; % rounded fundamental
SpecL = zeros(1,NsamCyc); % frequency spacing is DDfreq
SpecR = zeros(1,NsamCyc); % frequency spacing is DDfreq
[CalAmpL, CalPhaseL] = calibrate(Kfreq*DDfreq,ifilt,'L');
[CalAmpR, CalPhaseR] = calibrate(Kfreq*DDfreq,ifilt,'R');
CalFactorL = db2a(CalAmpL).*exp(2*pi*i*CalPhaseL);
CalFactorR = db2a(CalAmpR).*exp(2*pi*i*CalPhaseR);
SpecL(Kfreq+1) = NonZeroSpec.*CalFactorL;
SpecR(Kfreq+1) = NonZeroSpec.*CalFactorR;

NoiseRS = 0;
Ncyc = [1 1]*round(pp.TotDur*DDfreq);
% complex waveform via IFFT; 
CWaveL = (db2a(pp.SPL(1))*NsamCyc)*ifft(SpecL);
CWaveR = (db2a(pp.SPL(end))*NsamCyc)*ifft(SpecR);
% replace "contralateral" channel with noise if requested
if (pp.BNversion>9) & (pp.NoiseEar~=3), % contralateral noise
   trueDur = NsamCyc*1e3/Fsam; % exact duration in ms of zwuis cycle
   dilFac = sqrt(2); % diletation factor
   if (pp.BNversion==11), % cat two succesive cycles with a phase twist for the noise
      noiseDur = trueDur;
   else,
      noiseDur = dilFac*trueDur;
   end
   if (pp.BNversion>11), NoiseRS = setRandState; else, NoiseRS=RS; end
   [Nnoise, dum, NoiseWf] = GenWhiteNoise(pp.NoiseCutoff(1), pp.NoiseCutoff(2), ifilt, ...
      noiseDur, NoiseRS, pp.NoiseEar, 0, 1);  % two last args: delay=0; cyclic=1
   if (Nnoise~=NsamCyc) & (pp.BNversion<10), error('#sample mismatch'); end
   NoiseWf = NoiseWf(1:Nnoise);
   NoiseWf = NoiseWf(:).'*db2a(pp.NoiseSPL); % row vector; scale at once to requested level
   % dsiz(NoiseWf)
   NsamCyc = NsamCyc*[1 1];
   if (pp.BNversion>10), % cat two succesive cycles with a phase twist for the noise
      NN = 2*length(NoiseWf);
      NoiseWf = [NoiseWf, NoiseWf].*exp(i*linspace(1/NN,2*pi,NN));
   end
   NsamCyc(pp.NoiseEar) = length(NoiseWf);
   Ncyc(pp.NoiseEar) = ceil(pp.TotDur*Fsam/(NsamCyc(pp.NoiseEar)));
   switch pp.NoiseEar,
   case 1, CWaveL = NoiseWf;
   case 2, CWaveR = NoiseWf;
   end
   clear dum NoiseWf
end
% evaluate max levels
marginL = a2db(maxMagDA/max(abs(CWaveL)));
marginR = a2db(maxMagDA/max(abs(CWaveR)));
CWaveL = CWaveL*db2a(marginL);
CWaveR = CWaveR*db2a(marginR);
maxSPL = [marginL, marginR]+pp.SPL;

% compute beat freqs & their spectral components
Q2.EE0 = NonZeroSpec(1:Ncomp);
for ii=1:Ncomp-1,
   iistr = num2str(ii);
   dfname = ['Q1.DF' iistr]; % Q1.DF1 Q1.DF2, etc
   e2name = ['Q2.EE' iistr]; % Q2.EE1 Q2.EE2, etc
   indexLHS = ii+1:Ncomp;
   indexRHS = 1:Ncomp-ii;
   eval([dfname ' = Kfreq(indexLHS) - Kfreq(indexRHS);' ]);
   eval([e2name ' = conj(NonZeroSpec(indexLHS)).*NonZeroSpec(indexRHS);' ]);
end

if Ncomp>2,
   if max(Q1.DF1)>=min(Q1.DF2) & isempty(toss),
      BN.mess = 'overlap';
      return;
   end
end
% store relevant info
mess = '';
BN = CollectInStruct(mess, pp, Fsam, ifilt, NsamCyc, Ncyc, ...
   Kmidf, Kfreq, minDF, maxDF, DDfreq, ...
   maxSPL, SpecL, SpecR, CWaveL, CWaveR, PreEmp, toss, NoiseRS);
BN = CombineStruct(BN,Q1);
BN = CombineStruct(BN,Q2);

BNbuffer = BN; % store globally to save time upon next, ...
%               ... possibly identical, call



% figure; plot(real(CWaveL)); uiwait(gcf);






