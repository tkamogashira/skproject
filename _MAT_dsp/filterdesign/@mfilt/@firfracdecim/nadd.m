function n = nadd(this)
%NADD Returns the number of adders  

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

p = polyphase(reffilter(this));
r = getratechangefactors(this);
n = (r(2)-1)*r(1) + r(1)-1;
for i=1:size(p,1),
    n = n + length(find(p(i,:)~=0)) - 1;
end

% [EOF]
