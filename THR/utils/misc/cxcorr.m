function [x, tau] = cxcorr(f, g, dt, flag)
% cxcorr - circular cross-correlation for periodic signals
%    x = cxcorr(f, g, dt) where f and g are length M vectors (M>1), returns
%    the length M circular cross-correlation sequence x. The lengths of 
%    f and g must be equal and are treated as a single period of periodic 
%    signals. That is x(k) = C*Sum(i=1:M) f(i).*g(k+k), where C is a
%    normalization constant (see below).
%
%    [x, tau] = cxcorr(f,g,dt) also returns the vector tau with corresponding
%    delays, using spacing dt for the time axis.
%
%    cxcorr(f, g, dt, 'none') does not use any normalization, that is, C=1.
%    cxcorr(f, g) or equivalently, cxcorr(f, g, dt, 'coeff') normalizes x
%    such that  that the auto-correlations at zero lag are identically 1.0. 
%    See the option 'coeff' in XCORR. 
%
%    NOTE: only positive delays are returned. A positive delay of 0.9 cycle
%    would thus be identical to a negative delay (=lead) of 0.1 cycle.
%
%    See also XCORR.

if nargin < 3, dt = 1; end
if nargin < 4, flag = 'coeff'; end

if length(f) ~= length(g),
    error('vectors f and g must be of equal length.');
end

FG_Real = isreal(f) && isreal(g);
F = fft(f);
G = fft(g);
X = F.*conj(G);
x = ifft(X); %cross-correlation, not yet normalized
if FG_Real, x = real(x); end % numerical noise might result in x to become complex
tau = (0:numel(f)-1)*dt; %create delay-array

if ~strcmpi(flag, 'none'),
    %normalize so that autocorrelation gives x=1 at zero delay
    cf0 = sum(abs(f).^2);
    cg0 = sum(abs(g).^2);
    x = x/sqrt(cf0*cg0);
end
