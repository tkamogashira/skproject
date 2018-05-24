function p = blockparams(this,forceDigitalFilterBlock)
%BLOCKPARAMS   Return the parameters for the block.

%   Copyright 1999-2012 The MathWorks, Inc.

if nargin == 1
  forceDigitalFilterBlock = false;
end

p = df1_blockparams(this,forceDigitalFilterBlock);
