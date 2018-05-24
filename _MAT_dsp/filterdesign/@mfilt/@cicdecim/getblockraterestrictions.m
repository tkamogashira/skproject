function r = getblockraterestrictions(~,inputProcessing) 
% GETBLOCKRATERESTRICTIONS Get rate restrictions for the block method.

%   Copyright 2012 The MathWorks, Inc.

if strcmp(inputProcessing,'elementsaschannels')
  r = 'enforcesinglerate';
else
  r = 'allowmultirate';
end