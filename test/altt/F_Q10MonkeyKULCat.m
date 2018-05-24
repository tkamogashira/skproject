
% F_Q10MonkeyKULCat.m

% PXJ 08/2009
% based on PXJ_F_Q10MonkeyMadCat.m  -- Plots monkey and KUL cat THR Q10 values on top of each other.
% Monkeys are red; Cats are blue.

FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.05 0.05 0.90 0.90]);

%---------------------------------------------------------------------------------------------
% load monkey data
load psTHR10MONKEY.mat DTHR

% datasets with tag 1
D10THR = structfilter(DTHR, 'findelement($tag$, 1)');

% filter for fibers with thr < (group minimum + 30)
D10THR = structfilter(D10THR,'$thr.minthr$<$GROUP_BTC.SPL$+30');

% Separate into 2 SR groups
LowMSR = structfilter(D10THR, '$thr.sr$ <= 20');
HighMSR = structfilter(D10THR, '$thr.sr$ > 20');


%---------------------------------------------------------------------------------------------
%load cat data
load psTHR10KULCAT.mat CTHR

% datasets with tag 1
C10THR = structfilter(CTHR, 'findelement($tag$, 1)');

% filter for fibers with thr < (group minimum + 30)
C10THR = structfilter(C10THR,'$thr.minthr$<$GROUP_BTC.SPL$+30');

% Separate into 2 SR groups
LowCSR = structfilter(C10THR, '$thr.sr$ <= 20');
HighCSR = structfilter(C10THR, '$thr.sr$ > 20');


%---------------------------------------------------------------------------------------------
%Plot of Q10dB vs CF for Monkey and Cat with 3 spont rate divisions
%groupplot(LowCSR, 'fit.cf', 'fit.q10', MedCSR, 'fit.cf', 'fit.q10', HighCSR, 'fit.cf', 'fit.q10',...
%    LowMSR, 'fit.cf', 'fit.q10', MedMSR, 'fit.cf', 'fit.q10', HighMSR, 'fit.cf', 'fit.q10',...
%    'colors', {'b','b','b','r','r','r'},'markers',{'v','+','o'},'infofields',{'ds.filename','ds.seqid','fit.cf',...
%     'fit.minthr', 'thr.sr', 'fit.bw','fit.q10'},'dispstats','no','execevalfnc','EvalTHR(dataset($ds.filename$, $ds.seqid$');

%Plot of Q10dB vs CF for Monkey and Cat with 2 spont rate classes
groupplot(LowCSR, 'fit.cf', 'fit.q10', HighCSR, 'fit.cf', 'fit.q10',...
    LowMSR, 'fit.cf', 'fit.q10', HighMSR, 'fit.cf', 'fit.q10',...
    'colors', {'b','b','r','r'},'markers',{'vw','+','vw','+'},...
    'infofields',{'ds.filename','ds.seqid','fit.cf','fit.minthr', 'thr.sr', 'fit.bw','fit.q10'},...
    'dispstats','yes','execevalfnc','EvalTHR(dataset($ds.filename$, $ds.seqid$))');
set(gca, 'tickdir', 'out','xscale','log','TickLength', [.01 .03],...
    'Xtick',[100 1000 10000 100000],'XtickLabel', {'0.1','1','10','100'},...
    'Ytick',[0 5 10 15 20 25], 'xlim',[100 100000],'ylim',[0 25]);
title('KUL Cats vs. Monkeys Q_1_0_d_B vs Frequency','Fontunits','points','Fontsize',12);
xlabel('CF (kHz)','Fontunits','points','Fontsize',10);
ylabel('Q_1_0_d_B','Fontunits','points','Fontsize',10);


fig1 = gcf;
HdlA = getplot(gcf, 3);
HdlA = putplot(FigHdl, HdlA, 1, 1, 1);

%hold off;
axes(HdlA);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 10,...
    'TickDir', 'out', 'TickLength', [.03 .06], 'xscale','log','XLim', [100 50000],...
    'Xtick',[100 1000 10000],'XtickLabel', {'0.1','1','10'},...
    'YLim', [0 25],'Ytick',[0:5:25],'color','none','Units', 'centimeters', 'Position', [3 3 10 10]);
xlabel('CF (kHz)','Fontunits','points','Fontsize',14); ylabel('Q_1_0_d_B','Fontunits','points','Fontsize',14); title(''); 
h=legend([HdlA], 'SR < 20 Monkey', 'SR > 20 Monkey','SR < 20 Cat', 'SR > 20 Cat',2);
Hdls = get(HdlA, 'Children');
set(Hdls, 'linewidth', 1, 'markersize', 7);
box off;
hold on;

plotinfo;
