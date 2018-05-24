function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2005-2011 The MathWorks, Inc.

A = [convertmagunits(hspecs.Apass, 'db', 'linear', 'pass') ...
    convertmagunits(hspecs.Astop, 'db', 'linear', 'stop')];

F = [hspecs.Fpass hspecs.Fstop];

N = firpmord(F, [1 0], A);

% If minimum phase has been requested we need to make sure that we design a
% minimum even filter.
if this.MinPhase
    min = 'mineven';
    if rem(N,2)
        N = N+1;
    end
else
    min = 'minorder';
end

args = {{min, N}, [0 F 1]};

[freqFactor power] = getisincparams(this,hspecs);

fo = (F(1)+(F(2)-F(1))/2);
if freqFactor > 1/fo
  warning(message('dsp:fdfmethod:eqriplpminisinc:designargs:InvalidFreqFactor'));
end

switch this.StopbandShape,
    case 'flat',
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriplpminisinc:designargs:InvalidSpecifications'));
        end
        args(3) = {{@genlp, 0, freqFactor, power, false, false, hspecs.CICRateChangeFactor}};
    case 'linear',
        % Sloped Stopband FRESP
        args(3) = {{@genlp, this.StopbandDecay, freqFactor, power, false, false, hspecs.CICRateChangeFactor}};
    case '1/f',
        % 1/f Stopband FRESP
        args(3) = {{@genlp, this.StopbandDecay, freqFactor, power, false, true, hspecs.CICRateChangeFactor}};
end

args(4) = {A};         
args{1}{2} = max(3,args{1}{2});

% [EOF]
