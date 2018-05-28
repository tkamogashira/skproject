function N = NfiltInsetup;
% NFILTINSETUP - # # of analog filters, i.e., # sample freqs defined
global SGSR
N = length(SGSR.samFreqs);