function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2011 The MathWorks, Inc.

args = {hspecs.FilterOrder, [0 hspecs.Fstop hspecs.Fpass 1]};
    
hspecs.FrequencyFactor = this.SincFrequencyFactor;
hspecs.Power = this.SincPower;

fo = (hspecs.Fstop +(hspecs.Fpass-hspecs.Fstop)/2);
if hspecs.FrequencyFactor > 1/(1-fo)
  warning(message('dsp:fdfmethod:eqriphpisinc:designargs:InvalidFreqFactor'));
end

switch this.StopbandShape,
    case 'flat'
        if this.StopbandDecay~=0,
            warning(message('dsp:fdfmethod:eqriphpisinc:designargs:InvalidSpecifications'));
        end
        args(3) = {{@genhp, 0, hspecs.FrequencyFactor, hspecs.Power}};
    case 'linear'
        % Sloped Stopband FRESP
        args(3) = {{@genhp, this.StopbandDecay, hspecs.FrequencyFactor, hspecs.Power}};
    case '1/f'
        % 1/f Stopband FRESP
        args(3) = {{@genhp, this.StopbandDecay, hspecs.FrequencyFactor, hspecs.Power, false, true}};
end

args(4) = {[this.Wstop this.Wpass]};         % Weights

% If the filter order requested is odd, we need to append 'h' to design a
% hilbert transformer and avoid erroring.
if rem(hspecs.FilterOrder, 2) == 1
    args{end+1} = 'h';
end
% [EOF]
