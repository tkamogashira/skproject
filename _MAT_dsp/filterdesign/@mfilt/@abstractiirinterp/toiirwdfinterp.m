function h = toiirwdfinterp(this)
%TOIIRWDFINTERP   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


h = mfilt.iirwdfinterp;

h.Polyphase = this.Polyphase;

% [EOF]
