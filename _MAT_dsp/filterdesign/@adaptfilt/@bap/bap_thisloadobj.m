function bap_thisloadobj(this, s)
%BAP_THISLOADOBJ   Load this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

abstractap_thisloadobj(this, s);

set(this, 'OffsetCov', s.OffsetCov);

% [EOF]
