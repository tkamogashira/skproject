function settings = getsettings(this)
%GETSETTINGS   Returns the values.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

settings.wordlength  = evaluatevars(this.WordLength, ...
    sprintf('%s word length', this.Name));

if strcmpi(this.AutoScaleAvailable, 'On')
    settings.autoscale = get(this, 'AutoScale');
else
    settings.autoscale = 'off';
end

sw = get(this, 'SpecifyWhich');

for indx = 1:length(sw)
    if strcmpi(sw{indx}, 'length')
        if indx > length(this.FracLabels)
            name = '';
        else
            name = sprintf('%s fraction length', this.FracLabels{indx});
        end
        settings.fraclengths{indx} = evaluatevars(this.FracLengths{indx}, name);
    else
        if indx > length(this.FracLabels)
            name = '';
        else
            name = sprintf('%s range', this.FracLabels{indx});
        end
        settings.fraclengths{indx} = ...
            settings.wordlength-ceil(log2(evaluatevars(this.Ranges{indx}, name)))-1;
    end
end

% [EOF]
