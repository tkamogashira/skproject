function y = ggstring(n, str, doFit);
if nargin<3, doFit=0; end
global GG;
if nargin<2,
   y = gget(n, 'String');
   return;
end

set(GG(n), 'string', str);
if doFit, ggfit(n); end

figure(gcf); % show
