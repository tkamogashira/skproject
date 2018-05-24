function s = saveobj(this)
%SAVEOBJ   Save the object.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

s         = get(this);
s.class   = class(this);
s.ncoeffs = get(this, 'ncoeffs');
s.nphases = get(this, 'nphases');

% [EOF]
