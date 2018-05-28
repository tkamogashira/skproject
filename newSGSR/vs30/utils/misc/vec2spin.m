function S = Vec2Spin(R);
% Vec2Spin - find spin vector corresponding to spatial direction
%
%   S = Vec2Spin(R) finds a spin vector S that corresponds to 
%   a null vector with spatial coordinates R = [x y z].
%   This function is an inverse of SpinVec in the loose sense
%   that Spin2vec(S) = [R norm(R)]. 
%   Note that S has an arbitrary phase vector.
%   R may contain a 4-th component; it is ignored in the computation.
%
%   If R is a 3xM or 4xM matrix, Vec2Spin returns a 2xM matrix whose
%   Jth column is Vec2Spin(R(:,J)).
%
%   See also Vec2spin, SU2.

if size(R,1)==1,
   R = R(:); % make sure R is column vector
end

if (size(R,1)~=3) & (size(R,1)~=4),
   error('Input argument S must be length-3 or vector or 3xN matrix.');
end

if size(R,2)>1, % recursive, columnwise
   M = size(R,2);
   S = zeros(2,M);
   for icol=1:M,
      S(:,icol) = vec2spin(R(:,icol));
   end
   return;
end

%----single R from here-----
if length(R)==4, R = (1:3); end % ignore time component

% General approach: start from fixed vector in z-direction and use rotation to align with R. Finally scale.

% rotation axis: "halfway" R and the Z-axis
r = R/norm(R);
Ax = (r + [0 0 1].');
if isequal(0, norm(Ax)), % R happened to be along the neg Z-axis. Use Y-axis as rotation axis.
   Ax = [0 1 0];
end
% rotation by pi radians does the job
Ax = pi*Ax/norm(Ax);
% this spinvector yields [0,0,1,1]' , i.e., has the unit z vector as its spatial cmp.
Sz = 2^0.25*[1; 0]; 
% rotate Sz as described above
S = Su2(Ax)*Sz;
% fix the scaling. Note: vectors grow quadratically with spin vectors.
S = S*sqrt(norm(R));





