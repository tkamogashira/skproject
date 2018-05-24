function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2011 The MathWorks, Inc.

A = [convertmagunits(hspecs.Astop, 'db', 'linear', 'stop') ...
    convertmagunits(hspecs.Apass, 'db', 'linear', 'pass')];

F = [hspecs.Fstop hspecs.Fpass];

N = firpmord(F, [0 1], A);

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

hspecs.FrequencyFactor = this.SincFrequencyFactor;
hspecs.Power = this.SincPower;

fo = (F(2)+(F(1)-F(2))/2);
if hspecs.FrequencyFactor > 1/(1-fo)
  warning(message('dsp:fdfmethod:eqriphpminisinc:designargs:InvalidFreqFactor'));
end

switch this.StopbandShape,
    case 'flat'
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriphpminisinc:designargs:InvalidSpecifications'));
        end
        args(3) = {{@genhp, 0, hspecs.FrequencyFactor, hspecs.Power}};
    case 'linear'
        % Sloped Stopband FRESP
        args(3) = {{@genhp, this.StopbandDecay, hspecs.FrequencyFactor, hspecs.Power}};
    case '1/f'
        % 1/f Stopband FRESP
        args(3) = {{@genhp, this.StopbandDecay, hspecs.FrequencyFactor, hspecs.Power, false, true}};
end

args(4) = {A};         
args{1}{2} = max(3,args{1}{2});

% Force the min order to even if 'any' was specified to avoid convergence
% issues. If the filter order requested is odd, we need to append 'h' to
% design a hilbert transformer and avoid errors.
if strcmpi(this.MinOrder,'odd')
    args{end+1} = 'h';
end

% [EOF]
