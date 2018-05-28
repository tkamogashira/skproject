function cn = channelName(ichan);

% function cn = channelName(ichan); - IDF/SPK convention-> string

names = {'Both' 'Left' 'Right'};

cn = names{ichan+1};

