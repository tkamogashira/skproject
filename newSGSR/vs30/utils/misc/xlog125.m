function xlog125(XL,XL2)
% XLOG125 - set X-Axis to log and use decent labels a la .. 1 2 5 ..
%   xlog125 sets x-axis of current axes to log and used labels 1 2 5 etc.
%
%   xlog125([xmin, xmax]) or xlog125(xmin, xmax) also sets the X-limits.
%
%   See also YLOG125 XLIM.

if nargin<1
    setLim = 0;
else
    setLim=1;
end

set(gca,'xscale','log');
TL = [1;2;5]*10.^(-5:8);
TL = TL(:);
if setLim
   if nargin>1
       XL = [XL XL2];
   end
else
   XL = xlim;
end
if length(XL)<2
    XL(2)=inf;
end
xlim(XL);
TL = TL((TL>=XL(1))&(TL<=XL(2)));
set(gca,'xtick',TL, 'XMinorTick', 'off');
figure(gcf);
