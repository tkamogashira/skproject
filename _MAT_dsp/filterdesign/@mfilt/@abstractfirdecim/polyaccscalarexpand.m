function S = polyaccscalarexpand(Hm,S)
%POLYACCSCALAREXPAND Expand empty or scalar PolyphaseAccum to a vector.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1988-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if ~isnumeric(S)
  error(message('dsp:mfilt:abstractfirdecim:polyaccscalarexpand:MustBeNumeric'));
end
if issparse(S),
    error(message('dsp:mfilt:abstractfirdecim:polyaccscalarexpand:Sparse'));
end

nacc = thispolyaccscalarexpand(Hm);

if isempty(S),
    S=0;
end

if length(S)==1,
    S = repmat(S,nacc,1);
end

% At this point we must have a vector or matrix with the right number of
% rows
if size(S,1) ~= nacc,
    error(message('dsp:polyaccscalarexpand:invalidDimension', nacc));
end
