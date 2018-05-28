function ylog125(YL,YL2)
% YLOG125 - set Y-Axis to log and use decent labels a la .. 1 2 5 ..
%   ylog125 sets y-axis of current axes to log and used labels 1 2 5 etc.
%
%   ylog125([ymin, ymax]) or ylog125(ymin, ymax) also sets the Y-limits.
%
%   See also XLOG125, YLIM.

if nargin<1
    setLim = 0;
else
    setLim=1;
end

set(gca,'yscale','log');
TL = [1;2;5]*10.^(-5:8);
TL = TL(:);
if setLim
   if nargin>1
       YL = [YL YL2];
   end
else
   YL = ylim;
end
if length(YL)<2
    YL(2)=inf;
end
ylim(YL);
TL = TL((TL>=YL(1))&(TL<=YL(2)));
set(gca,'ytick',TL, 'YMinorTick', 'off');
figure(gcf);
