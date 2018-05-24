function s = saveprivatedata(this)
%SAVEPRIVATEDATA Save private data
%   Copyright 2007 The MathWorks, Inc.

s = base_saveprivatedata(this);
s.Tnext = this.Tnext;


% [EOF]
