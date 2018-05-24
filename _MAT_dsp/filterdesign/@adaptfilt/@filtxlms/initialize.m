function initialize(h,fstates,pstates,coeffs,states)
%INITIALIZE  Initialize properties to correct dimension.
%
%   Inputs:
%       fstates - filtered input states
%       pstates - secondary path filter states
%       coeffs  - FIR coefficients
%       states  - FIR filter states

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
Nest = get(h,'pathestord');
Npath = get(h,'pathord');

if nargin > 1,
    set(h,'FilteredInputStates',fstates);
else,
    set(h,'FilteredInputStates',zeros(1,L-1));
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
    set(h,'States',zeros(1,max(L-1,Nest)));
end

