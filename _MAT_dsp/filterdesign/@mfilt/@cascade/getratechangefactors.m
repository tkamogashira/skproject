function rcf = getratechangefactors(this)
%GETRATECHANGEFACTORS   Get the ratechangefactors.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

rcf = [];

for indx = 1:length(this.Stage)
    rcf = [rcf; getratechangefactors(this.Stage(indx))];
end

% [EOF]
