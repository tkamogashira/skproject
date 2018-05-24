function initrls(h,sqrtinvcov,BlockLength,dStates,varargin)
%INITRLS Initializer for RLS filters.

%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
    
if nargin > 1,
    set(h,'sqrtinvcov',sqrtinvcov);
else,
    set(h,'sqrtinvcov',sqrt(1e3)*eye(L));
end

if nargin > 2,
    set(h,'SwBlockLength',BlockLength);
end

N = get(h,'SwBlockLength');

if nargin > 3,
    set(h,'DesiredSignalStates',dStates);
else,
    set(h,'DesiredSignalStates',zeros(N-1,1));
end


% Call super's initializer
initialize(h,varargin{:});

