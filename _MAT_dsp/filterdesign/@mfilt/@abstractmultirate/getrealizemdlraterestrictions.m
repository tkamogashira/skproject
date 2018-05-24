function r = getrealizemdlraterestrictions(this,inputProcessing) %#ok<INUSD>
% GETREALIZEMDLRATERESTRICTIONS Get rate restrictions for the realizemdl
% method.

%   Copyright 2011 The MathWorks, Inc.

% Do not support multirate unless the sub-class overrides this method
r = 'allowmultirate';