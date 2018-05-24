% OSCR paper
% Fig. 8: example of OSCOR response with peak-doubling

% PXJ 2005/4

% assemble structure with datapoints
D6 = struct([]);
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.05 0.05 0.90 0.90]);

DF = 'R95060';


% Column A left: column shows responses to A/ABx stimuli binned at fr
dsID = '11-8-OSCR'; 
ds = maddataset(DF, dsID); 
T = EvalOSCOR(ds,'Nbin',32, 'binfreq', -1)
T.THR.CF = 2197;
T.Tag = [0 1 3 4 7];
D6 = [D6, T];
Fig1 = gcf; 
HdlAL2   = getplot(Fig1, 6);
HdlAL10  = getplot(Fig1, 8);
HdlAL75 = getplot(Fig1, 11);
HdlAL200 = getplot(Fig1, 14);


% Column A right: column shows responses to A/ABx stimuli binned at 2fr
dsID = '11-8-OSCR'; 
ds = maddataset(DF, dsID); 
T = EvalOSCOR(ds,'Nbin',32, 'binfreq', -2)
T.THR.CF = 2197;
T.Tag = [0 1 3 4 7];
D6 = [D6, T];
Fig2 = gcf; 
HdlAR2   = getplot(Fig2, 6);
HdlAR10  = getplot(Fig2, 8);
HdlAR75 = getplot(Fig2, 11);
HdlAR200 = getplot(Fig2, 14);


% Control stimulus for panel C (sync curves) 
dsID = '11-21-OSCRCTL';
ds = maddataset(DF, dsID); 
T = EvalOSCOR(ds, 'plot', 'n'); %pause; close;
T.THR.CF = 2197;
T.Tag = [0 1 3 4 7];
D6 = [D6, T];


% Panel B: Noise-delay functions

%Plot A: ND-functions --------------------------------
ds1 = dataset('R95060', '11-5-NITD');
ds2 = dataset('R95060', '11-6-NITD-');
ds3 = dataset('R95060', '11-6-NITD');
EvalNITD(ds1, ds2, ds3, 'plot', 'yes');
CurFig = gcf;
HdlH = GetPlot(CurFig, 1);
HdlH = copyobj(HdlH, FigHdl);
set(HdlH, 'Units', 'centimeters', 'Position', [8 9.5 3.2 3.5], ...
    'TickDir', 'out', 'TickLength', [.03 .07], 'LineWidth', 1, ...
    'FontUnits', 'points', 'FontSize', 10, ...
    'XLim', [-1500, 1500], 'XTick', -1500:500:1500, 'XTickLabel', {'','-1000','','0','','1000',''},...
    'YLim', [0 60], 'YTick', 0:20:60,'color','none');
%Original curve ...
set(findobj(HdlH, 'tag', 'fitnitdpcurve'), 'LineWidth', 2, 'LineStyle', '-', 'Marker', 'none', 'Color', 'k');
set(findobj(HdlH, 'tag', 'fitnitdncurve'), 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'none', 'Color', 'k');
set(findobj(HdlH, 'tag', 'orignitdccurve'), 'LineWidth', 1, 'LineStyle', '--', 'Marker', 'none', 'Color', 'k');
%delete line peakratio for ND+ ...
delete(findobj(HdlH, 'tag', 'nitdppeakratio'));
%Extending vertical lines ...
set(findobj(HdlH, 'tag', 'bestnitdpverline'), 'ydata', [0 60]);
set(findobj(HdlH, 'tag', 'verzeroline'), 'ydata', [0 60]);
%Removing peakratio line for ND- ...
delete(findobj(HdlH, 'tag', 'nitdnpeakratio')); 
%Removing vertical peak line for ND- ...
delete(findobj(HdlH, 'tag', 'bestnitdnverline')); 
%Removing orig curves ...
delete(findobj(HdlH, 'tag', 'orignitdpcurve')); 
delete(findobj(HdlH, 'tag', 'orignitdncurve')); 
%Removing correlation index markers ...
delete(findobj(HdlH, 'tag', 'corrindexpeakmarker'));
delete(findobj(HdlH, 'tag', 'corrindexintersectmarker'));
axes(HdlH); 
xlabel('Interaural Time Delay (ms)', 'FontUnits', 'points', 'FontSize', 10); 
ylabel('Firing Rate(spikes/s)', 'FontUnits', 'points', 'FontSize', 10);
title('', 'FontUnits', 'points', 'FontSize', 10);
%close(CurFig);


% Panel C: vector strength at fr, 2fr, and for controlstimulus
groupplot(D6(1), 'CALC.IndepVal', 'CALC.R', D6(2), 'CALC.IndepVal', 'CALC.R', D6(3), 'CALC.IndepVal', 'CALC.R', ...
    D6(1), 'CALC.IndepVal', 'CALC.R', D6(2), 'CALC.IndepVal', 'CALC.R', D6(3), 'CALC.IndepVal', 'CALC.R', ...
    'indexexpr', {'$CALC.Z$ < 6.91','$CALC.Z$ < 6.91','$CALC.Z$ < 6.91',...
        '$CALC.Z$ > -1','$CALC.Z$ > -1','$CALC.Z$ > -1'},...
    'infofields', {'DS.FileName','DS.SeqID','StimParam.SPL'},...
    'colors',{'k'},'markers',{'of','sf','^f','o','s','^'},'linestyles',{'none','none','none','-','-','-'},'xlim', [0 500], 'ylim', [0 0.4]);
Fig4 = gcf;
HdlA = getplot(Fig4, 2);
HdlA = putplot(FigHdl, HdlA, 1, 3, 2);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'XScale', 'log','Xtick',[1 10 100],'XLim', [1 500], ...
    'Ytick',[0:0.1:0.4], 'Units', 'centimeters', 'Position', [8 6 3.2 2.2],'color','none');
axes(HdlA); xlabel('Oscillation Frequency f_r (Hz)','Fontunits','points','Fontsize',10); ylabel('R','Fontunits','points','Fontsize',10');
Hdls = get(HdlA, 'Children');
set(Hdls, 'linewidth', 1, 'markersize', 5);
box off;
%HdlC = getplot(Fig4, 2);

%Generating and formatting final plot ...

% column A, left
HdlAL2 = putplot(FigHdl, HdlAL2, 3, 5, 1);
set(HdlAL2, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'0','0.5','1'}, 'YtickLabel', [0:50:100], 'YLim', [0 100], 'Units', 'centimeters', 'Position', [3 6 1.5 2], 'box','off','color','none');
axes(HdlAL2); xlabel('\phi (cycle)','Fontunits','points','Fontsize',10); ylabel('Rate (spikes/s)','Fontunits','points','Fontsize',10);
set(findobj(HdlAL2, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAL2, 'type','text'));


HdlAL10 = putplot(FigHdl, HdlAL10, 3, 5, 2);
set(HdlAL10, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50], 'XtickLabel', {'','',''}, 'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [3 8 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAL10); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAL10, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAL10, 'type','text'));

HdlAL75 = putplot(FigHdl, HdlAL75, 3, 5, 3);
set(HdlAL75, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'','',''},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [3 10 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAL75); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAL75, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAL75, 'type','text'));

HdlAL200 = putplot(FigHdl, HdlAL200, 3, 5, 4);
set(HdlAL200, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'','',''},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [3 11.5 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAL200); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAL200, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAL200, 'type','text'));


% column A, right
HdlAR2 = putplot(FigHdl, HdlAR2, 3, 5, 6);
set(HdlAR2, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'0','0.5','1'},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [5 6 1.5 2], 'box','off','color','none');
axes(HdlAR2); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAR2, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAR2, 'type','text'));

HdlAR10 = putplot(FigHdl, HdlAR10, 3, 5, 7);
set(HdlAR10, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'','',''},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [5 8 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAR10); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAR10, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAR10, 'type','text'));

HdlAR75 = putplot(FigHdl, HdlAR75, 3, 5, 8);
set(HdlAR75, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'','',''},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [5 10 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAR75); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAR75, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAR75, 'type','text'));

HdlAR200 = putplot(FigHdl, HdlAR200, 3, 5, 9);
set(HdlAR200, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'Ytick',[0:50:100], 'XtickLabel', {'','',''},'YtickLabel', {'','',''},'YLim', [0 100], 'Units', 'centimeters', 'Position', [5 11.5 1.5 2], 'box','off','visible','off','color','none');
axes(HdlAR200); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10);
set(findobj(HdlAR200, 'type','patch'),'FaceColor', [0 0 0], 'EdgeColor', [0 0 0]);
delete(findobj(HdlAR200, 'type','text'));