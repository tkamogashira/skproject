function args = designargs(this, hspecs)
%DESIGNARGS Return the arguments for the design method.

%   Copyright 2010 The MathWorks, Inc.

% Validate specifications
[N,F,E,Gd,nfpts] = validatespecs(hspecs);

if any(Gd<0),
    error(message('dsp:fdfmethod:lpnormmultibandarbgrpdelay:designargs:InvalidGroupDelays'));
end

W = get_weights(this,hspecs,nfpts);

args = {N, ...  % Filter Order        
        F, ...  % Frequency Points
        E, ...  % Edges
        Gd, ... % Group Delay Points
        W, ...  % Weights
        };

% [EOF]

