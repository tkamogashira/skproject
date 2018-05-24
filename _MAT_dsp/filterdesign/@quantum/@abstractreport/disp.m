function disp(this)
%DISP   Display this object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

dispheader(this);
dispinfo(this.Input,'Input: ');
dispinfo(this.Output,'Output: ');

