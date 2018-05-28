function xdplot(varargin);
% xdplot - add plot with scaled x values to gca
% see also dplot, xplot

IH = ishold;
hold on;
dplot(varargin{:});
if~IH, hold off; end;

