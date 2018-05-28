function y=menufigList;
% menufiglist - returns all names of *menu.fig files, i.e., stimmenu names available
global VERSIONDIR
sdir = [VERSIONDIR '\stimmenu\specific'];
ubs = lls([sdir '\*menu.fig']);
Nf = size(ubs,1); % # files found
y = cell(1,Nf);
for ii=1:Nf,
   tf = lower(ubs(ii,:));
   alq = findstr('menu.fig', tf)-1;
   y{ii} = tf(1:alq);
end