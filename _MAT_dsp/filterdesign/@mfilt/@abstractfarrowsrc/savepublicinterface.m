function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

s = abstract_savepublicinterface(this);
s.InterpolationFactor = this.InterpolationFactor;
s.DecimationFactor = this.DecimationFactor;


% [EOF]
