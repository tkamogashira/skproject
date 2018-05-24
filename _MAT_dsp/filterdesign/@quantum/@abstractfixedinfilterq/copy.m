function Hcopy = copy(Hd)
%COPY   Copy this object.

%   Author(s): V. Pellissier
%   Copyright 1988-2006 The MathWorks, Inc.

% Create new object
Hcopy = feval(str2func(class(Hd)));

% Copy all the private properties that are defined at this level.
props = {'ncoeffs','nphases','InputWordLength','InputFracLength'};
for indx = 1:length(props)
    set(Hcopy, props{indx}, get(Hd, props{indx}));
end


% [EOF]
