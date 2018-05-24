function s = blockparams(Hd, mapstates, varargin)
%BLOCKPARAMS Returns the parameters for BLOCK

% Copyright 1999-2012 The MathWorks, Inc.


% Parameters of the block
s.L = mat2str(Hd.FilterLength);
s.lambdaflag = 'Dialog';
s.lambda = mat2str(Hd.ForgettingFactor);
if strcmpi(mapstates, 'on'),
    s.addnparflag = 'on';
    s.ic = mat2str(Hd.Coefficients);
    s.delta = mat2str(1/Hd.InvCov(1));
end

