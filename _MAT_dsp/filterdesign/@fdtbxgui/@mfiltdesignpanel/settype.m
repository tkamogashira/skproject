function type = settype(this, type)
%SETTYPE   PreSet function for the 'type' property.

%   Author(s): J. Schickler
%   Copyright 1999-2003 The MathWorks, Inc.

set(this, 'privType', type, 'isDesigned', false);

hs = getcomponent(this, 'tag', 'implementation');

if ~isempty(hs)
    switch lower(type)
        case 'fractional-rate converter'
            disableselection(hs, 'cic', 'hold', 'linear');
        case 'decimator'
            enableselection(hs, 'cic');
            disableselection(hs, 'hold', 'linear');
        case 'interpolator'
            enableselection(hs, 'cic', 'hold', 'linear');
    end
end

updatespinners(this);

% [EOF]
