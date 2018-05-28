function str = NthPlotArg(n);
% NthPlotArg returns different plot style arg string  for different n

LineStyles = {'-',':','-.','--'};
LineColors = 'bgrcm';

NS = length(LineStyles);
NC = length(LineColors);

Istyle = fix(n/NC);
Istyle = 1 + rem(Istyle,NS);
Icolor = 1+rem(n-1,NC);

str = [LineStyles{Istyle} LineColors(Icolor)];

