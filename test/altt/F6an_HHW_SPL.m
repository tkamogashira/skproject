% ND vs CC AN paper
% PXJ 2004/9

% Fig. 6 ---------------------------------------------------------------------------------------------------------------------------------------
%   X: suprathreshold SPL
%   Y: halfwidth for noise and for tones

% Create template
FigHdl = figure('PaperType', 'A4', 'PaperOrientation','Portrait','PaperUnits','Normalized','PaperPosition', [0.05 0.05 0.90 0.90]);

% panel A: halfwidths for noise (HWnd) as a function of effective SPL or suprathreshold SPL ------------------------------
%load 'C:\Documents and Settings\RealGeek\My Documents\DO\NDvsCC\NDvsCCan\psSACXAC';
load 'C:\Documents and Settings\u0015721\My Documents\ZIP\2005 2008 NDvsCC\NDvsCCan\psSACXAC';

%DNTD = structfilter(DNTD, 'findelement($tag$,1) | findelement($tag$,2)');
DSACXAC = structfilter(DSACXAC, '~isnan($diff.hhw$)');
DSACXAC = structfilter(DSACXAC, 'findelement($tag$,1)');

DSACXAC = structsort(DSACXAC, 'stim.effspl');

if 0
    
% filter cells with only 1 datapoint out
    TBL = DSACXAC; Fields = {'ds1.filename', 'ds1.icell', 'stim.effspl'};

TBL    = structsort(TBL, Fields);
FNames = structfield(TBL, Fields{1});
CNrs   = structfield(TBL, Fields{2});
SPLs   = structfield(TBL, Fields{3});

[dummy, idx] = unique([char(FNames), num2str(CNrs)], 'rows');
Inc = diff([0; idx]); iidx = find(Inc > 1);
Inc = Inc(iidx);
idx = idx(iidx);
tmp = []; for n = 1:length(Inc), tmp = [tmp, (-Inc(n)+1):1:0]; end
idx = mmrepeat(idx, Inc) + tmp';

TBL = TBL(idx); cv2str(TBL);
DSACXAC = TBL;

end

DSACXAClo = structfilter(DSACXAC, '($thr.sr$ < 18) & ($thr.cf$ < 3000)');
DSACXAChi = structfilter(DSACXAC, '($thr.sr$ > 18) & ($thr.cf$ < 3000)');

if 0 
% A: plot for effective spl
structplot(DSACXAClo, 'stim.effspl','diff.hhw', DSACXAChi, 'stim.effspl','diff.hhw', ...
    'markers', {'^', '+'}, 'Colors',{'k','k'},'info','y','xlim', [-10 80], 'ylim', [0 14]);
title(mfilename, 'interpreter', 'none');
Fig1 = gcf;
HdlA = getplot(Fig1, 2);
HdlA = putplot(FigHdl, HdlA, 1, 2, 1);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickDir', 'out', 'TickLength', [.015 .05], 'Ytick',[0:2:12], 'Units', 'centimeters', 'Position', [3 10.5 7 5]);
axes(HdlA); xlabel('Effective SPL (dB)','Fontunits','points','Fontsize',14); ylabel('HW_N_D (ms)','Fontunits','points','Fontsize',14); 
Hdls = get(HdlA, 'Children');
set(Hdls, 'linewidth', 1, 'markersize', 5, 'color','k');
box off;
%close(Fig1);
end



% filter to "isolate" cell C0305-20
%DNTDone = structfilter(DNTD, 'strcmpi($ds1.filename$,''C0305'') & ($ds1.icell$ == 20)'); 
%DNTDrest = structfilter(DNTD, '~strcmpi($ds1.filename$,''C0305'') | ($ds1.icell$ ~= 20)'); 

% plot: choose A1 or A2
% A: plot for suprathreshold level for noise
DSACXAClo = structfilter(DSACXAClo, '~isnan($rcn.thr$)');
DSACXAChi = structfilter(DSACXAChi, '~isnan($rcn.thr$)');
structplot(DSACXAClo, 'getcolumn($stim.spl$, 1) - $rcn.thr$','diff.hhw', ...
    DSACXAChi, 'getcolumn($stim.spl$, 1) - $rcn.thr$','diff.hhw', ...
    'markers', {'^', '+'}, 'Colors',{'k','k'},'info','y','xlim', [-10 60], 'ylim', [0 14]);
title(mfilename, 'interpreter', 'none');
Fig1 = gcf;
HdlA = getplot(Fig1, 2);
HdlA = putplot(FigHdl, HdlA, 1, 2, 1);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickDir', 'out', 'TickLength', [.015 .05], 'Ytick',[0:2:12], 'Units', 'centimeters', 'Position', [3 10.5 7 5]);
axes(HdlA); xlabel('Suprathreshold SPL (dB)','Fontunits','points','Fontsize',14); ylabel('HW_N (ms)','Fontunits','points','Fontsize',14); 
Hdls = get(HdlA, 'Children');
set(Hdls, 'linewidth', 1, 'markersize', 5, 'color','k');
box off;

% number of points
fprintf('Noise: total number of datapoints = %d\n',length(DSACXAC));
fprintf('Noise: number of datapoints low-SR = %d\n',length(DSACXAClo));
fprintf('Noise: number of datapoints high-SR = %d\n',length(DSACXAChi));

% panel B: halfwidths for tones (HWcc) as a function of SPL --------------------------------------------------
load 'C:\Documents and Settings\RealGeek\My Documents\DO\NDvsCC\NDvsCCan\psFSCC';
DFSCC = structsort(DFSCC, 'stim.spl');

% filter cells with only 1 datapoint out: these are the datasets with tag 5
%DBB = structfilter(DFSCC, 'findelement($tag$,5)');

% remove duplicate datasets at same SPL: these are the datasets with tag 4
DFSCC = structfilter(DFSCC, '~findelement($tag$,4)');

% filter to "isolate" cell C0220-1
%DBBone = structfilter(DBB, 'strcmpi($ds1.filename$,''C0220'') & ($ds1.icell$ == 1)'); 
%DBBrest = structfilter(DBB, '~strcmpi($ds1.filename$,''C0220'') | ($ds1.icell$ ~= 1)'); 


DFSCClo = structfilter(DFSCC, '($thr.sr$ < 18) & ($thr.cf$ < 3000)');
DFSCChi = structfilter(DFSCC, '($thr.sr$ > 18) & ($thr.cf$ < 3000)');

% plot
%structplot(DBBrest, 'param.spl','diff.hhw', DBBone, 'param.spl','diff.hhw',...
%    'markers', {'o','of'}, 'Colors',{'k'}, 'info','y','xlim', [10 90], 'ylim', [0 12]);
structplot(DFSCClo, '$stim.spl$ - $thr.thr$','diff.hhw', DFSCChi, '$stim.spl$ - $thr.thr$','diff.hhw', ...
    'markers', {'^', '+'}, 'Colors',{'k','k'}, 'info','y','xlim', [-10 60], 'ylim', [0 14]);
Fig2 = gcf;
HdlA = getplot(Fig2, 2);
HdlA = putplot(FigHdl, HdlA, 1, 2, 2);
set(HdlA, 'linewidth', 1, 'FontUnits', 'Points', 'FontSize', 12, ...
    'TickDir', 'out', 'TickLength', [.015 .05], 'Ytick',[0:2:12], 'Units', 'centimeters', 'Position', [3 5 7 5]);
axes(HdlA); xlabel('suprathreshold level (dB)','Fontunits','points','Fontsize',14); ylabel('HW_T (ms)','Fontunits','points','Fontsize',14); 
Hdls = get(HdlA, 'Children');
%set(Hdls, 'linewidth', 1, 'markersize', 5, 'Marker', 'o');
set(Hdls, 'linewidth', 1, 'markersize', 5, 'color','k');
box off;
%close(Fig2);


% number of points
fprintf('Tones: total number of datapoints = %d\n',length(DFSCC));
fprintf('Tones: number of datapoints low-SR = %d\n',length(DFSCClo));
fprintf('Tones: number of datapoints high-SR = %d\n',length(DFSCChi));
