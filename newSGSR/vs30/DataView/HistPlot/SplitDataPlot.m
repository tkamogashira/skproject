function SplitDataPlot(h, showall);
% SplitDataPlot - split dataplot in two figures or unsplit

if nargin<2, showall=0; end;

% retrieve ds and view params from plotdata figure
ds = getUIprop(h,'Iam.showing.ds');
param = getUIprop(h,'Iam.showing.params');
Ymax = getUIprop(h, 'Iam.showing.Ymax');
plotter = getUIprop(h, 'Iam.showing.dataplotfnc');

if showall,
   param.Ymax = 'auto';
   param.iSub = 0;
   eval([plotter '(''plot'', h, ds, [], param);']) % plot to existing figure
   return;
end

% fix Ymax
param.Ymax = Ymax;
% split the parameter set in two
par1 = param; 
par2 = param; 
iSub = ExpandIsub(param.iSub, ds);
Nsub = length(iSub); if Nsub==1, return; end;
N1 = round(Nsub/2);
par1.iSub = iSub(1:N1);
par2.iSub = iSub(N1+1:Nsub);

oldpos = get(h, 'position');
eval([plotter '(''plot'', h, ds, [], par1);']) % existing figure
set(h,'position', oldpos);
eval([plotter '(''plot'', nan, ds, [], par2);'])  % new figure
set(gcf,'position', oldpos+[20 -20 0 0]);



