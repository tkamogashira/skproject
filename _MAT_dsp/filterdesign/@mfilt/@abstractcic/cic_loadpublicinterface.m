function cic_loadpublicinterface(this, s)
%CIC_LOADPUBLICINTERFACE   Load the public interface.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% Make sure to set the number of sections before the differential delay
set(this,'NumberOfSections', s.NumberOfSections);
set(this, 'DifferentialDelay', s.DifferentialDelay);

abstract_loadpublicinterface(this, s);

if s.version.number == 0,
    % Make sure to set the filterinternals first
    set(this,'FilterInternals', 'specifywordlengths');
    set(this, 'InputWordLength', s.InputBitWidth, ...
        'OutputBitWidth', s.OutputBitWidth);        
end

% [EOF]
