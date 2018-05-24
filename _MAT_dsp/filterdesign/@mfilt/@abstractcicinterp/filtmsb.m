function Bmax = filtmsb(Hm)
%FILTMSB Most significant bit of a CIC interpolation filter.
%   FILTMSB(Hm) is the most significant bit (MSB) of the filter output and 
%   is a function of the parameters, R, M, N and the InputBitWidth.  Since the 
%   output of the integrators can grow without bound, this MSB represents the 
%   maximum number of bits, which can be propagated through the filter without 
%   loss of data. This MSB is not only the MSB at the filter output; it is also 
%   the MSB for all stages.  
%
%   See also MFILT, MFILT/GAIN

%   Author: P. Costa
%   Copyright 1999-2005 The MathWorks, Inc.

%   [1] Hogenauer, E. B.,  "An Economical Class of Digital Filters for
%   Decimation and Interpolation", IEEE Transactions on Acoustics, Speech,
%   and Signal Processing, Vol. ASSP-29, No. 2, April 1981, pp. 155-162.

error(message('dsp:mfilt:abstractcicinterp:filtmsb:Obsolete'));

% [EOF]
