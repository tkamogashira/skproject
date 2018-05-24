function initialize(h,L,lambda,delta,gamma,gStates,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       L          - adaptive filter length (integer > 0)
%       lambda     - forgetting factor (scalar 0 << lambda < 1)
%       delta      - soft-constrained initialization factor (scalar > 0)
%       gamma      - conversion factor (scalar 0 <= gamma <= 1)
%       gStates    - States of Kalman gain updates (L,1)
%       Coefficients     - initial value of the adaptive filter coefficients
%                    (1,L)
%       States     - adaptive filter States (L-1,1)

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1, set(h,'FilterLength',L); end
if nargin > 2, set(h,'ForgettingFactor',lambda); end
if nargin > 3, set(h,'InitFactor',delta); end
if nargin > 4,
    set(h,'ConversionFactor',gamma);
else
    set(h,'ConversionFactor',1);
end

L = get(h,'FilterLength'); 

if nargin > 5,
    set(h,'KalmanGainStates',gStates);
else,
    set(h,'KalmanGainStates',zeros(L,1));
end

if nargin > 6,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 7,
    set(h,'States',States);
else,
    set(h,'States',zeros(L-1,1));   
end

% Initialize Kalman gain
set(h,'KalmanGain',zeros(L,1));

% Initialized forward and backward prediction values
delta = get(h,'InitFactor');
lambda = get(h,'ForgettingFactor');
fwd.Coeffs  = zeros(1,L);
fwd.Error = lambda^(L)*delta;
bwd.Coeffs  = zeros(1,L);
bwd.Error = delta;

set(h,'FwdPrediction',fwd);
set(h,'BkwdPrediction',bwd);


