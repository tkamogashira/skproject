function N = channelNum(channelChar);
% channelNum - converts channel character B|L|R  ~ both|left|right to  number 0|1|2 
%   see also ChannelChar

if isnumeric(channelChar), N = channelChar;
else, N = find('BLR'==upper(channelChar(1)))-1;
end