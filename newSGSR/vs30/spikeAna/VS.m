function VS(FN,ID, RC);
% VS - plot vector strength 
%   stars are significant

if nargin<2, ID=''; end;
if isempty(ID), 
   ds = FN;
   else,
      ds = dataset(FN,ID);
   end
if nargin<3, RC = 0.01; ;end;

SPT = ds.spt;
for isub=1:ds.nsub,
   spt = cat(2,SPT{isub,:});
   fmod = ds.fmod;
   if isnan(fmod), error('no modulation frequency defined'); end;
   fmod = fmod(min(end,isub));
   [R(isub) alpha(isub)] = vectorstrength(spt,fmod);
   R = abs(R);
end

plot(ds.xval,R(:));

RR = R; RR(find(alpha>RC)) = nan;
xplot(ds.xval,RR(:),'*')
RR = R; RR(find(alpha<=RC)) = nan;
xplot(ds.xval,RR(:),'o')
title(ds.title);
xlabel(ds.xlabel);
ylabel('vector strength');
ylim([0 1]);

