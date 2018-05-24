function thisselectedinputprocessing_cb(this)
%THISSELECTEDINPUTPROCESSING_CB 

%   Copyright 2011 The MathWorks, Inc.

if get(this, 'isTransformed')
  send(this, 'FilterTransformed', ...
    sigdatatypes.sigeventdata(this, 'FilterTransformed', this.Filter));
end
% [EOF]