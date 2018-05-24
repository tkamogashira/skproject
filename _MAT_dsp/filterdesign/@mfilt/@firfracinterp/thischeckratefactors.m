function thischeckratefactors(Hm,L,M)
%THISCHECKRATEFACTORS Check for valid L and M.

%   Author: V. Pellissier, R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if L < M,
    error(message('dsp:mfilt:firfracinterp:thischeckratefactors:InvalidRange'));
end
