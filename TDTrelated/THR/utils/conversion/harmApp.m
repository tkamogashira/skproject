function h = harmApp(s,n);
% HARMAPP - approximate cyclic signal by first N harmonics
%    Harmapp(S,N), where array S contains tone period of a periodic signal,
%    returns S approximated by it first N harmonics. N==0 is the DC, etc.
%  
%    See also FFT.

if nargin<2, n=1; end;
IR = isreal(s);
N = length(s);
h = fft(s);
h(n+2:N-n) = 0;
h = ifft(h);
if IR, h=real(h); end;