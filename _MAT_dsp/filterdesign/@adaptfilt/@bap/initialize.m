function initialize(h,varargin)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1,
    initargs = {varargin{1:min(nargin-1,2)}};
else
    initargs = {};
end
% Call alternate method
initialize_bap(h,initargs{:});

L = get(h,'FilterLength'); 
po = get(h,'ProjectionOrder');
if nargin > 3,
    set(h,'States',varargin{3});
else,
    set(h,'States',zeros(L+po-1,1));
end
