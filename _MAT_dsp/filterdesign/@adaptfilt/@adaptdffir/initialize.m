function initialize(h,Coefficients,States)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
    
if nargin > 1,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end

if nargin > 2,
    set(h,'States',States);
else,
    set(h,'States',zeros(L-1,1));
end

