function resultFlag=IsPCWIN

% Return true if the platform is a Windows PC
%
% Is IsPCWin is an abbreviation for:
%   strcmp(computer,'PCWIN')
%
% See Also: IsMAC2, IsMAC

% HISTORY
%
% 2/19/04 awi WroteIt

resultFlag=strcmp(computer,'PCWIN');