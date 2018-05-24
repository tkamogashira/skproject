function r = getblockraterestrictions(~,inputProcessing)
% GETBLOCKRATERESTRICTIONS Get rate restrictions for the block method.

%   Copyright 2011 The MathWorks, Inc.

r = [];
if strcmpi(inputProcessing,'columnsaschannels')
  % Does not support allow multirate
  r = 'allowmultirate';
end