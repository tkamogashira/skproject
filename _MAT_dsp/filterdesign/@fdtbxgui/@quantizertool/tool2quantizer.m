function q = tool2quantizer(this)
%   Copyright 1999-2002 The MathWorks, Inc.

q = feval(this.quantizerclass);
if this.checkbox == true
    q.mode = this.mode;
else
  q.mode = 'none';
end

switch q.mode
 case {'fixed','ufixed'}
  q.roundmode = this.roundmode;
  q.overflowmode = this.overflowmode;
  q.format = this.fixedformat;
 case 'float'
  q.roundmode = this.roundmode;
  q.format = this.floatformat;
end  