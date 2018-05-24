
% CDCP.m
% PXJ 28 Nov 2007
% graph CD vs. CP, measured on binaural beat data
% compilation of BB data is same as in IC damping paper (Joris et al., J Neurophysiol, 2004)



BBF = structfilter(DBB, 'findelement($tag$,1)');
%Filter on SPL: between 50 and 70 dB
%BBF = structfilter(DBB, '$param.spl$ > 49');
%BBF = structfilter(BBF, '$param.spl$ < 71');
BBF = structfilter(BBF, '$rate.max$ > 10');
BBF = structfilter(BBF, '$vs.plinreg$ <= 0.001')

L=size(BBF);
for n=1:L(2)
    if (BBF(n).vs.cp >= -0.5)&(BBF(n).vs.cp < 0.5)
        BBF(n).cpm=BBF(n).vs.cp;
    else
        BBF(n).cpm=BBF(n).vs.cp-round(BBF(n).vs.cp);
    end;
end;


%structplot(BBF, 'vs.cp','vs.cd','markers', {'o'}, 'Colors',{'k'},'info','y','xlim', [0 3000], 'ylim', [0 12]);
structplot(BBF, 'cpm','vs.cd',...
    'markers','o','Colors','k','info','y',...
    'execevalfnc', 'evalbb(dataset($ds1.filename$, $ds1.iseq$))');
line([-1 1], [0 0], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');
line([0 0], [-1 2], 'LineStyle', ':', 'Color', 'k', 'Marker', 'none');

% plot best phase (here taken as phase of regression line of CD analysis, at CF)
structplot(BBF, 'thr.cf','($vs.cd$.*$thr.cf$)/1000 + $cpm$',...
    'markers','o', 'Colors','k','info','y',...
    'execevalfnc', 'evalbb(dataset($ds1.filename$, $ds1.iseq$))');
