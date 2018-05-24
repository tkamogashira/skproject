function init_fwdbwd(h);
%INIT_FWDBWD  Initialize forward and backward prediction properties.
%

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.


% Initialize forward and backward prediction values
L = get(h,'FilterLength');
delta = get(h,'InitFactor');
lambda = get(h,'ForgettingFactor');
FwdPrediction.Coeffs  = zeros(1,L);
FwdPrediction.Error = delta*ones(L,1);
BkwdPrediction.Coeffs = zeros(1,L-1);
BkwdPrediction.Error= delta*ones(L,1)/lambda;

set(h,'FwdPrediction',FwdPrediction);
set(h,'BkwdPrediction',BkwdPrediction);

