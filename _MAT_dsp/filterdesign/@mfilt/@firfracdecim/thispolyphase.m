function P = thispolyphase(Hm, obj)
%POLYPHASE Polyphase decomposition of FIR filters.
%   P=POLYPHASE(Hm) returns the polyphase matrix P with L*M rows which is
%   the result of two levels of decomposition.  The first M rows of P are
%   the subfilters derived from the first polyphase filter (issued form
%   the first level of decomposition).

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

R = Hm.RateChangeFactor;
L = R(1); M = R(2);
N = Hm.Numerator;
P = firpolyphase(N,L,M);


% [EOF]
