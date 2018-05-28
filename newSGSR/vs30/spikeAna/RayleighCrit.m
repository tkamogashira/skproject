function r = RayleighCrit(n,alpha);
% RayleighCrit - critical value of vector strength r to meet given confidence
%   RayleighCrit(n,alpha) is the min r resulting in a confidence level of
%   at most alpha in the case of n occurences

Nn = prod(size(n));
if Nn>1, % multi-valued n: recursive call
   r = zeros(size(n));
   for ii=1:Nn,
      r(ii) = RayleighCrit(n(ii),alpha);
   end
   return
end

% get the table from RayleighSign function
SigniTable = RayleighSign('table');


% find the rows of the table between which to interpolate
row1 = max(find(SigniTable.n<=n));
row2 = row1+1;
n1 = SigniTable.n(row1);
n2 = SigniTable.n(row2);
if isempty(row1),
   r = 1;
   return;
end

% interpolate the rows of the table
pos = (n-n1)/(n2-n1);
zvalues = (1-pos)*SigniTable.z_a_n(row1,:)...
   + pos*SigniTable.z_a_n(row2,:);


% find first elem of alpha vector that does not exceed given alpha
col = min(find(alpha>=SigniTable.alpha));
% convert the corresponding critical z to critical r
zcrit = zvalues(col);
r = sqrt(zcrit/n);
