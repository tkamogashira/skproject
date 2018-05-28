function StoreInDataPlot(figh, ds, params, plotter, ymax, varargin)
% StoreInDataPlot - store application data in dataplot
if nargin<5, ymax = nan; end;
setUIprop(figh, 'Iam.showing.ds', ds);
setUIprop(figh, 'Iam.showing.params', params);
setUIprop(figh, 'Iam.showing.dataplotfnc', plotter);
setUIprop(figh, 'Iam.showing.Ymax', ymax); % inelegant but needed for splitting plots
N = length(varargin);
ii = 1;
while ii<N,
   fn = ['Iam.showing.' varargin{ii}];
   setUIprop(figh, fn, varargin{ii+1});
   ii=ii+2;
end




