function initrls(h,sqrtinvcov,varargin)
%INITRLS Initializer for RLS filters.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
    
if nargin > 1,
    set(h,'SqrtInvCov',sqrtinvcov);
else,
    set(h,'SqrtInvCov',sqrt(1e3)*eye(L));
end

% Call super's initializer
initialize(h,varargin{:});

