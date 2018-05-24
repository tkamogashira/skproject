function args = rlswkalman_constructargs(h)
%CONSTRUCTARGS  Arguments to be used for construction.
%
%   See also COPY, RESET.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

t = abstractrls_constructargs(h);
args= {'FilterLength',t{:},'Coefficients','States'};
