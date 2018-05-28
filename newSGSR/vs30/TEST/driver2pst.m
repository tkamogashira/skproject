function CH = driver2pst(drf, refr, TotNspike);
% driver2pst - compute cycle histogram from driving function of poisson generator

if nargin<3, 
   TotNspike = 5e3;
end
maxTime = 600; % s max computation time

Nbin = length(drf); % #bin in cycle
CH = zeros(1,Nbin); % cycle histogram
tic;
Nspike = 0;
ibin = 0;
while 1,
   ibin = 1 + rem(ibin, Nbin);
   if rand<drf(ibin), % spike occurs
      Nspike = Nspike + 1;
      CH(ibin) = CH(ibin)+1;
      ibin = ibin + refr; 
   end
   if Nspike>=TotNspike, break; end;
end




