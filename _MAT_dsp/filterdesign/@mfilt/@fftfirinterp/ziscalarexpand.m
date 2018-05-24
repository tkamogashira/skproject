function S = ziscalarexpand(Hm,S)
%ZISCALAREXPAND Expand empty or scalar initial conditions to a vector.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if ~isa(S,'numeric')
  error(message('dsp:mfilt:fftfirinterp:ziscalarexpand:MustBeNumeric'));
end
if ~isa(S, 'double'),
    error(message('dsp:mfilt:fftfirinterp:ziscalarexpand:MFILTErr'));
end
if issparse(S),
    error(message('dsp:mfilt:fftfirinterp:ziscalarexpand:Sparse'));
end

numstates = nstates(Hm);
if isempty(S),
    S=0;
end
M = polyorder(Hm);
if length(S)==1,
	% Zi expanded to a matrix with number of rows equal to the polyphase
	% filters order
	L = Hm.InterpolationFactor;
	S = S*ones(M,L);
end

% At this point we must have a matrix with the right number of rows
if size(S,1) ~= M,
	error(message('dsp:mfilt:fftfirinterp:ziscalarexpand:invalidStates', M, L));
end

