function setcasfilter(Hm,R,M,N)
%SETCASFILTER Set the cascaded filter.
%   SETCASFILTER(Hm,R,M,N)

%   This should be a private method.

%   Author: P. Costa
%   Copyright 1999-2004 The MathWorks, Inc.

error(nargchk(4,4,nargin,'struct'));

% Only create a cascaded filter once all the required properties have been
% defined (properties are empty during object creation).
if any([isempty(R), isempty(M), isempty(N)]),
    return;
else
    b = 1;
    temp=ones(1,R*M); % uniform-coefficient (boxcar) filter
    for n = 1:N,
        b = conv(b,temp);
    end
    set(Hm,'Filters',lwdfilt.symfir(b));
end

% [EOF]
