function Hbest = minimizecoeffwlfir(this,Href,varargin) %#ok<INUSL>
%   This should be a private method.

%   Copyright 2009 The MathWorks, Inc.

Hfir  = dfilt.dffir; % Dummy filter used for dispatching purposes
Hbest = minimizecoeffwlfir(Hfir,Href,varargin{:});

% [EOF]
