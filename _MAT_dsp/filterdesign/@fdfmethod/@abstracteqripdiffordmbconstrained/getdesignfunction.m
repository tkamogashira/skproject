function desfcn = getdesignfunction(~)
%GETDESIGNFUNCTION Return the design function to be used in the
%coefficients design

%   Copyright 2011 The MathWorks, Inc.

desfcn = @fircband;
           
% [EOF]
