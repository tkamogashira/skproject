function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2005-2011 The MathWorks, Inc.

A = [convertmagunits(hspecs.Apass, 'db', 'linear', 'pass') ...
    convertmagunits(hspecs.Astop, 'db', 'linear', 'stop')];

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriplpcutoffisinc:designargs:InvalidSpecifications'));
        end
        decay = 0;
    case 'linear',
        decay = this.StopbandDecay;
end

[freqFactor power] = getisincparams(this,hspecs);

if freqFactor > 1/hspecs.Fcutoff
  warning(message('dsp:fdfmethod:eqriplpcutoffisinc:designargs:InvalidFreqFactor'));
end

invsincArgs = [freqFactor power];
if hspecs.CICRateChangeFactor == 1
  invSincType = 'invsinc';
else  
  invSincType = 'invdiric';
  % Need to multiply freqFactor times 2 to obtain the differential delay
  % since this is what firceqrip uses in its calculations.
  invsincArgs = [invsincArgs(1)*2 invsincArgs(2) hspecs.CICRateChangeFactor];
end

args = {hspecs.FilterOrder, ...
    hspecs.Fcutoff, ...
    A, ...
    'slope', decay, ...
    invSincType, invsincArgs};

% [EOF]
