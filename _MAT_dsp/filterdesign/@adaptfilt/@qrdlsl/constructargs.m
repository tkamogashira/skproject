function args = constructargs(h)
%CONSTRUCTARGS Arguments to be used for construction.
%
%   See also COPY, RESET.

%   Author(s): P. Pacheco
%   Copyright 1999-2002 The MathWorks, Inc.

lambda = abstractrls_constructargs(h);
args = {'FilterLength',lambda{:},'InitFactor','Coefficients','States'};
