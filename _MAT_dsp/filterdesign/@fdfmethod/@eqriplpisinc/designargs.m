function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2005-2011 The MathWorks, Inc.

args = {hspecs.FilterOrder, [0 hspecs.Fpass hspecs.Fstop 1]};
    
[freqFactor power] = getisincparams(this,hspecs);

fo = (hspecs.Fpass +(hspecs.Fstop-hspecs.Fpass)/2);
if freqFactor > 1/fo
  warning(message('dsp:fdfmethod:eqriplpisinc:designargs:InvalidFreqFactor'));
end

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriplpisinc:designargs:InvalidSpecifications'));
        end
        args(3) = {{@genlp, 0, freqFactor, power, false, false, hspecs.CICRateChangeFactor}};
    case 'linear',
        % Sloped Stopband FRESP
        args(3) = {{@genlp, this.StopbandDecay, freqFactor, power, false, false, hspecs.CICRateChangeFactor}};
    case '1/f',
        % 1/f Stopband FRESP
        args(3) = {{@genlp, this.StopbandDecay, freqFactor, power, false, true, hspecs.CICRateChangeFactor}};
end

args(4) = {[this.Wpass this.Wstop]};         % Weights

% [EOF]
