function setstate(this, state)
%SETSTATE   Set the state of the QUI.

%   Author(s): J. Schickler
%   Copyright 1999-2010 The MathWorks, Inc.

if isfield(state, 'Switch')
    % OLD STATE!  Can't use this stuff.  Settings don't apply
    % We'll grab the information from the filter if it is still quantized.
else
    
    if isfield(state, 'sectionwordlengthmode')
        switch lower(state.sectionwordlengthmode)
            case 'minimum'
                fint = 'full';
            case 'specify'
                fint = 'specify all';
        end
        state.filterinternals = fint;
        state = rmfield(state, 'sectionwordlengthmode');
    end
        
    if ~state.isapplied
        h = allchild(this);
        for indx = 1:length(h)
            setstate(h(indx), state.(get(h(indx), 'Tag')));
            state = rmfield(state, get(h(indx), 'Tag'));
        end
    end
    set(this, state);
end

% [EOF]
