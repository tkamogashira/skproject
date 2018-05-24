function thisconstruct(h,varargin)
%THISCONSTRUCT Local this construct method.

%   Author(s): P. Costa
%   Copyright 1999-2002 The MathWorks, Inc.

% Default LMS initializer input args
lmsargs = {varargin{1:min(3,nargin-1)}};

initlms(h,lmsargs{:});

if nargin > 4,
    set(h,'Offset',varargin{4});
else
    set(h,'Offset',1);
end

mu = h.StepSize;
if nargin > 5,
    set(h,'ReflectionCoeffsStep',varargin{5});
else
    set(h,'ReflectionCoeffsStep',mu);
end

if nargin > 6,
    delta = varargin{6};
else
    delta = 0.1;
end

if nargin > 7,
    set(h,'AvgFactor',varargin{7});
else
    set(h,'AvgFactor',1 - mu);
end
    
L = get(h,'FilterLength');

h.FwdPredErrorPower = delta*ones(L,1);
h.BkwdPredErrorPower = delta*ones(L,1);

if nargin > 8,
  set(h,'ReflectionCoeffs', varargin{8});    
else 
  set(h,'ReflectionCoeffs',zeros(1,L-1));
end
    
% Call initialize here in case coefficients and states were specified
initialize(h,varargin{9:nargin-1});
