function s = savepublicinterface(this)
%SAVEPUBLICINTERFACE   

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

s = abstract_savepublicinterface(this);

s.DifferentialDelay = this.DifferentialDelay;
s.NumberOfSections  = this.NumberOfSections;

% [EOF]
