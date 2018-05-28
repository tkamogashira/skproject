function V = KnotVol(r,dist,doPlot);
% KnotVol - knot volume

if nargin<3, doPlot=0; end

if length(dist)>1,
   V = [];
   for ii=1:length(dist),
      dd = dist(ii);
      v = KnotVol(r,dd);
      V = [V, v];
   end
   if doPlot,
      %contourf(sign(V),3);
      surface(sign(V),'edgecolor','none')
      figure(gcf);
   end
   return
end

N = size(r,1);
dr1 = diff(r);
r1 = r(1:N-1,:); % remove last=first

dist = mod(dist,1);
Nshift = 1+round(dist*N);

r2 = r1([Nshift:end 1:Nshift-1],:);
dr2 = dr1([Nshift:end 1:Nshift-1],:);

qq = cross(localRealize(dr1),localRealize(dr2));
V = dot(localRealize(r1-r2),qq,2);

%DD=0:0.01:1; for ii=1:length(DD), V=knotvol(r,DD(ii)); pl=find(V>0); mi=find(V<0); xplot(pl,0*pl+ii,'g*'); xplot(mi,0*mi+ii,'r*'); drawnow; end;

%=======
function r = localRealize(r);
r = [real(r(:,1)) imag(r(:,1)) r(:,2)];


