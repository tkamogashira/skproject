function loadpublicinterface(this, s)
%LOADPUBLICINTERFACE   

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

abstract_loadpublicinterface(this, s);
this.InterpolationFactor = s.InterpolationFactor;
this.DecimationFactor = s.DecimationFactor;


% [EOF]
