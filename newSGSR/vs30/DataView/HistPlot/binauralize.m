function x = binauralize(x, chan, Nsub);
% binauralize - make a variable two-valued, depending on active d/a channels

if nargin<3, Nsub=0; end; % do not tile rows
chan = channelNum(chan); 

% expand width if needed
if isempty(x), x = [nan, nan];
elseif size(x,2)==1,
   x = [x, x];
end
% nan inactive channels
if chan==1,  x(:,2) = nan;
elseif chan==2, x(:,1) = nan;
end
% rep in Nsub dimension
if Nsub>size(x,1),
   x = repmat(x,Nsub,1);
end

