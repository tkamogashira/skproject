function C = channelChar(cNum, fullName);
% channelChar - converts channel number 0|1|2|3 to character B|L|R|N  ~ both|left|right|none
if nargin<2,
   fullName = 0;
end

if isnan(cNum), cNum = 3; end

if isequal(cNum,'n') | isequal(cNum,'N'),
   C = cNum;
   return;
end


if ischar(cNum),
   cNum = channelNum(cNum);
end
Cstr = {'Both', 'Left', 'Right' 'None'};
C = Cstr{cNum+1};

if ~fullName,
   C = C(1);
end
