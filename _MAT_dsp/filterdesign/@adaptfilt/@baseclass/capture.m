function capture(h)
%CAPTURE Capture the state of the object.

%   Author(s): J. Schickler
%   Copyright 1999-2002 The MathWorks, Inc.

% Get all the properties and find the ones with descriptions.
p = find(get(classhandle(h), 'Properties'), 'Description', 'capture');

for indx = 1:length(p),
    name = get(p(indx), 'Name');
    c.(name) = get(h, name);
end

set(h, 'CapturedProperties', c);

thiscapture(h);

% [EOF]
