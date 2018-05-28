function TTS = prepareTTSstim(pp, force);
% prepareTTSstim - prepare TST stim and put it in cache

if nargin<2, force=0; end;

% check if previous call had identical params
global TTSbuffer
markBuffer TTSbuffer; % mark global buffer for deletion after use

try, % if exactly same params have been isuued before, return stored BNbuffer
   if ~force & isequal(TTSbuffer.pp, pp),
      TTS = TTSbuffer;
      return
   end; 
end
TTS.mess = '';
TTS.pp = pp;
%--------------------------------------
% contextual stimulus parameters
[Fsam, ifilt] = safesamplefreq(max(pp.probefreq, pp.suppfreq));
global SGSR
ERCfile = ercfile;
TTS.Context = CollectInStruct(SGSR, Fsam, ifilt, ERCfile);
% derived params
NsamTot = round(pp.burstDur*1e-3*Fsam);
NsamRise = round(pp.riseDur*1e-3*Fsam);
NsamFall = round(pp.fallDur*1e-3*Fsam);
RadPerSamProbe = 2*pi*pp.probefreq/Fsam; % angular probe freq in rad/sample
RadPerSamSupp = 2*pi*pp.suppfreq/Fsam; % angular supp freq in rad/sample
suppSPL = sweepchecker(pp.startSPL, pp.stepSPL, pp.endSPL, pp.active);
NSPL = size(suppSPL,1);

sr = 1:NsamTot; % sample indices of total dur
srRise = 1:NsamRise; % idem rise portion
srFall = NsamTot-NsamFall+1:NsamTot; % idem fall portion
RiseWin = sin(linspace(0,pi/2,NsamRise)).^2;
FallWin = cos(linspace(0,pi/2,NsamFall)).^2;
% calibration amplitudes and phase
[calAmpProbe(1), calPhaseProbe(1)] = calibrate(pp.probefreq,ifilt,'L');
[calAmpProbe(2), calPhaseProbe(2)] = calibrate(pp.probefreq,ifilt,'R');
[calAmpSupp(1), calPhaseSupp(1)] = calibrate(pp.suppfreq,ifilt,'L');
[calAmpSupp(2), calPhaseSupp(2)] = calibrate(pp.suppfreq,ifilt,'R');
AllChans = pp.active;
if pp.active==0, AllChans = [1 2]; end
for isub=1:NSPL,
   for ichan=AllChans,
      AmpProbe = db2a(3+pp.probeSPL+calAmpProbe(ichan));
      AmpSupp = db2a(3+suppSPL(isub,ichan)+calAmpSupp(ichan));
      PhaseProbe = 2*pi*calPhaseProbe(ichan); % probe phase correction in cycles
      PhaseSupp = 2*pi*calPhaseSupp(ichan); % idem suppressor
      AmpMargin(isub,ichan) = MaxMagDA./(AmpProbe+AmpSupp);
      TTS.maxSPL(isub,ichan) = suppSPL(isub,ichan)+ a2db(AmpMargin(isub, ichan));
      TTS.WV{isub,ichan} = ...
         AmpMargin(isub,ichan)*(...
         AmpProbe*sin(sr*RadPerSamProbe+PhaseProbe) ...% sin vs cos phase -> power adds.. 
         + AmpSupp*cos(sr*RadPerSamSupp+PhaseSupp)... %...when probe & supp freqs coincide
         );
      TTS.WV{isub,ichan}(srRise) = RiseWin.*TTS.WV{isub,ichan}(srRise);
      TTS.WV{isub,ichan}(srFall) = FallWin.*TTS.WV{isub,ichan}(srFall);
   end
end
TTS.suppSPL = suppSPL;







%----------------------------
TTSbuffer = TTS; % store globally to save time upon next call with identical params






