function r = getblockraterestrictions(~,~)
% GETBLOCKRATERESTRICTIONS Get rate restrictions for the block method.

%   Copyright 2011 The MathWorks, Inc.

% Does not support allow multirate regardless of the input processing.
r = 'allowmultirate';
