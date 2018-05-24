function this = loadobj(s)
%LOADOBJ   Load the object.

%   Author(s): J. Schickler
%   Copyright 1999-2006 The MathWorks, Inc.

this = feval(s.class);

this.ncoeffs         = s.ncoeffs;
this.nphases         = s.nphases;
this.maxprod = s.maxprod;
this.maxsum  = s.maxsum;

loadcoeffobj(this,s);

this.InputWordLength = s.InputWordLength;
this.InputFracLength = s.InputFracLength;

loadfdprop(this,s);

updateinternalsettings(this);

set(this, 'FilterInternals', s.FilterInternals);

switch lower(this.FilterInternals)
    case 'specifyprecision'
        set(this, ...
            'RoundMode'      , s.RoundMode, ...
            'OverflowMode'   , s.OverflowMode, ... 
            'ProductWordLength', s.ProductWordLength, ...
            'ProductFracLength', s.ProductFracLength,...
            'AccumWordLength', s.AccumWordLength, ...
            'AccumFracLength', s.AccumFracLength,...
            'OutputWordLength', s.OutputWordLength, ...
            'OutputFracLength', s.OutputFracLength);
        thisloadobj(this,s);
end


% [EOF]
