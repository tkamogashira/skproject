function args = designargs(h,hs)
%DESIGNARGS   

%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

Fpass = computefpass(h,hs);
dev = computedev(h,hs);
args = {'minorder',Fpass,dev};


% [EOF]
