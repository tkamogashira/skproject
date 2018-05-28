function M = SU2(R, Phi,Psi);
% SU2 - SU2 matrix realizing a 3-dim rotation.
%
%   SU2(R) is the SU2 matrix the realizes a anti-clockwise 
%   rotation around the axis R = [x y z] by norm(R) radians.
%
%   SU2(Theta,Phi,Psi) is the the same thing but now specified
%   in terms of Euler angles.
%
%   Formulas were taken from Penrose and Rindler, 1.2.51 and 
%   1.2.34, respectively.
%
%   See also Spin2vec

if nargin==1, % Quaternion-like specification (see help text)
   Psi = norm(R); % total angle of rotation
   if isequal(0, Psi), M = eye(2); return; end
   r = R/Psi; % unit vector along R
   % aux vars
   c = cos(Psi/2); s = sin(Psi/2); 
   [il m in] = deal(i*r(1), r(2), i*r(3));
   % now apply P&R 1.2.51
   M = [c+in*s (-m+il)*s; (m+il)*s c-in*s];
else, % Euler angles
   Theta = R;
   % aux vars
   c = cos(Theta/2); s = sin(Theta/2); 
   PP = [Phi,Psi]/2;
   M = [c*exp(i*sum(PP)) -s*exp(i*diff(PP)); s*exp(-i*diff(PP))  c*exp(-i*sum(PP))];
end



