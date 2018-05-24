function R = supersetratechangefactor(Hm,R)
%SETRATE Overloaded set for the RateChangeFactor property.

% This should be a private method

%   Author: R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.

if length(R)~=2,
    error(message('dsp:mfilt:abstractsrc:supersetratechangefactor:InternalError'));
end

L = R(1); M = R(2);

% Check for valid L, M
thischeckratefactors(Hm,L,M);

[g,a,b] = gcd(L,M); Li=L/g; Mi=M/g;

if (g > 1),
    cutoff = Li;
    if Mi>Li, cutoff = Mi; end  % In case we're using this for fractional decimation.
    warning(message('dsp:srconvert:primefactors', L, M, Li, Mi, cutoff));
end


Hm.privRateChangeFactor = [Li, Mi];

R = []; % Make it phantom
