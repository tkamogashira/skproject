function initialize(h,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       Coefficients - FIR coefficients
%       States       - FIR filter States


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
N = get(h,'SwBlockLength');

if nargin > 1,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 2,
    set(h,'States',States);
else,
    set(h,'States',zeros(1,L+N-2));
end

