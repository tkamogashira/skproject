function initialize(h,L,lambda,delta,coeffs,states)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       L       - adaptive filter length (integer > 0)
%       lambda  - forgetting factor (scalar 0 << lambda < 1)
%       delta   - soft-constrained initialization factor (scalar > 0)
%       coeffs  - FIR coefficients
%       states  - FIR filter states

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1, set(h,'FilterLength',L); end
if nargin > 2, set(h,'ForgettingFactor',lambda); end
if nargin > 3, set(h,'InitFactor',delta); end

L = get(h,'FilterLength'); 

if nargin > 4,
    set(h,'Coefficients',coeffs);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 5,
    set(h,'States',states);
else,
    set(h,'States',zeros(L,1));
end

% Initialized forward and backward prediction values
init_fwdbwd(h);

