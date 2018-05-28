function E = freq2erb(f);
% Freq2ERB - converts frequency in Hz to ERBscale
Q = (f+312)./(f+14675);
E = 43+11.17*log(Q)


