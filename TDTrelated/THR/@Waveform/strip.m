function W = maxSPL(W);
% Waveform/strip - strip samples from waveform object
%   Waveform(W) replaces the W.Samples field with {}, so that W can be used
%   for bookeeping without much memory load.

[W.Samples] = deal({});