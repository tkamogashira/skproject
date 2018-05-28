function info = EvalCyclicStorage(Freq, Dur, Fsample, Tol);

% evaluates the use of cyclic storage for a simple tone
%  Freq: tone freq in Hz
%      if complex, Freq=carFreq+i*modFreq
%  Dur: tone duration (steady portion) in ms
%  Fsample: sample freq in Hz
%  Tol: if Tol>0, 
%      Tol is tolerance in frequency deviation expressed
%      as deviation/Freq ("relative freq deviation")
%       if Tol<0,
%     -Tol is the tolerance expressed as cumulative phase lag/lead 
%      (in cycles) re true-Freq tone at the end of the tone.
%     in both cases, imaginary part indicate the tolerance
%     of the modulation frequency.
% info is struct variable containing info on the evaluation

% cast all argins in same multiplicity
[Freq, Dur, Fsample, Tol] = EqualizeSize(Freq, Dur, Fsample, Tol);

if length(Freq)>1,
   % per-component recursive call 
   [Nrow, Ncol] = size(Freq);
   for irow=1:Nrow,
      for icol=1:Ncol,
         info(irow,icol) = EvalCyclicStorage2(...
            Freq(irow,icol), Dur(irow,icol), ...
            Fsample(irow,icol), Tol(irow,icol));
      end
   end
   return;
end

%---from here, all args are single-valued

if ~isreal(Freq),
   % real(Freq) is carrier freq; imag(Freq) is modulation freq
   carFreq = real(Freq);
   modFreq = imag(Freq);
   carTol = real(Tol);
   modTol = imag(Tol);
   % first evaluate modFreq case  (the lowest freq, thus most critical)
   modInfo = EvalCyclicStorage2(modFreq, Dur, Fsample, modTol);
   NS = modInfo.NsamInCycBuf;
   % # car cycles in one cycbuf as dictated by modfreq&modTol
   NcarCycle = NS*carFreq/Fsample; 
   % convert carTol to rel freq dev
   if carTol<0,
      % convert to relative freq dev
      carTol = -carTol/(1e-20+carFreq*Dur*1e-3); % avoid dividing by zero
   end
   % now approximate NcarCycle by rational number P/Q
   [P Q] = cheaprat(NcarCycle, carTol);
   % this implies: Q cyclic buffers contain P car cycles within Tolerance
   % So if we take Q times longer cyclic buffers as dictated by modFreq alone,
   % we meet both carTol & modTol
   info = localRescaleInfo(modInfo, Q);
   % the info concerns modulation alone. Compute the values for carFreq
   NcycleInCycBuf = P;
   % Frequency is slightly altered
   NewFreq = NcycleInCycBuf/(info.NsamInCycBuf/Fsample);
   OrigFreq = carFreq;
   FreqDev=(NewFreq-OrigFreq)/OrigFreq;
   % cumulative phase lag/lead in cycles over Dur due to FreqDev
   CumPhaseDev = FreqDev*OrigFreq*Dur*1e-3;
   % express this new freq as angular freq (rad/sample)
   RadPerSam = 2*pi*NewFreq/Fsample;
   % combine car info and mod info (real/imag parts are car/mod infos)
   info.OrigFreq = i*info.OrigFreq + OrigFreq;
   info.NewFreq = i*info.NewFreq + NewFreq;
   info.FreqDev = i*info.FreqDev + FreqDev;
   info.CumPhaseDev = i*info.CumPhaseDev + CumPhaseDev;
   info.RadPerSam = i*info.RadPerSam + RadPerSam;
   info.NcycleInCycBuf = i*info.NcycleInCycBuf + NcycleInCycBuf;
   return;
end

%---from here only single-valued, real freq values--------

if Tol<0,
   % convert to relative freq dev
   Tol = -Tol/(1e-20+Freq*Dur*1e-3);
end


OrigFreq = Freq; % frequency originally asked for
SamP = 1e6/Fsample; % sample period in us
SamplesPerCycle = Fsample/Freq; % unrounded # sample per tone cycle
LiteralNsample = Dur*1e3/SamP; % # samples when stored literally
TotNcycle = Freq*Dur*1e-3; % total # cycles in tone
% now approximate SamplesPerCycle as integer ratio P/Q
[P Q] = cheaprat(SamplesPerCycle, Tol);
% SamplesPerCycle ~ P/Q
% This means that P samples ~ Q cycles within tolerance
% (CycBuf is cyclic buffer containing Q cycles)
while 1, % use P and Q for cyclic storage but check if # reps is not too big
   NsamInCycBuf = P;
   NcycleInCycBuf = Q;
   % Frequency is slightly altered
   NewFreq = Fsample*Q/P;
   % NrepOfCycBuf = floor(NewFreq*Dur*1e-3/NcycleInCycBuf);
   NrepOfCycBuf = floor(TotNcycle/NcycleInCycBuf);
   if NrepOfCycBuf>2^15-1,
      P = 2*P; Q=2*Q;
   else, break;
   end
end
FreqDev=(NewFreq-OrigFreq)/OrigFreq;
% cumulative phase lag/lead in cycles over Dur due to FreqDev
CumPhaseDev = FreqDev*OrigFreq*Dur*1e-3;
% express this new freq as angular freq (rad/sample)
RadPerSam = 2*pi*NewFreq/Fsample;

% we also need a remainder buffer RemBuf to fill the complete duration
RemDur = rem(Dur, SamP*1e-3*NsamInCycBuf); % in ms
% NsamInRemBuf = round(RemDur*1e3/SamP);
if NrepOfCycBuf==0, NsamInRemBuf = LiteralNsample; % all the samples are in remBuf
else, NsamInRemBuf = round(rem(LiteralNsample, NsamInCycBuf*NrepOfCycBuf));
end
if isequal(NsamInRemBuf, NsamInCycBuf), % rounding freak - correct
   NrepOfCycBuf = NrepOfCycBuf + 1;
   NsamInRemBuf = 0;
end
% the number of samples needed when using cyclic storage
CyclicNsample = NsamInRemBuf + NsamInCycBuf;
% efficiency factor for cyclic storage
EfficiencyFactor = CyclicNsample/(1e-20+LiteralNsample); % avoid dividing by zero
if EfficiencyFactor<0.9,
   StorageAdvice = 'Cyclic';
else,
   StorageAdvice = 'Literal';
end

% store relevant variables in info struct
info = collectInStruct(OrigFreq, NewFreq, FreqDev, CumPhaseDev, Fsample, ...
   Dur, LiteralNsample, CyclicNsample, EfficiencyFactor, RadPerSam,...
   NsamInCycBuf, NsamInRemBuf, NcycleInCycBuf, NrepOfCycBuf, StorageAdvice);


% -------------locals--------------

function Sinfo = localRescaleInfo(Info, Factor);
Sinfo = Info;
Sinfo.NcycleInCycBuf = Factor*Sinfo.NcycleInCycBuf;
Sinfo.NsamInCycBuf = Factor * Sinfo.NsamInCycBuf;
Sinfo.NrepOfCycBuf = floor(Sinfo.NrepOfCycBuf/Factor);
samP = 1e6/Info.Fsample; % in us
RemDur = rem(Sinfo.Dur, samP*1e-3*Sinfo.NsamInCycBuf); % in ms
Sinfo.NsamInRemBuf = round(RemDur*1e3/samP);
% the number of samples needed when using cyclic storage
Sinfo.CyclicNsample = Sinfo.NsamInRemBuf + Sinfo.NsamInCycBuf;
% efficiency factor for cyclic storage
Sinfo.EfficiencyFactor = Sinfo.CyclicNsample/(1e-20+Sinfo.LiteralNsample); % avoid dividing by zero
if Sinfo.EfficiencyFactor<0.9,
   Sinfo.StorageAdvice = 'Cyclic';
else,
   Sinfo.StorageAdvice = 'Literal';
end



