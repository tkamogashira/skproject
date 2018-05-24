function zi = ziexpand(Hm,x,zi)
%ZIEXPAND Expand initial conditions for multiple channels when necessary
%   ZI = ZIEXPAND(Hm, X, ZI) 
%
%   This function is intended to only be used by SUPER_FILTER to expand initial
%   conditions. 
%
%   This should be a private method.   

%   Author: R. Losada
%   Copyright 1999-2011 The MathWorks, Inc.


error(nargchk(3,3,nargin,'struct'));

[m,ndata] = size(x);
ndata = max(ndata,1);

L = Hm.InterpolationFactor;

if size(zi,2) ~= ndata*L && size(zi,2) ~= L,
	error(message('dsp:mfilt:fftfirinterp:ziexpand:invalidChannels'));
end

if size(zi,2) == L,
	zi = repmat(zi,1,ndata);
end

