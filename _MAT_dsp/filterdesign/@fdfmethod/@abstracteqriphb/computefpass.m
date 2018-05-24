function Fpass = computefpass(h,hs)
%COMPUTEFPASS   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Compute passband-edge freq
Fpass = 0.5 - hs.TransitionWidth/2;

% [EOF]
