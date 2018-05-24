function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

args = {hspecs.NumOrder, ...              % Numerator Order
    hspecs.DenOrder, ...                  % Denominator Order
    [0 hspecs.Fpass hspecs.Fstop 1], ...  % Frequency Points
    [0 hspecs.Fpass hspecs.Fstop 1], ...  % Edges
    [1 1 0 0], ...                        % Amplitude
    [this.Wpass this.Wstop], ...          % Weights
    };

% [EOF]
