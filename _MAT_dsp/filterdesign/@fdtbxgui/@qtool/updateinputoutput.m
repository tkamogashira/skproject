function updateinputoutput(this)
%UPDATEINPUTOUTPUT   Update the input and output components.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% If the filter is a CIC we need to update the INPUT and OUTPUT components.
if isa(this.filter, 'mfilt.abstractcic')
    if strcmpi(this.FilterInternals, 'specify all')
        outputenab = 'on';
    else
        outputenab = 'off';
    end
    asa = {'AutoScaleAvailable', 'off'};
elseif isa(this.filter, 'mfilt.holdinterp')
    asa = {'Enable', 'Off'};
    outputenab = 'on';
else
    outputenab = 'on';
    if issupported(this)
        info = qtoolinfo(this.Filter);
        if isfield(info, 'output')
            asa = info.output.setops;
        else
            asa = {'AutoScaleAvailable', 'on'};
        end
    else
        asa = {};
    end
end

set(getcomponent(this, 'output'), ...
    'EnableFracLengths',  outputenab, ...
    asa{:});

% [EOF]
