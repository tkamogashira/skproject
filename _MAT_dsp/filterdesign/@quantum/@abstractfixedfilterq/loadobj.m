function this = loadobj(s)
%LOADOBJ   Load the object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

this = feval(s.class);

if isstruct(s) && ~isfield(s, 'version')
    if isfield(s, 'nphases')
        s.version.number = 1;
        s.version.description = 'R14sp1';
    else
        s.version.number = 0;
        s.version.description = 'R14';
    end
end

this.ncoeffs     = s.ncoeffs;
if s.version.number > 0
    this.nphases = s.nphases;
    if s.version.number > 2,
        this.maxprod = s.maxprod;
        this.maxsum  = s.maxsum;
    end
end

this.CoeffWordLength = s.CoeffWordLength;
this.CoeffAutoScale  = s.CoeffAutoScale;

this.Signed          = s.Signed;
this.RoundMode       = s.RoundMode;
this.OverflowMode    = s.OverflowMode;

this.InputWordLength = s.InputWordLength;
this.InputFracLength = s.InputFracLength;

% this.InheritSettings = s.InheritSettings;

thisloadobj(this, s);

updateinternalsettings(this);

% [EOF]
