function r = getrealizemdlraterestrictions(~,~)
% GETREALIZEMDLRATERESTRICTIONS Get rate restrictions for the realizemdl
% method.

%   Copyright 2011 The MathWorks, Inc.

% Enforce single rate is not supported regardless of the input processing
% setting
r = 'enforcesinglerate';