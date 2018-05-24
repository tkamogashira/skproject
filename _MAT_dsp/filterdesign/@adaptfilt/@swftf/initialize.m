function initialize(h,L,delta,N,gamma,gStates,dStates,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%     L         - adaptive filter length (integer > 0)
%     delta     - soft-constrained initialization factor (scalar > 0)
%     N         - block length (integer > L-1)
%     gamma     - conversion factor (1,2)
%     gStates   - States of Kalman gain updates (N+L-1,1)
%     dStates   - desired signal States (N-1,1)
%     Coefficients    - initial value of the adaptive filter coefficients (1,L)
%     States    - adaptive filter States (N+L-2,1)

%   Author(s): R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

if nargin > 1, set(h,'FilterLength',L); end
if nargin > 2, set(h,'InitFactor',delta); end

L = get(h,'FilterLength'); 

if nargin > 3,
    set(h,'BlockLength',N);
else
    set(h,'BlockLength',L);
end

if nargin > 4,
	if length(gamma) ~= 2 ,
		error(message('dsp:adaptfilt:swftf:initialize:InvalidDimensions'));
	elseif (gamma(1) <= 0) | (gamma(1) > 1) | (gamma(2) > -1) 
        error(message('dsp:adaptfilt:swftf:initialize:InvalidRange'));
    end
    set(h,'ConversionFactor',gamma);
else
    set(h,'ConversionFactor',[1 -1]);
end

N = get(h,'BlockLength');

if nargin > 5,
    set(h,'KalmanGainStates',gStates);
else,
    set(h,'KalmanGainStates',zeros(N+L-1,1));
end

if nargin > 6,
    set(h,'DesiredSignalStates',dStates);
else,
    set(h,'DesiredSignalStates',zeros(N-1,1));
end

if nargin > 7,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 8,
    set(h,'States',States);
else,
    set(h,'States',zeros(N+L-2,1));   
end

% Initialize Kalman gain
set(h,'KalmanGain',zeros(L,2));

% Initialized forward and backward prediction values
delta = get(h,'InitFactor');
fwd.Coeffs = zeros(1,L);
fwd.Error  = delta;
bwd.Coeffs = zeros(1,L);
bwd.Error  = delta;

set(h,'FwdPrediction',fwd);
set(h,'BkwdPrediction',bwd);


