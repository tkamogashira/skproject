function dB=P2dB(p);
% P2dB - convert power ratio do dB
%    P2dB(X) is the dB value corresponding to power ratio X, which is 10*log10(X)

if any(p<0), warning('Negative power encountered.'); end
dB=10.*log10(p);



