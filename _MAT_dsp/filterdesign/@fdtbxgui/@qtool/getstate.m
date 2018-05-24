function state = getstate(this)
%GETSTATE   Returns the current state of the object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% All the other settings are already in the filter object.
state.normalize     = get(this, 'Normalize');
state.unsigned      = get(this, 'Unsigned');
state.castbeforesum = get(this, 'CastBeforeSum');

state.isapplied     = get(this, 'isApplied');
state.arithmetic    = get(this, 'Arithmetic');

state.filterinternals    = get(this, 'FilterInternals');
state.sectionwordlengths = get(this, 'SectionWordLengths');
state.sectionfraclengths = get(this, 'SectionFracLengths');

% If the GUI isn't applied, then we need to get the contained states.  If
% it is applied, then this information is part of the filter and will be
% set properly when the filter is set.
if ~state.isapplied
    h = allchild(this);
    for indx = 1:length(h)
        state.(get(h(indx), 'Tag')) = getstate(h(indx));
    end
end

state.currenttab = get(this, 'CurrentTab');

% [EOF]
