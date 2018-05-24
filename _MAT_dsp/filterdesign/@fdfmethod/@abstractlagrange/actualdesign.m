function varargout = actualdesign(this,hspecs)
%ACTUALDESIGN   Perform the actual design.

%   Author(s): V. Pellissier
%   Copyright 2005-2006 The MathWorks, Inc.

w = warning;
N = getorder(hspecs);
% Lagrange Designs for FD Farrow from
% http://www.acoustics.hut.fi/~vpv/publications/vesan_vaitos/ch3_pt2_lagrange.pdf
L = N+1;
U = fliplr(vander(0:N));
Q = inv(U);
% Modified Farrow - D' = D+1
if N>1
    T = eye(L);
    for i=1:L,
        for j=i:L,
            T(i,j) = nchoosek(j-1,i-1)*(floor(N/2))^(j-i);
            [lastmsg, lastid] = lastwarn;
            if strcmpi(lastid,'MATLAB:nchoosek:LargeCoefficient'),
                warning('off','MATLAB:nchoosek:LargeCoefficient')
            end
        end
    end
    Q = T*Q;
end

% Forcing zeros and ones for those ought to be zeros and ones to eliminate
% the roundoff error.
[N1, D1] = rat(Q);
Q(N1 == 0) = 0;
Q(N1 == D1) = 1;

C = fliplr(Q.');
warning(w);
varargout{1} = {getextraobjparam(this,hspecs);C};

% [EOF]
