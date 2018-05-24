
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

%structplot(DBB, 'vs.cp','vs.cd','markers', {'o'}, 'Colors',{'k'},'info','y','xlim', [0 3000], 'ylim', [0 12]);
structplot(DBB, 'vs.cp','vs.cd','markers', {'o'}, 'Colors',{'k'},'info','y');
line([-1 1], [0 0], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
line([0 0], [-1 2], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');

% plot best phase (here taken as phase of regression line of CD analysis, at CF)
structplot(DBB, 'thr.cf','($vs.cd$.*$thr.cf$)/1000 + $vs.cp$','markers', {'o'}, 'Colors',{'k'},'info','y');
