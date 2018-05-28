function h = harmApp(s,n);
% HARMAPP - approximate cyclic signal by first N harmonics
if nargin<2, n=1; end;
IR = isreal(s);
N = length(s);
h = fft(s);
h(n+2:N-n) = 0;
h = ifft(h);
if IR, h=real(h); end;