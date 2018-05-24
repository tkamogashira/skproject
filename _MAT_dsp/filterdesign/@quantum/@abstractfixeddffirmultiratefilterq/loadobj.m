function this = loadobj(s)
%LOADOBJ   

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

this = feval(s.class);

this.ncoeffs         = s.ncoeffs;
this.nphases         = s.nphases;
if isstruct(s) && ~isfield(s, 'version')
    if isfield(s, 'nphases')
        s.version.number = 1;
        s.version.description = 'R14sp1';
    else
        s.version.number = 0;
        s.version.description = 'R14';
    end
end
if s.version.number > 2,
    this.maxprod = s.maxprod;
    this.maxsum  = s.maxsum;
end

this.CoeffWordLength = s.CoeffWordLength;
this.CoeffAutoScale  = false;
set(this, 'NumFracLength', s.NumFracLength);
this.CoeffAutoScale  = s.CoeffAutoScale;

this.Signed          = s.Signed;

this.InputWordLength = s.InputWordLength;
this.InputFracLength = s.InputFracLength;

% this.InheritSettings = s.InheritSettings;

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
