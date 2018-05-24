function h = toiirdecim(this)
%TOIIRDECIM   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.


h = mfilt.iirdecim;

h.Polyphase = this.Polyphase;

% [EOF]
