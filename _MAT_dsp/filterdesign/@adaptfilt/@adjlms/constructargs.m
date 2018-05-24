function args = constructargs(h)
%CONSTRUCTARGS  Returns a list of properties that are settable at construction time.
%
%   See also COPY, RESET.

%   Author(s): P. Pacheco
%   Copyright 1999-2002 The MathWorks, Inc.


adjfxlmsArgs = adjfxlms_constructargs(h);
args = {adjfxlmsArgs{1:end-3},'ErrorStates',adjfxlmsArgs{end-2:end}};

