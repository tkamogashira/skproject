function InitPlot(h,PlotInfo, maxY);

% function InitPlot(h,PlotInfo); XXX
% how to make sure plotting is directed to correct axes?

minX = min(PlotInfo.varValues(:,1));
maxX = max(PlotInfo.varValues(:,1));

% ax = axes('position', [0.2 0.2 0.7 0.6]);
% axis([minX maxX 0 maxY]);
% use dummy plot for flexible scaling
% disp('initPlot')
plot([minX maxX],[0 maxY],'wx');
set(gca, 'XScale', PlotInfo.XScale);
xlabel(PlotInfo.xlabel);
ylabel('Spikes/s');

