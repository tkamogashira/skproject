function [p, v] = info(this)
%INFO   Return the info for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

p = {getString(message('signal:dfilt:info:Gain')), ...
     getString(message('signal:dfilt:info:Input')), ...
     getString(message('signal:dfilt:info:Output')), ...
     getString(message('signal:dfilt:info:RoundMode')), ...
     getString(message('signal:dfilt:info:OverflowMode'))};

if this.Signed
    pre = 's';
else
    pre = 'u';
end

v = {formatinfo(this,pre,this.CoeffWordLength, this.CoeffFracLength), ...
    formatinfo(this,'s',this.InputWordLength, this.InputFracLength), ...
    formatinfo(this,'s',this.OutputWordLength, this.OutputFracLength), ...
    this.RoundMode, this.OverflowMode};

% [EOF]
