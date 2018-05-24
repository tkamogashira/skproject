function args = constructargs(h)
%CONSTRUCTARGS  Returns a list of properties that are settable at construction time.
%
%   See also COPY, RESET.

%   Author(s): P. Pacheco
%   Copyright 1999-2002 The MathWorks, Inc.

args = lms_constructargs(h);
% 0 is dummy argument for the input arg DELTA which is not a property.
args= {args{1:3},'Offset','ReflectionCoeffsStep',0,'AvgFactor','ReflectionCoeffs',args{4:5}};
