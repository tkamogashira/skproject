function posistr(h);
% posistr - string for positioning window like current winow

if nargin<1, h=gcf; end

pos = round(get(h,'position'));
disp(['set(gcf,''position'', [' trimspace(num2str(pos)) ']);'])