function Hhalf = actualdesign(this,specs)
%ACTUALDESIGN   

%   Author(s): R. Losada
%   Copyright 2005-2006 The MathWorks, Inc.



% Create halfband designobj
f = fdesign.halfband('N,TW',specs.FilterOrder,specs.TransitionWidth);

Hhalf = design(f,'ellip','FilterStructure',this.FilterStructure);

% [EOF]
