function this = loadobj(s)
%LOADOBJ   Load the object.

%   Author(s): J. Schickler
%   Copyright 1999-2011 The MathWorks, Inc.

this = feval(s.class);

this.ncoeffs     = s.ncoeffs;
if ~isstruct(s) || isfield(s, 'nphases')
    this.nphases = s.nphases;
end

this.CoeffWordLength = s.CoeffWordLength;
this.CoeffAutoScale  = s.CoeffAutoScale;

this.Signed          = s.Signed;
this.RoundMode       = s.RoundMode;
this.OverflowMode    = s.OverflowMode;

this.InputWordLength = s.InputWordLength;
this.InputFracLength = s.InputFracLength;

thisloadobj(this, s);

updateinternalsettings(this);
w = warning('off');
warning(w);
this = update(this, s);
warning(message('dsp:quantum:fixedfirfilterq:loadobj:ObsoleteProp'));

% [EOF]
