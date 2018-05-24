function g = gain(h,J)
%GAIN Gain of a Cascaded Integrator-Comb (CIC) interpolation filter.
%   GAIN(Hm,J) is the gain of the Jth stage of a CIC interpolator. If empty 
%   or omitted, J is assumed to be 2*N, i.e., the gain of the last stage of
%   the filter.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

%   [1] Hogenauer, E. B.,  "An Economical Class of Digital Filters for
%   Decimation and Interpolation", IEEE Transactions on Acoustics, Speech,
%   and Signal Processing, Vol. ASSP-29, No. 2, April 1981, pp. 155-162.

error(nargchk(1,2,nargin,'struct'));

[R,M,N] = params(h);
if nargin < 2, J = 2*N; end

% Equation 22 of [1]
if J <= N,
    g = 2^J;
else
    g = (2.^(2*N-J).*(R*M).^(J-N))/R;
end

% [EOF]
