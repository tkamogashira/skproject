function Uname = username
%USERNAME returns username of SGSR-session
%
% See also COMPUNAME

%B. Van de Sande 02-07-2003

global UserName

if isempty(UserName), warning('SGSR-session has no username.'); end
Uname = UserName;