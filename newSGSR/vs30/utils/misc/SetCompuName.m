function SetCompuName(n)
% SETCOMPUNAME - set name of computer
%   SETCOMPUNAME FOO sets the computer name to "FOO".
%   Note: these names are meaningful only within SGSR.
%
%   See also COMPUNAME.

ID.computer = n;
saveFieldsInSetupFile(ID,'computerID');

