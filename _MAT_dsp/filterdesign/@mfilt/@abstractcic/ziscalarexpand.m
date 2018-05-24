function S = ziscalarexpand(Hm,S)
%ZISCALAREXPAND Expand empty or scalar initial conditions to a matrix.

% This should be a private method

%   Author: P. Costa
%   Copyright 1999-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

% When S == [] we are in a "reset" condition.
if isempty(S),
    S=int32(0);
end

% Need to cast 0 (set by @dfilt\@abstractfilter\reset.m or by the user) to int32
if isequal(S,0) && ~isa(S,'int32')
    S = int32(S);
end

M = get(Hm,'DifferentialDelay');
N = get(Hm,'NumberOfSections');

if isnumeric(S)
    if issparse(S),
        error(message('dsp:mfilt:abstractcic:ziscalarexpand:Sparse'));
    end

    if length(S)==1,
        % Zi expanded to a matrix
        S = int32(double(S)*ones((M+1),N));
    end

    % At this point we must have a matrix with the right number of rows. This
    % message states "per channel" for the case when filtering multichannel
    % data, we must have a matrix of states, per channel.
    if size(S,1) ~= M+1,
        error(message('dsp:mfilt:abstractcic:ziscalarexpand:wrongSize4CICstates', M + 1, N));
    end
elseif isa(S, 'filtstates.cic')
    
    % Use the validate method on the CIC state object to check if there are
    % the correct number of integrator and comb states.
    validate(S, N, M);
else
    error(message('dsp:mfilt:abstractcic:ziscalarexpand:MFILTErr'));
end

% [EOF]
