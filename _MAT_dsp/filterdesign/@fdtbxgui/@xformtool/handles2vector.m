function h = handles2vector(this)
%HANDLES2VECTOR Return the HG handles in a single vector.

%   Copyright 2006 The MathWorks, Inc.

h = get(this, 'Handles');
if isempty(h), return; end
h = rmfield(h, {'playout', 'clayout'});

h = convert2vector(h);

% [EOF]
