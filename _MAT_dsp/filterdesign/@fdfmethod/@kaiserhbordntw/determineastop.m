function Astop = determineastop(h,hs)
%DETERMINEASTOP   

%   Author(s): R. Losada
%   Copyright 2003-2004 The MathWorks, Inc.

% Compute "D" factor
D = hs.FilterOrder*hs.TransitionWidth/2;

Astop = 2*pi*2.285*D + 7.95;
if Astop <= 21,
    warning(message('dsp:fdfmethod:kaiserhbordntw:determineastop:InvalidOrder'));
end

% [EOF]
