function Hd = createobj(this,alpha)
%CREATEOBJ   

%   Author(s): R. Losada
%   Copyright 2005 The MathWorks, Inc.

% Form denominators in second-order section form
alpha0 = alpha(1:2:end);
alpha1 = alpha(2:2:end);

Hd = allpasshalfband(this,alpha0',alpha1');

% [EOF]
