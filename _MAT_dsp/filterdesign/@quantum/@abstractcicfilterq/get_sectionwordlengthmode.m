function swlm = get_sectionwordlengthmode(this, ~) %#ok<STOUT,*INUSD>
%GET_SECTIONWORDLENGTHMODE   PreGet function for the 'sectionwordlengthmode' property.

%   Author(s): J. Schickler
%   Copyright 1999-2012 The MathWorks, Inc.

error(message('dsp:quantum:abstractcicfilterq:get_sectionwordlengthmode:Obsolete'));
swlm = get(this, 'privSectionWordLengthMode'); %#ok<UNRCH>

% [EOF]
