function args = constructargs(h)
%CONSTRUCTARGS  Arguments to be used for construction.
%
%   See also COPY, RESET.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

args = rlswkalman_constructargs(h);
args= {args{1:2},'SqrtInvCov','SwBlockLength','DesiredSignalStates',args{3:end}};
