function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2011 The MathWorks, Inc.

A = [convertmagunits(hspecs.Astop, 'db', 'linear', 'stop') ...
    convertmagunits(hspecs.Apass, 'db', 'linear', 'pass')];

hspecs.FrequencyFactor = this.SincFrequencyFactor;
hspecs.Power = this.SincPower;

if hspecs.FrequencyFactor > 1/(1-hspecs.Fpass)
   warning(message('dsp:fdfmethod:eqriphpastopisinc:designargs:InvalidFreqFactor'));
end

args = {hspecs.FilterOrder, ...
    hspecs.Fpass, ...
    A, ...
    'invsinc', [hspecs.FrequencyFactor hspecs.Power], ...
    'passedge', ...
    'high'};

% [EOF]
