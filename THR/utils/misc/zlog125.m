function zlog125(YL,YL2);
% ZLOG125 - set Z-Axis to log and use decent labels a la .. 1 2 5 ..
%   zlog125 sets z-axis of current axes to log and used labels 1 2 5 etc.
%
%   zlog125([zmin, zmax]) or zlog125(zmin, zmax) also sets the Z-limits.
%
%   See also XLOG125, ZLIM.

if nargin<1, setLim = 0; else, setLim=1; end

set(gca,'zscale','log');
TL = [1;2;5]*10.^[-5:8];
TL = TL(:);
if setLim,
   if nargin>1, YL = [YL YL2]; end
else,
   YL = zlim;
end
if length(YL)<2, YL(2)=inf; end
zlim(YL);
%TL = TL((TL>=YL(1))&(TL<=YL(2)));
set(gca,'ztick',TL, 'YMinorTick', 'off');
figure(gcf);




