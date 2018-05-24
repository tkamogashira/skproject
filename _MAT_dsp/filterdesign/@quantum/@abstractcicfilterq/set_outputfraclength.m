function outputfraclength = set_outputfraclength(this, outputfraclength)
%SET_OUTPUTFRACLENGTH   PreSet function for the 'outputfraclength'
%property.

%   Author(s): R. Losada
%   Copyright 2005-2011 The MathWorks, Inc.

if ~strcmpi(this.FilterInternals, 'SpecifyPrecision'),
    error(message('dsp:set_outputfraclength:readOnly', this.FilterInternals));
end
 
this.privOutputFracLength = outputfraclength;

outputfraclength = [];

% [EOF]
