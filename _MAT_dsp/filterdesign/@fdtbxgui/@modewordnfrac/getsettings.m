function settings = getsettings(this)
%GETSETTINGS   Returns the values.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

settings.mode        = map(this.Mode);
settings.wordlength  = evaluatevars(this.WordLength, ...
    sprintf('%s word length', this.Name));
settings.fraclengths = evaluatevars(this.FracLengths, lclgetfraclabels(this));

% -------------------------------------------------------------------------
function fl = lclgetfraclabels(this)

fl = get(this, 'FracLabels');

for indx = 1:length(fl)
    fl{indx} = sprintf('%s fraction length', fl{indx});
end

% -------------------------------------------------------------------------
function m = map(m)

if strcmpi(m, 'Specify All'),
    m = 'specifyprecision';
else
    m = strrep(m, ' ', '');
end

% [EOF]
