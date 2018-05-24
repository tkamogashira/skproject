function swl = set_secwordlengths(this, swl)
%SET_SECWORDLENGTHS   PreSet function for the 'sectionwordlengths' property.

%   Author(s): R. Losada
%   Copyright 2005-2012 The MathWorks, Inc.

if any(strcmpi(this.FilterInternals, {'FullPrecision','MinWordLengths'})),
    error(message('dsp:quantum:abstractcicfilterq:set_secwordlengths:FixedPtErr',this.FilterInternals ));
end

if any(swl > getswlmax(this))
    error(message('dsp:quantum:abstractcicfilterq:set_secwordlengths:InvalidRange', getswlmax(this)));
end

if length(swl) == 1,
    swl = repmat(swl, 1, length(this.sectionwordlengths));
elseif length(swl) ~= length(this.sectionwordlengths),
    error(message('dsp:quantum:abstractcicfilterq:set_secwordlengths:InvalidDimensions'));
end

set(this, 'privSectionWordLengths', swl);

% Update all internals including states
sendupdate(this);

swl = [];

% [EOF]
