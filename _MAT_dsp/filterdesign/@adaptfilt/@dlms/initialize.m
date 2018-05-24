function initialize(h,errStates,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       errStates - FIR error States
%       Coefficients  - FIR coefficients
%       States    - FIR filter States


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
D = get(h,'Delay');

if nargin > 1,
    set(h,'ErrorStates',errStates);
else,
    set(h,'ErrorStates',zeros(1,D));
end

if nargin > 2,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 3,
    set(h,'States',States);
else,
    set(h,'States',zeros(1,L+D-1));
end

