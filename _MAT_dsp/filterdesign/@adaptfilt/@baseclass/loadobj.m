function this = loadobj(s)
%LOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

this = feval(s.class);

set(this, ...
    'PersistentMemory', true, ...
    'NumSamplesProcessed',  s.NumSamplesProcessed);

thisloadobj(this, s);

% If there is no 'version' field, then we must assume this is r14 and we
% need to convert ResetBeforeFiltering to PersistentMemory.
if ~isfield(s, 'version')
    s.PersistentMemory = strcmpi(s.ResetBeforeFiltering, 'off');
end

set(this, ...
    'PersistentMemory',   s.PersistentMemory, ...
    'CapturedProperties', s.CapturedProperties);

% [EOF]
