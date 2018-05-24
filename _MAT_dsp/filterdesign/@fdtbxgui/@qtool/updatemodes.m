function updatemodes(this)
%UPDATEMODES   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

h = get(this, 'Handles');

% Special case CIC
if isa(this.filter, 'mfilt.abstractcic')
    enab = 'off';
elseif isfilterinternals(this)
    if strcmpi(this.FilterInternals, 'Full')
        enab = 'off';
    else
        enab = this.Enable;
    end
else
    enab = this.Enable;
end
setenableprop([h.roundmode h.roundmode_lbl h.overflowmode h.overflowmode_lbl], enab)

prop_listener(this, 'roundmode');
prop_listener(this, 'overflowmode');

% [EOF]
