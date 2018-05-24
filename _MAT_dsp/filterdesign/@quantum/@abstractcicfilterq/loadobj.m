function this = loadobj(s)
%LOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

this = feval(s.class);

set(this, ...
    'InputWordLength',       s.InputWordLength, ...
    'InputFracLength',       s.InputFracLength);

% Temporarily set filter internals to specify precision
set(this,'FilterInternals','SpecifyPrecision');

% Set all wordlengths and fraclengths
% We have to set priv wl/fl because if the length is different to the
% current one, the set function will error
set(this,...
    'privSectionWordLengths', s.SectionWordLengths,...
    'privSectionFracLengths', s.SectionFracLengths,...
    'OutputWordLength', s.OutputWordLength,...
    'OutputFracLength', s.OutputFracLength);


% Set filter internals for structures that have it, otherwise set old
% sectionwordlengthmode field
if ~isstruct(s) || isfield(s,'FilterInternals'),
    set(this,'FilterInternals',s.FilterInternals);
else
    set(this,'FilterInternals', s.SectionWordLengthMode);
end

% [EOF]
