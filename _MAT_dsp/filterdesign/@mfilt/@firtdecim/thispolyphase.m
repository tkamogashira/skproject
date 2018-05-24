function P = thispolyphase(Hd, obj)
%POLYPHASE Polyphase decomposition of FIR filters.
%   P=POLYPHASE(Hd) returns the polyphase matrix. The ith row P(i,:)
%   represents the ith subfilter.

%   Author: V. Pellissier
%   Copyright 2004 The MathWorks, Inc.

P = Hd.privpolym;

% [EOF]
