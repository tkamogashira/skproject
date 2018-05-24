function setformat(this,fmt)
%   Copyright 1999-2002 The MathWorks, Inc.

switch this.mode
 case {'fixed', 'ufixed'}
  this.fixedformat = fmt;
 otherwise
  this.floatformat = fmt;
end
