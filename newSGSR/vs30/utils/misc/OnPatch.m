function OP = OnPatch(h, x,y);
% OnPatch - true if point lies on patch
%   OnPatch(h, x, y), where h is a handle of a patch, returns 1 if the
%   point with coordinates (x,y) lies within the patch, zero
%   otherwise.
%
%   OnPatch(h, z) is the same as OnPatch(h, real(z), imag(z));
%
%   see also PatchData, PatchArea, WithinCurve.

if nargin<3, % complex coordinate
   y = imag(x);
   x = real(x);
end

Z = patchdata(h); % closed chain of vertices as complex numbers
Z = Z - (x+i*y); % vertex positions re test point (x,y)

% Compute the winding number W of the vertices around the test point, i.e.,
% the total angle swept by the vectors from (x,y) to the respective vertices.
% If (x,y) is outside the patch, W = 0. 
% Multiple windings are indefinite. We interpret them as hits.
W =  round(sum(angle(conj(Z(1:end-1)).*Z(2:end)))/2/pi);
OP = ~isequal(0,W);


