function settings = getsettings(this)
%GETSETTINGS   Returns the values.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

settings.wordlength  = evaluatevars(this.WordLength, ...
    sprintf('%s word length', this.Name));
settings.autoscale   = this.AutoScale;
settings.fraclengths = evaluatevars(this.FracLengths, lclgetfraclabels(this));
settings.wordlength2 = evaluatevars(this.WordLength2, ...
    sprintf('%s word length', this.WordLabel2));

% -------------------------------------------------------------------------
function fl = lclgetfraclabels(this)

fl = get(this, 'FracLabels');

for indx = 1:length(fl)
    fl{indx} = sprintf('%s fraction length', fl{indx});
end

% [EOF]
