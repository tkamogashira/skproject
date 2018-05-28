function [plotter, ds, params, ymax] = HistPlotAppData(figh);
% HistPlotAppData - get AppData stored in HistPlot figure

IamShowing = getUIprop(figh,'Iam.showing');
plotter = IamShowing.dataplotfnc;
ds = IamShowing.ds;
params = IamShowing.params;

if isfield(IamShowing, 'ymax'), 
   ymax = IamShowing.ymax; 
else,
   ymax = NaN;
end;