function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

args = {hspecs.FilterOrder, ...               % Numerator Order
        hspecs.FilterOrder, ...               % Denominator Order
        [0 hspecs.Fstop hspecs.Fpass 1], ...  % Frequency Points
        [0 hspecs.Fstop hspecs.Fpass 1], ...  % Edges
        [0 0 1 1], ...                        % Amplitude
        [this.Wstop this.Wpass], ...          % Weights
        };

% [EOF]
