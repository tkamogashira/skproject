function R = setratechangefactor(Hm,R)
%SETRATE Overloaded set for the RateChangeFactor property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Call super method
R = supersetratechangefactor(Hm,R); % R returned as empty ("phantom")

Ractual = Hm.RateChangeFactors; % Should always be relatively prime

Rmin = min(Ractual);
Rmax = max(Ractual);


[g,a,b] = gcd(Rmin,Rmax);


while a>0  % This should happen in at most one step.
  a = a-Rmax;  
  b = b+Rmin;
end

% lo and mo are constructed such that -lo*Li + mo*Mi = 1
lo = abs(a);  % a must now be negative or zero, as desired
mo = b;       % b must now be positive 

% Set polyphase delays
Hm.PolyphaseDelays = [lo mo];

% Reset states and polyphase matrix.
reset(Hm);
resetpolym(Hm,Hm.Numerator);


