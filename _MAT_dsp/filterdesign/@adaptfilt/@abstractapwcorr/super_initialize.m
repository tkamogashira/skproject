function super_initialize(h,Offset,Coefficients,States,corrCoefficients,errStates,epsStates)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
po = get(h,'ProjectionOrder');

if nargin > 1,
    initoffset(h,Offset);
else
    initoffset(h);
end

if nargin > 2,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 3,
    set(h,'States',States);
else,
    set(h,'States',zeros(L+po-2,1));
end

if nargin > 4,
    set(h,'CorrelationCoeffs',corrCoefficients);
else,
    set(h,'CorrelationCoeffs',zeros(po-1,1));
end

if nargin > 5,
    set(h,'ErrorStates',errStates);
else,
    set(h,'ErrorStates',zeros(po-1,1));
end

if nargin > 6,
    set(h,'EpsilonStates',epsStates);
else,
    set(h,'EpsilonStates',zeros(po-1,1));
end

