function flag = dspCheckPow2(x) %#codegen
%dspCheckPow2 Return true if input is a power of two.
%   FLAG = dspCheckPow2(X) returns FLAG as true if input X is a power of 2.
%   The function assumes that X < 2^32.

%   Copyright 2009-2010 The MathWorks, Inc.

  % If x is a power of 2, it has just a single 1-bit
  % In 2's complement, x-1 then has all 1-bits in all lower LSBs
  % Hence, x and x-1 don't share any 1-bits
  x32 = uint32(x);
  flag = (x32~=0) && ~bitand(x32,x32-1);
end