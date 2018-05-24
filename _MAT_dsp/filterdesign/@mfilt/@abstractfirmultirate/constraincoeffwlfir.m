function Href = constraincoeffwlfir(this,Href,WL,varargin)  %#ok<INUSL>
%CONSTRAINCOEFFWLFIR 
%   This should be a private method.

%   Copyright 2009 The MathWorks, Inc.

fd = getfdesign(Href);
fm = getfmethod(Href);

Hfir  = dfilt.dffir; % Dummy filter used for dispatching purposes
Ht = constraincoeffwlfir(Hfir,Href,WL,varargin{:});

Href.Arithmetic = 'fixed';
Href.CoeffWordLength = Ht.CoeffWordLength;
Href.Numerator = Ht.Numerator;

setfdesign(Href,fd); % reset the fdesign and fmethod since
setfmethod(Href,fm); % they may have been lost during noise shaping


% [EOF]
