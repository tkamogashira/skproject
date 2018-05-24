
% MSOsenF2
% November 1 2007
% example of high-sync unit recorded in TB/SOC

% specify plotting maxima of ch and isi (based on TB response)
ymaxch = 5050;
ymaxis = 410;


% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.05 0.05 0.90 0.90]);

%Plot A: threshold curve --------------------------------------------------------------------------------------------------------------------

THR = struct('df',{},'cell',{},'DSID',{},'xvar',{},'yvar',{})

RAPCMD DF S0544
RAPCMD ID 39-2-THR
%RAPCMD SET TXT SSQ OFF
%RAPCMD SET TXT EXT OFF
RAPCMD NL TH
RAPCMD ES "THR" fname cellnr DSID xvar yvar 
RAPCMD ID 39-13-THR
%RAPCMD SET TXT SSQ OFF
%RAPCMD SET TXT EXT OFF
RAPCMD NL TH
RAPCMD ES "THR" fname cellnr DSID xvar yvar 

groupplot(THR, 'xvar', 'yvar',...
    'colors',{'k'}, 'markers',{'none'},'xlim', [100 10000], 'ylim', [0 80]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'Ytick',[0:10:80],'YtickLabel', {'0','','20','','40','','60','','80'},'Units', 'centimeters', 'Position', [2 12 4 4]);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('THRESHOLD (dB SPL)','Fontunits','points','Fontsize',10); 
line([2400 2400], [0 80], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'CF'); 
line([(1500-410) (1500+410)], [50 50], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'AM fc 1.5k fm 310'); 
line([1500], [50], 'LineStyle', '-', 'Color', 'g', 'Marker', 'o', 'markerfacecolor','g', 'linewidth', 1, 'markersize', 5, 'tag', 'AM fc 1.5k fm 310'); 
line([(2400-410) (2400+410)], [50 50], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'linewidth', 2, 'tag', 'AM fc 2.4k fm 310'); 
line([2400], [50], 'LineStyle', '-', 'Color', 'g', 'Marker', 'o', 'markerfacecolor','g', 'linewidth', 1, 'markersize', 5, 'tag', 'AM fc 2.4k fm 310'); 
line([400], [60], 'LineStyle', '-', 'Color', 'm', 'Marker', 'o', 'markerfacecolor','m', 'linewidth', 1, 'markersize', 5, 'tag', 'tone 300'); 
% SPL symbol colors for other panels
line([100], [20], 'LineStyle', '-', 'Color', 'k', 'Marker', 'o', 'markerfacecolor','k', 'markersize', 3); 
line([100], [30], 'LineStyle', '-', 'Color', 'b', 'Marker', 'o', 'markerfacecolor','b', 'markersize', 3); 
line([100], [40], 'LineStyle', '-', 'Color', 'c', 'Marker', 'o', 'markerfacecolor','c', 'markersize', 3); 
line([100], [50], 'LineStyle', '-', 'Color', 'g', 'Marker', 'o', 'markerfacecolor','g', 'markersize', 3); 
line([100], [60], 'LineStyle', '-', 'Color', 'm', 'Marker', 'o', 'markerfacecolor','m', 'markersize', 3); 
line([100], [80], 'LineStyle', '-', 'Color', 'r', 'Marker', 'o', 'markerfacecolor','r', 'markersize', 3); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);

if 0
%Plot B: DOT RASTERS ------------------------------------------------------

RAPCMD ID 39-30-FS
RAPCMD RR X 600 600
RAPCMD OU RAS
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);

HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Units', 'centimeters', 'Position', [1 15 6 5], ...
    'TickDir', 'out', 'TickLength', [.03 .07], 'LineWidth', 1, ...
    'FontUnits', 'points', 'FontSize', 10, ...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'YScale', 'lin', 'YLim', [0 75], 'YTick', 0:25:75);
Hdls = get(HdlA, 'Children');
%Change original curve ...
set(Hdls(3), 'LineWidth', 1, 'Marker', 'none', 'MarkerSize', 3, 'MarkerFaceColor', 'none');
%Remove dot at CF and Q10-line ...
delete(Hdls([1:2]));
axes(HdlA); 
xlabel('Freq.(Hz)', 'FontUnits', 'points', 'FontSize', 10); 
ylabel('Thr.(dB)', 'FontUnits', 'points', 'FontSize', 10);
title('', 'FontUnits', 'points', 'FontSize', 10);

close(CurFig);
end
%inset: PST ------------------------------------------------------

RAPCMD ID 39-4-SPL
RAPCMD RR X 60 60
RAPCMD NB 500
RAPCMD COL HI k
RAPCMD YM 4000
RAPCMD OU PS
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);

HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Units', 'centimeters', 'Position', [10 16 2 3], ...
    'TickDir', 'out', 'TickLength', [.03 .07], 'LineWidth', 1, ...
    'FontUnits', 'points', 'FontSize', 10, ...
    'XScale', 'lin', 'XLim', [0 35], 'XTick', 0:10:30, 'XTickLabel', [0, 10, 20, 30], ...
    'YScale', 'lin', 'YLim', [0 4000], 'YTick', 0:1000:4000);
Hdls = get(HdlA, 'Children');
%Change original curve ...
%set(Hdls(3), 'LineWidth', 1, 'Marker', 'none', 'MarkerSize', 3, 'MarkerFaceColor', 'none');
%Remove dot at CF and Q10-line ...
%delete(Hdls([1:2]));
axes(HdlA); 
xlabel('TIME (ms)', 'FontUnits', 'points', 'FontSize', 10); 
ylabel('RATE (spikes/sec)', 'FontUnits', 'points', 'FontSize', 10);
title('PST', 'FontUnits', 'points', 'FontSize', 10);

close(CurFig);

% COLUMN 1: rate curves to tones at different SPLs ================================================================================================




% top panel: first build structure with rate curves
RATESTB = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{})
RATELTB = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{})

RAPCMD DF S0544

% STB
% 60 dB
RAPCMD ID 39-30-FS
RAPCMD AW 5 30
RAPCMD NL SP
RAPCMD ES "RATESTB" fname cellnr DSID spl xvar yvar 

% LTB
% 1) 20 dB
RAPCMD ID 39-25-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 2) 30 dB
RAPCMD ID 39-23-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 3) 40 dB
RAPCMD ID 39-20-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 40 dB incomplete
%RAPCMD ID 39-22-FS
%RAPCMD NL SP
%RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 4) 50 dB
RAPCMD ID 39-24-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 5) 60 dB
RAPCMD ID 39-12-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 

% 6) 80 dB
RAPCMD ID 39-21-FS
RAPCMD NL SP
RAPCMD ES "RATELTB" fname cellnr DSID spl xvar yvar 


if 0
% groupplot including STB
groupplot(RATESTB, 'xvar', 'yvar', ...
    RATELTB([1]), 'xvar', 'yvar', ...
    RATELTB([2]), 'xvar', 'yvar', ...
    RATELTB([3]), 'xvar', 'yvar', ...
    RATELTB([4]), 'xvar', 'yvar', ...
    RATELTB([5]), 'xvar', 'yvar', ...
    RATELTB([6]), 'xvar', 'yvar', ...
    'colors',{'k','r','b','g','m','c','y'}, 'markers',{'o'},'xlim', [100 4000], 'ylim', [0 600]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'Ytick',[0:100:500],'YtickLabel', {'0','','','','','500'},'Units', 'centimeters', 'Position', [2 2 4 4]);
Hdls = get(HdlA, 'Children');
%set(Hdls(1), 'linewidth', 2, 'markersize', 5);
axes(HdlA); xlabel('FREQUENCY (Hz)','Fontunits','points','Fontsize',10); ylabel('FIRING RATE (spikes/s)','Fontunits','points','Fontsize',10); 
line([100:10:500], [100:10:500], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'diagonal'); 
line([2400 2400], [0 500], 'LineStyle', '-', 'Color', 'b', 'Marker', 'none', 'linewidth', 1, 'markersize', 3, 'tag', 'CF'); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);
end

% groupplot without STB
groupplot(RATELTB([1]), 'xvar', 'yvar', ...
    RATELTB([2]), 'xvar', 'yvar', ...
    RATELTB([3]), 'xvar', 'yvar', ...
    RATELTB([4]), 'xvar', 'yvar', ...
    RATELTB([5]), 'xvar', 'yvar', ...
    RATELTB([6]), 'xvar', 'yvar', ...
    'colors',{'k','b','c','g','m','r'}, 'markers',{'o'},'xlim', [100 10000], 'ylim', [0 510]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'Ytick',[0:100:500],'YtickLabel', {'0','','','','','500'},'Units', 'centimeters', 'Position', [2 2 4 4]);
Hdls = get(HdlA, 'Children');
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('FREQUENCY (Hz)','Fontunits','points','Fontsize',10); ylabel('FIRING RATE (spikes/s)','Fontunits','points','Fontsize',10); 
line([2400 2400], [0 510], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'markersize', 3, 'tag', 'CF'); 
line([100:10:500], [100:10:500], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'diagonal'); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);



% NOW SYNC FOR SAME DATASETS

% top panel: first build structure with sync curves
FINESYNCSTB = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{},'Ry',{})
FINESYNCLTB = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{},'Ry',{})

RAPCMD DF S0544

% STB
% 60 dB
RAPCMD ID 39-30-FS
RAPCMD AW 5 25
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCSTB" fname cellnr DSID spl xvar yvar V1

% LTB
% 1) 20 dB
RAPCMD ID 39-25-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 2) 30 dB
RAPCMD ID 39-23-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 3) 40 dB
RAPCMD ID 39-20-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 40 dB incomplete
%RAPCMD ID 39-22-FS
%RAPCMD NL SY
%RAPCMD GV V1 VSMRAYSIG
%RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 4) 50 dB
RAPCMD ID 39-24-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 5) 60 dB
RAPCMD ID 39-12-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

% 6) 80 dB
RAPCMD ID 39-21-FS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "FINESYNCLTB" fname cellnr DSID spl xvar yvar V1

if 0
% groupplot including STB
groupplot(FINESYNCSTB, 'xvar', 'yvar', ...
    FINESYNCLTB([1]), 'xvar', 'yvar', ...
    FINESYNCLTB([2]), 'xvar', 'yvar', ...
    FINESYNCLTB([3]), 'xvar', 'yvar', ...
    FINESYNCLTB([4]), 'xvar', 'yvar', ...
    FINESYNCLTB([5]), 'xvar', 'yvar', ...
    FINESYNCLTB([6]), 'xvar', 'yvar', ...
    'colors',{'k','b','c','g','m','r'}, 'markers',{'o'},'xlim', [100 10000], 'ylim', [0 1]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'Ytick',[0:0.1:1],'YtickLabel', {'0','','','','','0.5','','','','','1'},'Units', 'centimeters', 'Position', [2 7 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('VECTOR STRENGTH','Fontunits','points','Fontsize',10); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);
end


% groupplot without STB
groupplot(FINESYNCLTB([1]), 'xvar', 'yvar',FINESYNCLTB([1]), 'xvar', 'yvar', ...
    FINESYNCLTB([2]), 'xvar', 'yvar', FINESYNCLTB([2]), 'xvar', 'yvar',...
    FINESYNCLTB([3]), 'xvar', 'yvar', FINESYNCLTB([3]), 'xvar', 'yvar', ...
    FINESYNCLTB([4]), 'xvar', 'yvar', FINESYNCLTB([4]), 'xvar', 'yvar', ...
    FINESYNCLTB([5]), 'xvar', 'yvar', FINESYNCLTB([5]), 'xvar', 'yvar',...
    FINESYNCLTB([6]), 'xvar', 'yvar', FINESYNCLTB([6]), 'xvar', 'yvar', ...
    'indexexpr', {'($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)'},...
    'colors',{'k','k','b','b','c','c','g','g','m','m','r','r'}, ...
    'markers',{'of','none','of','none','of','none','of','none','of','none','of','none'},...
    'linestyles',{'none','-','none','-','none','-','none','-','none','-','none','-'},...
    'xlim', [100 10000], 'ylim', [0 1]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [100 10000], 'XTickLabel', [100, 1000, 10000], ...
    'Ytick',[0:0.1:1],'YtickLabel', {'0','','','','','0.5','','','','','1'},'Units', 'centimeters', 'Position', [2 7 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('VECTOR STRENGTH','Fontunits','points','Fontsize',10); 
line([2400 2400], [0 1], 'LineStyle', '-', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'markersize', 3, 'tag', 'CF'); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);

% now cycle histogram at 400 Hz, 60 dB
RAPCMD DF S0544
RAPCMD ID 39-12-FS
RAPCMD RR X 400 400
%RAPCMD SET TXT SSQ OFF
%RAPCMD SET TXT EXT OFF
RAPCMD HI OUT
RAPCMD HI SH m
RAPCMD COL HI k
RAPCMD HI YV RATE
RAPCMD NB 100
RAPCMD OU CH
RAPCMD GV V3 XVAR
RAPCMD GV V4 YVAR
RAPCMD EXP V3 XVAN
RAPCMD EXP V4 YVAN
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);

HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'XScale', 'lin','Xtick',[0:0.5:1],'XLim', [0 1], ...
    'Ytick',[0:1000:1000],'YLim', [0 ymaxch],'Units', 'centimeters', 'Position', [7 14 2 2]);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
title('AW 10 25 R =  ,  {\it\phi} =','Fontunits','points','Fontsize',12);
Hdls = get(HdlA, 'Children');
%Remove text information ...
delete(Hdls([1]));
%delete(Hdls([3:5]));
%axes(HdlA); 
%close(CurFig);


% COLUMN 2: rate curves to AM different SPLs, fc = 1.5 kHz =====================================================================

% top panel: first build structure with rate curves
RATE = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{})

RAPCMD DF S0544
% 30 dB
RAPCMD ID 39-27-LMS
RAPCMD RR X 10 760
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

% 50 dB
RAPCMD ID 39-28-LMS
RAPCMD RR X 10 760
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

% 70 dB
RAPCMD ID 39-29-LMS
RAPCMD RR X 10 760
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

groupplot(RATE([1]), 'xvar', 'yvar',...
    RATE([2]), 'xvar', 'yvar',...
    RATE([3]), 'xvar', 'yvar',...
    'colors',{'b','g','r'}, 'markers',{'v','o','^'},'xlim', [10 1000], 'ylim', [0 510]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [10 1000], 'XTickLabel', [10, 100, 1000], ...
    'Ytick',[0:100:500],'YtickLabel', {'0','','','','','500'},'Units', 'centimeters', 'Position', [7 2 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('MODULATION FREQUENCY f_m (Hz)','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
line([10:10:500], [10:10:500], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'diagonal'); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);

% NOW SYNC FOR SAME DATASETS

% top panel: first build structure with rate curves
ENVSYNC = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{},'Ry',{})

RAPCMD DF S0544
% 30 dB
RAPCMD ID 39-27-LMS
RAPCMD RR X 10 760
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1

% 50 dB
RAPCMD ID 39-28-LMS
RAPCMD RR X 10 760
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1

% 70 dB
RAPCMD ID 39-29-LMS
RAPCMD RR X 10 760
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1


groupplot(ENVSYNC([1]), 'xvar', 'yvar', ENVSYNC([1]), 'xvar', 'yvar',...
    ENVSYNC([2]), 'xvar', 'yvar', ENVSYNC([2]), 'xvar', 'yvar',...
    ENVSYNC([3]), 'xvar', 'yvar', ENVSYNC([3]), 'xvar', 'yvar',...
    'indexexpr', {'($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)'},...
    'colors',{'b','b','g','g','r','r'}, 'markers',{'vf','none','of','none','^f','none'},...
    'linestyles',{'none','-','none','-','none','-'},...
    'xlim', [10 1000], 'ylim', [0 1]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [10 1000], 'XTickLabel', [10, 100, 1000], ...
    'Ytick',[0:0.1:1],'YtickLabel', {'0','','','','','0.5','','','','','1'},'Units', 'centimeters', 'Position', [7 7 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
title('f_c = 1.5 kHz','Fontsize',10);
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);



% now cycle histogram at 410 Hz, 50 dB
RAPCMD DF S0544
RAPCMD ID 39-28-LMS
RAPCMD RR X 410 410
%RAPCMD SET TXT SSQ OFF
%RAPCMD SET TXT EXT OFF
RAPCMD HI OUT
RAPCMD HI SH g
RAPCMD COL HI k
RAPCMD HI YV RATE
RAPCMD NB 100
RAPCMD OU CH
RAPCMD GV V3 XVAR
RAPCMD GV V4 YVAR
RAPCMD EXP V3 XVAN
RAPCMD EXP V4 YVAN
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);

HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'XScale', 'lin','Xtick',[0:0.5:1],'XLim', [0 1], ...
    'Ytick',[0:1000:1000],'YLim', [0 ymaxch],'Units', 'centimeters', 'Position', [10 13 2 2]);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
title('AW 10 25 R =  ,  {\it\phi} =','Fontunits','points','Fontsize',12);
Hdls = get(HdlA, 'Children');
%Remove text information ...
delete(Hdls([1]));
%delete(Hdls([3:5]));
%axes(HdlA); 
%close(CurFig);





% COLUMN 3: rate curves to AM different SPLs, fc = 2.4 kHz =====================================================================

% top panel: first build structure with rate curves
RATE = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{})

RAPCMD DF S0544
% 30 dB
RAPCMD ID 39-17-LMS
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

% 50 dB
RAPCMD ID 39-18-LMS
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

% 70 dB
RAPCMD ID 39-19-LMS
RAPCMD NL SP
RAPCMD ES "RATE" fname cellnr DSID spl xvar yvar 

groupplot(RATE([1]), 'xvar', 'yvar',...
    RATE([2]), 'xvar', 'yvar',...
    RATE([3]), 'xvar', 'yvar',...
    'colors',{'b','g','r'}, 'markers',{'v','o','^'},'xlim', [10 1000], 'ylim', [0 510]);
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [10 1000], 'XTickLabel', [10, 100, 1000], ...
    'Ytick',[0:100:500],'YtickLabel', {'0','','','','','500'},'Units', 'centimeters', 'Position', [12 2 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
line([10:10:500], [10:10:500], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none', 'linewidth', 1, 'tag', 'diagonal'); 
title('','Fontsize',6,'interpreter','none');
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);

% NOW SYNC FOR SAME DATASETS

% top panel: first build structure with rate curves
ENVSYNC = struct('df',{},'cell',{},'DSID',{},'SPL',{},'xvar',{},'yvar',{},'Ry',{})

RAPCMD DF S0544
% 30 dB
RAPCMD ID 39-17-LMS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1

% 50 dB
RAPCMD ID 39-18-LMS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1

% 70 dB
RAPCMD ID 39-19-LMS
RAPCMD NL SY
RAPCMD GV V1 VSMRAYSIG
RAPCMD ES "ENVSYNC" fname cellnr DSID spl xvar yvar V1


groupplot(ENVSYNC([1]), 'xvar', 'yvar', ENVSYNC([1]), 'xvar', 'yvar',...
    ENVSYNC([2]), 'xvar', 'yvar', ENVSYNC([2]), 'xvar', 'yvar',...
    ENVSYNC([3]), 'xvar', 'yvar', ENVSYNC([3]), 'xvar', 'yvar',...
    'indexexpr', {'($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)',...
    '($Ry$ <=  0.001)','($Ry$ < 1)'},...
    'colors',{'b','b','g','g','r','r'}, 'markers',{'vf','none','of','none','^f','none'},...
    'linestyles',{'none','-','none','-','none','-'},...
    'xlim', [10 1000], 'ylim', [0 1]);

CurFig = gcf;
HdlA = GetPlot(CurFig, 2);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07],...
    'XScale', 'log', 'XLim', [10 1000], 'XTickLabel', [10, 100, 1000], ...
    'Ytick',[0:0.1:1],'YtickLabel', {'0','','','','','0.5','','','','','1'},'Units', 'centimeters', 'Position', [12 7 4 4]);
%set(Hdls(1), 'linewidth', 2, 'markersize', 3);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
title('f_c = 2.4 kHz','Fontsize',10);
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 2);
box off;
close(CurFig);



% now cycle histogram at 410 Hz, 30 dB
RAPCMD DF S0544
RAPCMD ID 39-18-LMS
RAPCMD RR X 410 410
%RAPCMD SET TXT SSQ OFF
%RAPCMD SET TXT EXT OFF
RAPCMD HI OUT
RAPCMD HI SH g
RAPCMD COL HI k
RAPCMD HI YV RATE
RAPCMD NB 100
RAPCMD OU CH
RAPCMD GV V3 XVAR
RAPCMD GV V4 YVAR
RAPCMD EXP V3 XVAN
RAPCMD EXP V4 YVAN
CurFig = gcf;
HdlA = GetPlot(CurFig, 2);

HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10, ...
    'TickDir', 'out', 'TickLength', [.03 .07], ...
    'XScale', 'lin','Xtick',[0:0.5:1],'XLim', [0 1], ...
    'Ytick',[0:1000:1000],'YLim', [0 ymaxch],'Units', 'centimeters', 'Position', [14 13 2 2]);
axes(HdlA); xlabel('','Fontunits','points','Fontsize',10); ylabel('','Fontunits','points','Fontsize',10); 
title('AW 10 25 R =  ,  {\it\phi} =','Fontunits','points','Fontsize',12);
Hdls = get(HdlA, 'Children');
%Remove text information ...
delete(Hdls([1]));
%delete(Hdls([3:5]));
%axes(HdlA); 
%close(CurFig);










if 0
% other panels: difcors to tones, decreasing level from top to bottom -------------------------------

% 35 dB (near threshold: tuning curve thr = 37 dB
dst = dataset(DF, '13-8'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'-8','','-4','','0','','4','','8'}, ...
    'Ylim', [-4 6], 'Ytick', [-4:2:4], 'YTickLabel', {'','','','',''},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 2 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('35', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);

% 40 dB
dst = dataset(DF, '13-5'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'','','','','','','','',''}, ...
    'Ylim', [-4 6], 'Ytick', [-4:2:4], 'YTickLabel', {'','','','',''},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 5 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('40', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);

% 50 dB
dst = dataset(DF, '13-4'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'','','','','','','','',''}, ...
    'Ylim', [-4 6], 'Ytick', [-4:2:4], 'YTickLabel', {'','','','',''},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 8 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('50', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);

% 60 dB
dst = dataset(DF, '13-6'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'','','','','','','','',''}, ...
    'Ylim', [-4 6], 'Ytick', [-4:2:4], 'YTickLabel', {'','','','',''},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 11 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('60', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);

% 70 dB
dst = dataset(DF, '13-7'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'','','','','','','','',''}, ...
    'Ylim', [-4 6], 'Ytick', [-4:2:4], 'YTickLabel', {'','','','',''},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 14 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('70', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);
end

if 0
% 80 dB
dst = dataset(DF, '13-14'); %Tone dataset ...
EvalCC(dst,'plot','yes'); %pause; %print; close;
FigCC = gcf; 
HdlA = getplot(FigCC, 4);
HdlA = copyobj(HdlA, FigHdl);
set(HdlA, 'Xlim', [-8 8], 'Xtick', [-8:2:8], 'XTickLabel', {'','','','','','','','',''}, ...
    'Ylim', [-3 4], 'Ytick', [-2:2:4], 'YTickLabel', {'','0','','4'},...
    'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickLength', [.02 .05], 'tickdir','out','Units', 'centimeters', 'Position', [8 17 3.5 2.5]);
axes(HdlA);
xlabel('', 'fontunits', 'points', 'fontsize', 12);
ylabel('', 'fontunits', 'points', 'fontsize', 12);
title('80', 'fontunits', 'points', 'fontsize', 12);
Hdls = get(HdlA, 'Children');
set(Hdls(2), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(3), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % vertical line halfwidth
set(Hdls(4), 'linewidth', 0.5, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % halfwidth line
delete(Hdls(5)); % line peakratio
delete(Hdls(6)); % horizontal at 0
delete(Hdls(7)); % vertical at 0 delay
set(Hdls(8), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(9), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Hilbert envelope
set(Hdls(10), 'linewidth', 1, 'Color', 'k','LineStyle','-','Marker', 'none','MarkerSize',7); % Difcor
delete(findobj(HdlA, 'type', 'text'));
close(FigCC);
end
