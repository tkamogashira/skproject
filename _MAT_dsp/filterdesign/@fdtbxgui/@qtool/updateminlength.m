function updateminlength(this)
%UPDATEMINLENGTH   

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

Hd = get(this, 'Filter');
h  = get(this, 'Handles');

hi = getcomponent(this, 'input');

try
    iwl = evaluatevars(hi.WordLength);
catch
    iwl = Hd.InputWordLength;
end

try
    ifl = evaluatevars(hi.FracLengths{1});
catch
    ifl = Hd.InputFracLength;
end

old_fi = get(Hd, 'FilterInternals');

set(Hd, 'FilterInternals', 'MinWordLengths');

wl = get(Hd, 'SectionWordLengths');

set(Hd, 'FilterInternals', old_fi);

minstr = sprintf('%d ', wl);
minstr(end) = [];

minstr = sprintf('%s: [%s]', 'Minimum Word Length Per Section', minstr);

set(h.minimumlength, 'String', minstr);

set(h.sectionfraclengths, 'String', sprintf('Section Fractional Lengths: %s', ...
    mat2str(Hd.SectionFracLengths))); %+ifl-Hd.SectionFracLengths)))

% [EOF]
