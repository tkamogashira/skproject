function args = lms_constructargs(h)
%LMS_CONSTRUCTARGS  Arguments to be used for construction.
%
%   See also COPY, RESET.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

args = {'FilterLength','StepSize','Leakage','Coefficients','States'};
