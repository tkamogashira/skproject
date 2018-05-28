function A = AreaWithinCurve(X,Y);
% AreaWithinCurve - area enclosed by curve
%   AreaWithinCurve(X,Y) is the area enclosed by the curve whose coordinates
%   are described by the coordinates X(k) and Y(k).
%   
%   AreaWithinCurve([X Y]) where X and Y are column vectors, is the same thing.
%
%   AreaWithinCurve(Z) where Z is an array is the same as AreaWithinCurve(real(Z), imag(Z));
%
%   see also PatchAera, WithinCurve.

if nargin<2, 
    if size(X,2)==2, 
        Z = X(:,1) + i*X(:,2);
    else, Z = X; 
    end
else, Z = X + i*Y;
end 
Z = Z(:); % column vector
Z = [Z; Z(1)]; % closed the chain of vertices 
Z = Z - mean(Z); % to minimize rounding errors
A = 0.5*imag((Z(1:end-1)'*Z(2:end)));



