function dataPlotParam(figh, keyword);
% dataPlotParam - launch parameter dialog for dataplot

if nargin<2, keyword = 'current'; end % set params for current view only
keyword = ['init' keyword];

plotter = getUIprop(figh, 'Iam.showing.dataplotfnc');
plotparamfnc = [plotter 'Param'];

eval([plotparamfnc '(''' keyword ''', figh);' ]);



