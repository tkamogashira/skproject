function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2005-2011 The MathWorks, Inc.

Nb = hspecs.NumOrder;
Na = hspecs.DenOrder;
F = hspecs.Frequencies;
A = hspecs.Amplitudes;
if any(A<0),
    error(message('dsp:fdfmethod:lpnormsbarbmag2:designargs:InvalidAmplitudes'));
end
E = [F(1) F(end)]; % Single band
W = this.Weights;
if isempty(W),
    W = ones(size(F));
elseif isscalar(W)
    W = W*ones(size(F));
end

args = {Nb, ...  % Numerator Order
        Na, ...  % Denominator Order
        F, ...  % Frequency Points
        E, ...  % Edges
        A, ...  % Amplitude
        W, ...  % Weights
        };

% [EOF]
