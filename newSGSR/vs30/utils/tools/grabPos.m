function grapPos(h);
% grabPos - grab position of figure and display command to position it

if nargin<1, h = gcf; end

pp=get(h,'position');
pstr = trimspace(num2str(round(pp)));
disp(['set(gcf,''position'', [' pstr '])']);


   
