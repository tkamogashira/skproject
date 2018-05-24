function initrls(h,sqrtcov,varargin)
%INITRLS Initializer for RLS filters.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
    
if nargin > 1,
    set(h,'SqrtCov',sqrtcov);
else,
    set(h,'SqrtCov',sqrt(1e-3)*eye(L));
end

% Call super's initializer
initialize(h,varargin{:});

