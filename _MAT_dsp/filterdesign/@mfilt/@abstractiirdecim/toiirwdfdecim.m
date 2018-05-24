function h = toiirwdfdecim(this)
%TOIIRWDFDECIM   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


h = mfilt.iirwdfdecim;

h.Polyphase = this.Polyphase;

% [EOF]
