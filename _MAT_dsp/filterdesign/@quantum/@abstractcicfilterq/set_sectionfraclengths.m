function sectionfraclengths = set_sectionfraclengths(this, sectionfraclengths)
%SET_SECTIONFRACLENGTHS   PreSet function for the 'sectionfraclengths'
%property.

%   Author(s): R. Losada
%   Copyright 2005-2011 The MathWorks, Inc.

if ~strcmpi(this.FilterInternals, 'SpecifyPrecision'),
    error(message('dsp:quantum:abstractcicfilterq:set_sectionfraclengths:FixedPtErr', this.FilterInternals));
end

if length(sectionfraclengths) == 1,
    sectionfraclengths = repmat(sectionfraclengths, 1, length(this.sectionfraclengths));
elseif length(sectionfraclengths) ~= length(this.sectionfraclengths),
    error(message('dsp:quantum:abstractcicfilterq:set_sectionfraclengths:InvalidDimensions'));
end

this.privSectionFracLengths = sectionfraclengths;

% Update all internals including states
sendupdate(this);

sectionfraclengths = [];

% [EOF]
