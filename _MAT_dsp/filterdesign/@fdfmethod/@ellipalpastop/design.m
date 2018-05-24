function Ha = design(h,hs)
%DESIGN   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

N = hs.FilterOrder;
wp = hs.Wpass;
rp = hs.Apass;
rs = hs.Astop;
[s,g,ws] = alpastop(h,N,wp,rp,rs);
Ha = afilt.sos(s,g);

% [EOF]
