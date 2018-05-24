function Hd = optimizestopbandfir(this,Href,WL,varargin)  %#ok<INUSL>
%OPTIMIZESTOPBANDFIR 
%   This should be a private method.

%   Copyright 2009 The MathWorks, Inc.

Hfir  = dfilt.dffir; % Dummy filter used for dispatching purposes
Hd = optimizestopbandfir(Hfir,Href,WL,varargin{:});

% [EOF]
