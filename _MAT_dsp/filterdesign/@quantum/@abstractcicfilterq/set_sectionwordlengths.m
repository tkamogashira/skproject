function swl = set_sectionwordlengths(this, swl)
%SET_SECTIONWORDLENGTHS   PreSet function for the 'sectionwordlengths' property.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.

if any(strcmpi(this.FilterInternals, {'FullPrecision','MinWordLengths'})),
    error(message('dsp:quantum:abstractcicfilterq:set_sectionwordlengths:FixedPtErr', this.FilterInternals));
end

if any(swl > getswlmax(this))
    error(message('dsp:quantum:abstractcicfilterq:set_sectionwordlengths:InvalidRange', getswlmax( this )));
end

if length(swl) == 1,
    swl = repmat(swl, 1, length(this.sectionwordlengths));
elseif length(swl) ~= length(this.sectionwordlengths),
    error(message('dsp:quantum:abstractcicfilterq:set_sectionwordlengths:InvalidDimensions'));
end

set(this, 'privSectionWordLengths', swl);

% Send the updateinternals event to figure out new frac lengths
send(this,'updateinternals');

% update states after internals have been updated
send_quantizestates(this);

swl = [];

% [EOF]
