function [gf, index, groupLen, Ngroup] = groupFcar(fcar, conf, minconf);
% groupFcar - partition zwuis carrier freqs in adjacent subgroups
%   syntax: [gf, index, groupLen, Ngroup] = groupFcar(fcar, conf, minconf);
%   NOTE: convention on  conf is that it has to exceed minconf in order for the
%   respective cmpts to be significant.

if nargin<3, minconf=2; end;

Nmingroup = 3;

fcar = fcar(:); conf = conf(:);
% minimum original distance (disregarding gaps due to insignificance of individual cmpts)
minD = min(diff(fcar));
% remove insignificant cmpts
isig = find(conf>=minconf);
fcar = fcar(isig);
% gaps of more than thrice minD cause the vector to split
N = length(fcar);
dd = diff(fcar);
isplit = [0; find(dd>=3*minD); N];
[gf, index] = deal({});
Ngroup = 0;
groupLen = [];
for ii=1:length(isplit)-1,
   istart = isplit(ii)+1;
   iend = isplit(ii+1);
   if (iend-istart+1)>=Nmingroup,
      Ngroup = Ngroup + 1;
      index{Ngroup} = isig(istart:iend); % original indices of fcar
      gf{Ngroup} = fcar(istart:iend);
      groupLen(Ngroup) = iend-istart+1;
   end
end








