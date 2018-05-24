function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Copyright 2005-2010 The MathWorks, Inc.

% Validate specifications
[N,F,E,A,nfpts] = validatespecs(hspecs);

if any(A<0),
    error(message('dsp:fdfmethod:lpnormmultiband1:designargs:InvalidAmplitudes'));
end

W = get_weights(this,hspecs,nfpts);

args = {N, ...  % Numerator Order
        N, ...  % Denominator Order
        F, ...  % Frequency Points
        E, ...  % Edges
        A, ...  % Amplitude
        W, ...  % Weights
        };

% [EOF]

