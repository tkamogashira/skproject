function inittdaf(h,varargin)
%INITTDAF  Initialize properties to correct dimension.
%
%   Inputs:
%       L            - adaptive filter length (integer > 0)
%       Step         - LMS Step size (scalar, 0 to 1)
%       Leakage      - Leakage factor (scalar, 0 to 1; 1 = no Leakage)
%       Offset       - Offset parameter (scalar > 0)
%       delta        - initial common value of all of the sliding DFT 
%                      powers (scalar > 0)
%       AvgFactor    - averaging factor for the sliding DFT powers
%                       0 << AvgFactor < 1)
%       Coefficients - initial joint process coefficients (1,L)
%       States       - adaptive filter initial conditions (L-1,1)

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

% Default LMS initializer input args
lmsargs = {varargin{1:min(3,nargin-1)}};

initlms(h,lmsargs{:});

if nargin > 4, set(h,'Offset',varargin{4}); end

mu = h.Step;

if nargin > 5,
    delta = varargin{5};
else
    delta = 5;
end

if nargin > 6,
    set(h,'AvgFactor',varargin{6});
else
    set(h,'AvgFactor',1 - mu);
end

L = get(h,'FilterLength');

h.Power = delta*ones(L,1);

% Call initialize here in case coefficients and States were specified
initialize(h,varargin{7:nargin-1});

