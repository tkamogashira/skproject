function g = gain(this)
%GAIN Gain of a Cascaded Integrator-Comb (CIC) decimation filter.
%   GAIN(Hm) is the gain of the first stage up to and including the last 
%   stage of a CIC decimator.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

%   [1] Hogenauer, E. B.,  "An Economical Class of Digital Filters for
%   Decimation and Interpolation", IEEE Transactions on Acoustics, Speech,
%   and Signal Processing, Vol. ASSP-29, No. 2, April 1981, pp. 155-162.

error(nargchk(1,1,nargin,'struct'));

% Equation 10b of [1]
g = (this.DecimationFactor*this.DifferentialDelay)^this.NumberOfSections;

% [EOF]
