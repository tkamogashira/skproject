function Ncoin = NcoTest(ds, isub, binwidth, dur);
% NcoFast - quick & dirty coincidence count

if isa(ds,'dataset'),
   SPT = anwin(ds,[],0,isub); % []=burstdur analysis window; 0=all reps
   if nargin<4, dur = ds.burstdur; end
elseif iscell(ds),
   SPT = ds;
   if ~isempty(isub), SPT=SPT(isub,:); end
end


ebw = 2*binwidth;
Nrep = length(SPT);
Nbin = 1+ceil(dur/ebw);

binCounts = zeros(1,Nbin);
for irep=1:Nrep,
   ibin = 1+round(SPT{irep}/ebw);
   binCounts(ibin) = binCounts(ibin) + 1;
end

Ncoin = sum(0.5*(binCounts-0.5).^2-0.125);




