function s = super_blockparams(Hd, mapstates)
%SUPER_BLOCKPARAMS Returns the parameters for BLOCK

% This should be a private method

% Author(s): V. Pellissier
% Copyright 1999-2006 The MathWorks, Inc.



% Parameters of the block
s.L = mat2str(Hd.FilterLength);
s.stepflag = 'Dialog';
s.mu = mat2str(Hd.StepSize);
s.leakage = mat2str(Hd.Leakage);
if strcmpi(mapstates, 'on'),
    s.addnparflag = 'on';
    s.ic = mat2str(Hd.Coefficients);
end

% [EOF]
