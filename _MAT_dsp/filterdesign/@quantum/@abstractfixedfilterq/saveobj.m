function s = saveobj(this)
%SAVEOBJ   Save the object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

s         = get(this);
s.class   = class(this);
s.version = get(this, 'version');
s.ncoeffs = get(this, 'ncoeffs');
s.nphases = get(this, 'nphases');
s.maxprod = get(this, 'maxprod');
s.maxsum  = get(this, 'maxsum');

% [EOF]
