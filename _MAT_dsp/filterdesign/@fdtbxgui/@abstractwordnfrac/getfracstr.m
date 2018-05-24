function fracstr = getfracstr(this)
%GETFRACSTR   Returns the string to use for the 'fraction'.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

if strcmpi(this.Abbreviate, 'on'),
    fracstr = 'frac.';
else
    fracstr = 'fraction';
end

% [EOF]
