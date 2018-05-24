function h = toiirinterp(this)
%TOIIRINTERP   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

h = mfilt.iirinterp;

h.Polyphase = this.Polyphase;

% [EOF]
