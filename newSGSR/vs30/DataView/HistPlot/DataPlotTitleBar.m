function titleStr = DataPlotTitleBar(ds, isub, figh);
% DataPlotTitleBar - set title bar of dataplot window
if nargin<3, figh=nan; end;

if isequal(0,isub), isubstr = ''; 
elseif ischar(isub), isubstr = '';
else, isubstr = ['   subseqs ' num2sstr(isub,1)]; 
end;

plotter = getUIprop(figh,'Iam.showing.dataplotfnc');
Plotter = upper(plotter(3:end));

titleStr = [Plotter '  ---  ' ds.title isubstr];

if ishandle(figh), 
   set(figh, 'name', titleStr); 
end

