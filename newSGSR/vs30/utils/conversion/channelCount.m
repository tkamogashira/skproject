function N = channelCount(c);

% channelCount - number of active channels corresponding to channel character B|L|R 
% see also ChannelNum

if isnumeric(c),
   c = channelChar(c);
end
if isequal('B',c), 
   N=2;
elseif isequal('L',c) | isequal('R',c),
   N=1;
else
   N=0 ;
end
   