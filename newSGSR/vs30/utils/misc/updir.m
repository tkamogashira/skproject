function upd = updir(D, N);
% UPDIR - returns parent dir of curent directory
%   UPDIR(2) returns parent of parent, etc.
%   UPDIR(D) returns parent of directory D

if nargin<1, 
   D = cd;
   N = 1; 
elseif nargin==1,
   if isnumeric(D),
      N = D;
      D = cd;
   else,
      N = 1;
   end
end;

curdir = cd;
try
   cd(D);
   for ii=1:N, cd ..; end;
   upd = cd;
catch
   cd(curdir);
   error(lasterr);
end % try
cd(curdir);

