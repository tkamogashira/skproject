function initialize(h,varargin)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1,
    initargs = {varargin{1:min(nargin-1,2)}};
else
    initargs = {};
end
% Call super's method
initialize_bap(h,initargs{:});

L = get(h,'FilterLength');
po = get(h,'ProjectionOrder');

if nargin > 3,
    set(h,'States',varargin{3});
else,
    set(h,'States',zeros(L+po-2,1));
end

if nargin > 4,
    set(h,'ErrorStates',varargin{4});
else,
    set(h,'ErrorStates',zeros(po-1,1));
end

if nargin > 5,
    set(h,'EpsilonStates',varargin{5});
else,
    set(h,'EpsilonStates',zeros(po-1,1));
end
