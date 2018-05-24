function args = designargs(this, hspecs)
%DESIGNARGS   Return the arguments for the design method.

%   Copyright 2005-2010 The MathWorks, Inc.

% Validate specifications
[Nb,Na,F,E,A,nfpts] = validatespecs(hspecs);

if any(A<0),
    error(message('dsp:fdfmethod:lpnormmultiband2:designargs:InvalidAmplitudes'));
end

W = get_weights(this,hspecs,nfpts);

args = {Nb, ...  % Numerator Order
        Na, ...  % Denominator Order
        F, ...   % Frequency Points
        E, ...   % Edges
        A, ...   % Amplitude
        W, ...   % Weights
        };

% [EOF]

