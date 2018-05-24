function initialize(h,errstates,pstates,coeffs,states)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       errstates - FIR error states
%       pstates   - secondary path filter states
%       coeffs    - FIR coefficients
%       states    - FIR filter states

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
Nest = get(h,'pathestord');
Npath = get(h,'pathord');

if nargin > 1,
    set(h,'ErrorStates',errstates);
else,
    set(h,'ErrorStates',zeros(1,Nest));
end

if nargin > 2,
    set(h,'SecondaryPathStates',pstates);
else,
    set(h,'SecondaryPathStates',zeros(1,Npath));
end

if nargin > 3,
    set(h,'Coefficients',coeffs);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 4,
    set(h,'States',states);
else,
    set(h,'States',zeros(1,L+Nest-1));
end

