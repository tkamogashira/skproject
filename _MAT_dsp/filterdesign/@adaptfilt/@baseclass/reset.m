function reset(h)
%RESET Reset the state of the adaptive filter.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rbf = get(h, 'PersistentMemory');

% Avoid warnings
set(h, 'PersistentMemory', true)

% Reset the captured properties.
set(h, get(h, 'CapturedProperties'));

% Call THISRESET to allow subclasses to perform extra work.
thisreset(h);

% Reset the flag
set(h, 'PersistentMemory', rbf)

% [EOF]
