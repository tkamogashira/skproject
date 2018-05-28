function dd = doubleDelay(d, convType);
% doubleDelay - convert single itd to per-channel values.
%    SYNTAX
%    dd = doubleDelay(itd, convType);
%    where itd is col vector of delays and
%    'convType' is  LR|IC (left/right, ipsi/contra)
%      (default is IC)
%
%    Convention: 
%  IC: POSitive itd -> LEADING IPSIlateral channel
%  RL: POSitive itd -> RIGHT channel LEADS

if nargin<2,
   convType = 'IC';
end
convType = upper(convType);

N = size(d,1);
dd = zeros(N,2);
for ii=1:N,
   if d(ii) < 0, 
      dd(ii,:) = [0, -d(ii)];
   else,
      dd(ii,:) = [d(ii), 0];
   end
end

if isequal('IC',convType) ...
      & isequal('L', ipsiside),
   % swap columns (because ipsi==left)
   dd = [dd(:,2) dd(:,1)];
end
