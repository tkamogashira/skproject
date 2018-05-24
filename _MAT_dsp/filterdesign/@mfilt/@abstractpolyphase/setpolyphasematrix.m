function p = setpolyphasematrix(Hm,p)
%SETPOLYPHASEMATRIX Overloaded set function on the PolyphaseMatrix property.

%   Author: V. Pellissier
%   Copyright 1999-2004 The MathWorks, Inc.

% Check data type and store polyphase matrix as reference
set(Hm,'refpolym',p); 

% Quantize the coefficients
quantizecoeffs(Hm);

% Hold an empty to not duplicate storage
p = [];

% [EOF]
