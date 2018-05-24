function args = constructargs(h)
%CONSTRUCTARGS  Arguments to be used for construction.
%
%   See also COPY, RESET.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

args = lms_constructargs(h);
args= {args{1:3},'Delay','ErrorStates',args{4:5}};
