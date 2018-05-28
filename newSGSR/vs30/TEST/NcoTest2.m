function Ncoin = NcoTest2(ds, isub, binwidth, dur);
% NcoFast2 - 2nd variant of quick & dirty coincidence count

if isa(ds,'dataset'),
   if nargin<4, dur = ds.burstdur; end
   SPT = anwin(ds,[0 dur],0,isub); % [o dur]=analysis window; 0=all reps
elseif iscell(ds),
   SPT = ds;
   if ~isempty(isub), SPT=SPT(isub,:); end
end

% pool all spikes right away
SPT = [SPT{:}];
SPTsort = sort(SPT);
Nspike = length(SPT);
Ncoin = 0; Ncoinw = 0;
ncwithin = 1; % dummy value to force chlecking the first time
for ishift=1:Nspike-1,
   ncs = length(find(abs(SPTsort(ishift+1:Nspike)-SPTsort(1:Nspike-ishift))<=binwidth));
   if ncwithin>0, % count coincidences within reps in order to exclude them from coincidence count
      ncwithin = length(find(abs(SPT(ishift+1:Nspike)-SPT(1:Nspike-ishift))<=binwidth));
   end
   if (ncwithin<1) & (ncs<1), break; end
   Ncoin = Ncoin+ncs-ncwithin;
end


