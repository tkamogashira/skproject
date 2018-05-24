function [hspecsArbMag fmethodArbMag] = getfreqsampdesignobjects(this) 
%GETFREQSAMPDESIGNOBJECTS   

%   Copyright 2009 The MathWorks, Inc.

hspecsArbMag = fspecs.sbarbmag;
hspecsArbMag.Frequencies = this.Fspec;
hspecsArbMag.Amplitudes = this.Aspec;
fmethodArbMag = fmethod.freqsamparbmag;

% [EOF]