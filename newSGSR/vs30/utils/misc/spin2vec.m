function L = Spin2Vec(S, flag);
% Spin2Vec - convert spin vector to spatial part of lightlike 4-vector
%
%   Spin2Vec(S) is the real 3-vector [X Y Z].'
%   corresponding to the length-two complex spin vector S.
%   Based on Penrose & Rindler, 1.2.23
%
%   When S is a 2xM matrix, Spin2vec returns 
%   a 4xM matrix whose Jth column is Spin2vec(S(:,J)).
%
%   Spin2Vec(S,'4') returns a 4-dim null vector with spatial
%   part as before, i.e. [X Y Z T].' with X^2 + Y^2 + Z^2 + T^2 = 0.
%
%   See also Vec2spin, SU2.

if nargin<2, flag = ''; end

rela = 0;
switch lower(flag),
case '4', rela = 1;
case '',
otherwise error(['Unknown flag ''' flag '''.']);
end

if size(S,1)==1,
   S = S(:); % make sure S is column vector
end

if size(S,1)~=2,
   error('Input argument S must be length-2 vector or 2xN matrix.');
end

if size(S,2)>1, % recursive, columnwise
   M = size(S,2);
   len = 3; if rela, len=4; end;
   L = zeros(len,M);
   for icol=1:M,
      L(:,icol) = spin2vec(S(:,icol), flag);
   end
   return;
end

% first construct 2x2 outer product S S'
LM = sqrt(0.5)*S*S';
% extract (X,Y,Z,T) using
%  LM = 0.5 * [T+Z  X+iY
%              X-iY T-Z ]

T = LM(1,1) + LM(2,2);
Z = LM(1,1) - LM(2,2);
X = LM(1,2) + LM(2,1);
iY= LM(1,2) - LM(2,1);

L = [X; -i*iY; Z];
if rela, L = [L; T]; end
L = real(L);

