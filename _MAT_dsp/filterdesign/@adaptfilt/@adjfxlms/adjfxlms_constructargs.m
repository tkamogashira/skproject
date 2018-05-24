function args = adjfxlms_constructargs(h)
%ADJFXLMS_CONSTRUCTARGS  Returns a list of properties that are settable at construction time.
%
%   See also COPY, RESET.

%   Author(s): P. Pacheco
%   Copyright 1999-2002 The MathWorks, Inc.


lmsArgs = lms_constructargs(h);
args = {lmsArgs{1:3},'SecondaryPathCoeffs','SecondaryPathEstimate',...
        'SecondaryPathStates',lmsArgs{4:5}};

