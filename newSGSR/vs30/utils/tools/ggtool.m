function y = ggtool(n, tt);

if ischar(n), n = str2num(n); end;
global GG;
if nargin<2,
   y = get(GG(n), 'tooltipstring');
else,
   set(GG(n), 'tooltipstring', tt);
end

figure(gcf); % show
   

   
