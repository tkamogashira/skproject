function fmt = getformat(this)

%   Copyright 1999-2008 The MathWorks, Inc.

try
  switch this.mode
   case {'fixed', 'ufixed'}
    fmt = this.fixedformat;
   otherwise
    fmt = this.floatformat;
  end
catch ME
  senderror(this, ME.identifier, ME.message);
end
