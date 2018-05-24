function [y,e] = filter(this,x,d)
%FILTER  Adaptive filter.
%   Y = FILTER(H,X,D) applies an adaptive filter H to the input
%   signal in  the vector X and the desired signal in the vector D.
%   The estimate of the desired response signal is returned in Y.
%   X and D must be of the same length.
%
%   [Y,E]   = FILTER(H,X,D) also returns the prediction error E.

%   Author(s): S.C. Douglas
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(3,3,nargin,'struct'));

pm = get(this, 'PersistentMemory');

if ~pm,
    reset(this);
end

set(this, 'PersistentMemory', true);

[y,e] = thisfilter(this,x,d);

set(this, 'PersistentMemory', pm);

%  END OF PROGRAM
