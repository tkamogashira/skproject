function Hd = createobj(this,varargin)
%CREATEOBJ   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

alpha0 = varargin{1}{1};
alpha1 = varargin{1}{2};
Hd = allpasshalfband(this,alpha0,alpha1);

% [EOF]
