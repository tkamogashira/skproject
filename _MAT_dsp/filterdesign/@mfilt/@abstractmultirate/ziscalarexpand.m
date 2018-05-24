function S = ziscalarexpand(Hd,S)
%ZISCALAREXPAND Expand empty or scalar initial conditions to a vector.

% This should be a private method

%   Author: V. Pellissier
%   Copyright 1988-2011 The MathWorks, Inc.

error(nargchk(2,2,nargin,'struct'));

if ~isnumeric(S)
  error(message('dsp:mfilt:abstractmultirate:ziscalarexpand:MustBeNumeric'));
end
if issparse(S),
    error(message('dsp:mfilt:abstractmultirate:ziscalarexpand:Sparse'));
end

numstates = nstates(Hd);

if numstates,
    if isempty(S),
        S = nullstate1(Hd.filterquantizer);
    end
    if length(S)==1,
        % Zi expanded to a vector of length equal to the number of states
        S = S(ones(numstates,1));
    end
    
    % Transpose if row vector only and if the # of rows does not match
    % NSTATES.  This is done for multichannel support.
    if nstates(Hd) ~= size(S, 1) && find(size(S)==1),
        S = S(:);
    end
    
    % At this point we must have a vector or matrix with the right number
    % of rows.
    if size(S,1) ~= numstates,
        error(message('dsp:mfilt:abstractmultirate:ziscalarexpand:invalidStates', numstates));
    end
elseif ~isempty(S),
    
    % This handles the case where one of the dimensions is zero.
    error(message('dsp:mfilt:abstractmultirate:ziscalarexpand:MFILTErr'));
end
