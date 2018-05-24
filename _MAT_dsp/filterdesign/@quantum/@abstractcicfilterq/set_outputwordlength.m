function owl = set_outputwordlength(this, owl)
%SET_OUTPUTWORDLENGTH   PreSet function for the 'outputwordlength' property.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.

if strcmpi(this.FilterInternals, 'FullPrecision'),
    error(message('dsp:set_outputwordlength:readOnly', this.FilterInternals));
end

set(this, 'privOutputWordLength', owl);

% Update all internals including states
sendupdate(this);

owl = [];

% [EOF]
