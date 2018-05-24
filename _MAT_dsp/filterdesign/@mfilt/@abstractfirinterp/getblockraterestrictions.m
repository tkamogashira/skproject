function r = getblockraterestrictions(~,inputProcessing) 
% GETBLOCKRATERESTRICTIONS Get rate restrictions for the block method.

%   Copyright 2011 The MathWorks, Inc.

r = [];
if ~strcmpi(inputProcessing,'columnsaschannels')
  % Enforce single rate is not supported
  r = 'enforcesinglerate';
end