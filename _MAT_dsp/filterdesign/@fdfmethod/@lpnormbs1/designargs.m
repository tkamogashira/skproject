function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

args = {hspecs.FilterOrder, ...                   % Numerator Order
        hspecs.FilterOrder, ...                   % Denominator Order
        [0 hspecs.Fpass1 hspecs.Fstop1 hspecs.Fstop2 hspecs.Fpass2 1], ...  % Frequency Points
        [0 hspecs.Fpass1 hspecs.Fstop1 hspecs.Fstop2 hspecs.Fpass2 1], ...  % Edges
        [1 1 0 0 1 1], ...                        % Amplitude
        [this.Wpass1 this.Wstop this.Wpass2], ... % Weights
        };

% [EOF]
