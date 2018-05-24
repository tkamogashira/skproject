function [hspecsArbMag fmethodArbMag] = geteqripdesignobjects(this,w) 
%GETEQRIPDESIGNOBJECTS   

%   Copyright 2009 The MathWorks, Inc.

hspecsArbMag = fspecs.sbarbmag;
hspecsArbMag.Frequencies = this.Fspec;
hspecsArbMag.Amplitudes = this.Aspec;
fmethodArbMag = fdfmethod.eqripsbarbmag;
fmethodArbMag.Weights = w;
fmethodArbMag.UniformGrid = false;

% [EOF]