function Ha = design(h,hs)
%DESIGN   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

N = hs.FilterOrder;
wp = hs.Wpass;
ws = hs.Wstop;
rp = hs.Apass;
[s,g] = alpfstop(h,N,wp,ws,rp);
Ha = afilt.sos(s,g);

% [EOF]
