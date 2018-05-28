function cc = contrachan;
% contrachannel - returns contralateral channel 1|2 = L|R
%  SESSION must be initialized
cc = 3-channelNum(ipsiside);
