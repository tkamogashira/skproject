function N = determineorder(h,hs)
%DETERMINEORDER   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

% Determine D
if hs.Astop > 21,
    D = (hs.Astop - 7.95)/(2*pi*2.285);
else
    D = 0.922;
end

N = ceil(2*D/hs.TransitionWidth);

if rem(N,2),
    N = N + 1;
end



% [EOF]
