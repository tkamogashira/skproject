function [Hbest,mrfflag] = optimizecoeffwlfir(this,Href,varargin) %#ok<INUSL>
%OPTIMIZECOEFFWL Optimize coefficient wordlength for FIR filters.
%   This should be a private method.

%   Copyright 2009 The MathWorks, Inc.

Hfir  = dfilt.dffir; % Dummy filter used for dispatching purposes
[Hbest,mrfflag] = optimizecoeffwlfir(Hfir,Href,varargin{:});

% [EOF]
