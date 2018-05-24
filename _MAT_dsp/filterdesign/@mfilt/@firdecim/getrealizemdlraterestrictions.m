function r = getrealizemdlraterestrictions(~,inputProcessing)
% GETREALIZEMDLRATERESTRICTIONS Get rate restrictions for the realizemdl
% method.

%   Copyright 2011 The MathWorks, Inc.

r = [];
if ~strcmpi(inputProcessing,'columnsaschannels')
  % Enforce single rate is not supported
  r = 'enforcesinglerate';
end