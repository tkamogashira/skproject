function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2010-2011 The MathWorks, Inc.

% Validate specifications
[N,F,Gd,~] = validatespecs(hspecs);

if any(Gd<0),
    error(message('dsp:fdfmethod:lpnormsbarbgrpdelay:designargs:InvalidGroupDelays'));
end
E = [F(1) F(end)]; % Single band
W = this.Weights;
if isempty(W),
    W = ones(size(F));
elseif isscalar(W)
    W = W*ones(size(F));
end

args = {N, ...  % Filter Order
        F, ...  % Frequency Points
        E, ...  % Edges
        Gd, ... % Group delay
        W, ...  % Weights
        };

% [EOF]
