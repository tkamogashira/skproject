function uitoss(oldRank,newRank,figh);

% re-orders subunits
if nargin<3, figh=gcf; end;

% get subunits
SU = uigetSU(figh);
% display them
N = length(SU);

if oldRank<newRank,
   newOrder = ...
      [(1:(oldRank-1)),((oldRank+1):(newRank-1)),oldRank,(newRank:N)];
elseif oldRank>newRank,
   newOrder = ...
      [(1:(newRank-1)),oldRank, (newRank:(oldRank-1)),((oldRank+1):N)];
else,
   return;
end
for ii=1:N,
   newSU{ii} = SU{newOrder(ii)};
end
uisetSU(newSU,figh);
uilist;