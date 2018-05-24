
% CDCP.m
% PXJ 28 Nov 2007
% graph CD vs. CP, measured on binaural beat data
% compilation of BB data is same as in IC damping paper (Joris et al., J Neurophysiol, 2004)

load popscriptBB;

BBF = structfilter(DBB, 'findelement($tag$,1)');
%Filter on SPL: between 50 and 70 dB
%BBF = structfilter(DBB, '$param.spl$ > 49');
%BBF = structfilter(BBF, '$param.spl$ < 71');
BBF = structfilter(BBF, '$rate.max$ > 10');
BBF = structfilter(BBF, '$vs.plinreg$ <= 0.001')
BBFw = structfilter(BBF, '$vs.cp$ > 0.5') % wrap by 1 cycle if CP > 0.5
BBFo = structfilter(BBF, '$vs.cp$ <= 0.5') % original data with CP <= 0.5
%structplot(BBF, 'vs.cp','vs.cd','markers', {'o'}, 'Colors',{'k'},'info','y','xlim', [0 3000], 'ylim', [0 12]);
structplot(BBFo, '$vs.cp$','vs.cd',BBFw, '$vs.cp$-1','vs.cd',...
    'markers', {'o','of'}, 'Colors',{'k','b'},'info','y',...
    'execevalfnc', 'evalbb(dataset($ds1.filename$, $ds1.iseq$))');
line([-1 1], [0 0], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
line([0 0], [-1 2], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');

% plot best phase (here taken as phase of regression line of CD analysis, at CF)
structplot(BBFo, 'thr.cf','($vs.cd$.*$thr.cf$)/1000 + $vs.cp$',...
    BBFw, 'thr.cf','($vs.cd$.*$thr.cf$)/1000 + $vs.cp$-1',...
    'markers', {'o','of'}, 'Colors',{'k','b'},'info','y',...
    'execevalfnc', 'evalbb(dataset($ds1.filename$, $ds1.iseq$))');
