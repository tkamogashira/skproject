function TS = toneStorage(fc, fm, fsam, Nsam, tol);
% toneStorage - compute parameters for cyclic storage of modulated tones
%  ToneStorage(fcar, fmod, Fsam, steadydur, tol), with
%     fcar : carrier freq in Hz
%     fmod:  modulation freq in Hz; zero if unmodulated
%     fsam: sample freq in Hz
%     Nsam: sample count of steady part of the (SAM) tone
%     tol: tolerance expressed as maximum cumulative phase deviation 
%          of the carrier; the modulation may deviate twice as much.
%          default tol is 0.02 (two percent).
%   ToneStorage returns a struct with the following fields
%      NsamCycBuf: number of cycles in cyclic buffer. By convention, 
%                  the cyclicic buffer contains *all* the samples if 
%                  cycclic storage is not advantageous, so NsamCycBuf=1
%                  in that case.
%      NrepCycBuf: number of reps of cyclic buffer (one if no cyc storage)
%    NsamInRemBuf: number of samples in the remainder buffer (remBuf).
%                  remBuf contains the remainder of the samples
%                  that follow the cyclic buffer. Zero if no cyc storage.
%    fcar_rounded: rounded value of carrier freq
%    fmod_rounded: rounded value of modulation freq
%          devCar: fractional deviation of carrier freq
%          devMod: fractional deviation of modulation freq
%            mess: contains a warning message if any tolerances are out of
%                  reach - usually due to very large tone duration.

if nargin<5, tol=0.02; end

Nsam = round(Nsam);
steadyDur = Nsam/fsam; % in s

% convert tolerances to relative deviations
NcycCar = fc*steadyDur;
CarTol = tol/NcycCar;
NcycMod = fm*steadyDur;
ModTol = tol/(1e-8+NcycMod); % harmless 1e-8 prevents useless divide-by-zero warning

% find rational approx of fm/fc ratio
[Pm,Qm, rdevMod] = cheapRat(fm/fc, ModTol); % see below for an interpretation of P and Q
% find rational approx of fc/Qm/fsam ratio
[Pc,Qc, rdevCar] = cheapRat(fc/Qm/fsam, CarTol);  % see below for an interpretation of P and Q
fcar_rounded = fsam*(Pc*Qm)/Qc;
fmod_rounded = fcar_rounded*Pm/Qm;
% now carrier and mod freqs are rounded, within tolerances, in such a way that ..
%   1) Qc samples contain Pc*Qm carrier cycles
%   2) Qm carrier cycles contain Pm modulation cycles
%   3) thus .. Qc samples contain Pc*Pm modulation cycles
NsamCycBuf = Qc;
NcarCycleInCycBuf = Pc*Qm;
NmodCycleInCycBuf = Pc*Pm;

% deviations as cumulative cycles
devMod = rdevMod*NcycMod;
devCar = rdevCar*NcycCar;

% evaluate how cheap cyclic storage is
NsamInRemBuf = rem(Nsam, NsamCycBuf);
Nstore = NsamCycBuf + NsamInRemBuf;
NrepCycBuf = floor(Nsam/NsamCycBuf);

% decide if cyclic storage is the way, set parameters accordingly
if Nstore>=Nsam, % do not use cyclic storage; undo roundings, etc
   fcar_rounded = fc; devCar = 0;
   fmod_rounded = fm; devMod = 0;
   % by convention, for literal storage, everything is in the cycBuf
   NsamCycBuf = Nsam;
   NrepCycBuf = 1;
   NsamInRemBuf = 0;
end

if devCar>tol, 
   mess = [{'Cumulative carrier-phase deviation' '(due to rounding of frequencies)' ['amounts ' num2sstr(devCar) ' cycles.']};]
elseif devMod>tol, 
   mess = [{'Cumulative modulation-phase deviation' '(due to rounding of frequencies)' ['amounts ' num2sstr(devMod) ' cycles.']};]
else, 
   mess = '';
end

if isdeveloper | atKiwi,
   warning(errorStr(mess));
end

TS = collectInstruct(NsamCycBuf, NrepCycBuf, NsamInRemBuf, fcar_rounded, fmod_rounded, devCar, devMod, mess);




