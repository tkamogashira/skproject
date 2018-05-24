function Hhalf = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.



% Convert passband spec to stopbad
dpass = convertmagunits(specs.Apass,'db','linear','pass');
dstop = sqrt(1 - (1-dpass)^2);
Astop = convertmagunits(dstop,'linear','db','stop');

% Create halfband designobj

f = fdesign.halfband('TW,Ast',specs.TransitionWidth,Astop);

Hhalf = design(f,'iirlinphase','FilterStructure',this.FilterStructure);


% [EOF]
