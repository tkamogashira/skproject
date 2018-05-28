function WI = WithinCurve(Cx, Cy, X, Y);
% WithinCurve - true if points lie within closed curve
%   WithinCurve(Cx, Cy, X, Y) returns one if the point (X,Y)
%   is enclosed by the curve C, where C is defined by its
%   vertex positions (Cx(I),Cy(I)).
%   For arrays X and Y, an array with ones and zeros is returned.
%
%   see also OnPatch.

% use complex numbers for coordinates in the plane
C = Cx+i*Cy; Z = X + i*Y;

Nz = length(Z); % # test points
% turn C into single column vector ...
C = C(:);  
% ... and make a shifted copy C(2) C(3) ... C(end) C(1)
CS = C([2:end 1]);

% Compute the total angle swept by the vectors from Z(j) to the 
% respective vertices. Note: angle(V*conj(W)) is angle *between* complex vectors V and W
sweptAngle = 0*Z; % same size as X & Y
for ii=1:Nz,
   sweptAngle(ii) = sum(angle((C-Z(ii)).*conj(CS-Z(ii))));
end
% If Z(j) is outside the patch, W = 0. Multiply winding curves yield 
% indefinite results. We interpret multiple windings as hits.

WI = (0 ~= round(sweptAngle/2/pi));




