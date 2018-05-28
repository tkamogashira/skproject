function AK = prepareBNstim(pp);
% check if previous call had identical params
global AKbuffer
markBuffer AKbuffer; % mark global buffer for deletion after use

try, % if exactly same params have been isuued before, return stored AKbuffer
   if isequal(AKbuffer.pp, pp),
      AK = AKbuffer;
      return
   end; 
end

[AK.Fsam, AK.iFilt] = safeSamplefreq(pp.Fhigh); % Nyquist

needConst = ~isequal(pp.VarEar, pp.active);
needVar = ~isequal(pp.ConstEar, pp.active);
% generate the noise vectors if needed
maxMag = nan*[1 1];
if needConst,
   chan = pp.ConstEar;
   [AK.N, AK.SpConst, Wc]  = GenWhiteNoise(pp.Flow, pp.Fhigh, AK.iFilt, pp.burstDur, pp.seedC, chan, pp.delay(chan));
   maxMag(chan) = 1e-100 + max(abs(Wc));
   AK.Nspec = length(AK.SpConst);
end
if needVar,
   chan = pp.VarEar;
   [AK.N, AK.SpVlow,  Wv1] = GenWhiteNoise(pp.Flow, pp.Fhigh, AK.iFilt, pp.burstDur, pp.seedVlow, chan, pp.delay(chan));
   [AK.N, AK.SpVhigh, Wv2] = GenWhiteNoise(pp.Flow, pp.Fhigh, AK.iFilt, pp.burstDur, pp.seedVhigh, chan, pp.delay(chan));
   maxMag(chan) = 1e-100 + max(abs(Wv1)+abs(Wv2));
   AK.Nspec = length(AK.SpVlow);
end

% upper limit for sample magnitudes
AK.maxSPL = a2db(maxMagDA./maxMag);

AK.pp = pp;
AKbuffer = AK; % store globally to save time upon next, ...
%               ... possibly identical, call








