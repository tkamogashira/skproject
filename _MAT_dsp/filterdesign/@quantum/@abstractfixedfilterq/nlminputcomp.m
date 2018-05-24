function Pnn = nlminputcomp(this,Hf,M,Pnn)
%NLMINPUTCOMP   
%   Author(s): R. Losada
%   Copyright 1999-2003 The MathWorks, Inc.

% The noise variance for roundmode fix is eps^2/3.  For all other roundmodes,
% the noise variance is eps^2/12.
if strcmpi(this.roundmode,'fix')
  d = 3;
else
  d = 12;
end


iwl = this.InputWordLength;
ifl = this.InputFracLength;

R = 2^(iwl-ifl); % Input Quantizer Range
delta = R/(2^iwl);
errvar = delta^2/d;
Pnn = Pnn - Hf.*conj(Hf)*errvar;
 


% [EOF]
