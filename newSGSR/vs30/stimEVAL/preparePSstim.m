function  [maxSPL, PS] = preparePSstim(pp);
% preparePSstim

% check if previous call had identical params
global PSbuffer
MarkBuffer PSbuffer; % mark global buffer for deletion after use

% strip non-essential parameters from pp struct, i.e., those parameters
% that do not effect the computation of PSbuffer.
pp = localStrip(pp);
% add calibration data (these ARE critical to the waveform computation!)
global CALIB
pp.calibFile = CALIB.ERCfile;
try, % if exactly same params have been issued before, return stored PSbuffer
   if isequal( PSbuffer.pp, pp),
      maxSPL = PSbuffer.maxSPL;
      PS =  PSbuffer.maxSPL;
      return
   end; 
end

% look in cache
CacheFilename = 'RecentStim';
PS = FromCacheFile(CacheFilename, pp);
if ~isempty(PS), % found in cache - ready
   PSbuffer = PS;
   maxSPL = PS.maxSPL;
   return;
else, clear PS; % start from scratch
end

%===REAL WORK FROM HERE======================================
[Fsam, iFilt] = safeSamplefreq(pp.freq); 

steadyDur = pp.burstDur - pp.riseDur - pp.fallDur;
cycInfo = EvalCyclicStorage2(pp.freq, steadyDur, Fsam, -0.01);

Chans = pp.active; if Chans==0, Chans=[1 2]; end;

samperiod = 1e6/Fsam;
maxSPL = a2db(maxmagda)-calibrate(pp.freq,1,0)-3; % simple tones
maxSPL = denan(maxSPL);
Nrise = round(1e3*pp.riseDur/samperiod);
Nfall = round(1e3*pp.fallDur/samperiod);
if isequal('Cyclic', cycInfo.StorageAdvice),
   Nsteady  = cycInfo.NsamInCycBuf;
   NrepSteady = cycInfo.NrepOfCycBuf;
   Nrem = cycInfo.NsamInRemBuf;
   RPS = cycInfo.RadPerSam;
else, % literal storage
   Nsteady  = round(1e3*steadyDur/samperiod);
   NrepSteady = 1;
   Nrem = 0;
   RPS = 2*pi*pp.freq/Fsam;
end

Nburst = Nrise + NrepSteady*Nsteady + Nrem + Nfall;
NrepSil = round(1e3*pp.interval/samperiod) - Nburst;
NrepSil = max(0, NrepSil);

riseWin = sin(linspace(0,pi/2,Nrise).').^2;
fallWin = cos(linspace(0,pi/2,Nfall).').^2;

% phase jump must be relative prime to # jumps
phaseJump = 1+round(pp.Nphase/3);
while ~isequal(1, gcd(phaseJump,pp.Nphase)), phaseJump = phaseJump+1; end
startPhase = 2*pi*(0:pp.Nphase-1)*phaseJump/pp.Nphase; % in radians
startPhase = rem(startPhase,2*pi);
Nsam = Nrise + Nsteady + Nrem + Nfall;
for ichan = Chans,
   for iphase=1:pp.Nphase,
      waveform = maxmagDA*sin(startPhase(iphase) + (1:Nsam).'*RPS);
      waveform(1:Nrise) =  waveform(1:Nrise).*riseWin;
      waveform(Nsam+1-Nfall:Nsam) =  waveform(Nsam+1-Nfall:Nsam).*fallWin;
      WF{ichan}(:,iphase) = waveform;
   end
end

DAchan = pp.active;
PS = collectInStruct(WF, Fsam, iFilt, Nburst, NrepSil, ...
   Nrise, Nsteady, NrepSteady, Nrem, Nfall, ...
   maxSPL, DAchan, phaseJump, startPhase);
PSbuffer = PS;

% store in cache to speed up stimulus generation of frequently used stuff
ToCacheFile(CacheFilename, 10, pp, PS);


%---------------------------
function pp = localStrip(pp);
% strip non-critical params from struct, not by removing them,
% but by assigning to them nonsense values. In this way,
% errors will result if the non-critical params are ever used -
% indicating that they were critical after all.
noncrit = {'reps', 'order', 'SPL'};
for ii=1:length(noncrit),
   eval(['pp.' noncrit{ii} ' = inf;'])
end


