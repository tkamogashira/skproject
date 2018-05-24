D1=D([5:length(D)]);

D_A=structfilter(D1,'strcmp($Evalisi$,''A'')');

D_B=structfilter(D1,'strcmp($Evalisi$,''B'')');

structplot(D_A,'CF','ac.max',D_B,'CF','ac.max',...
    'markers',{'o','o'}, 'Colors',{'k','b'})
structplot(D_A,'CF','diff.max',D_B,'CF','diff.max',...
    'markers',{'o','o'}, 'Colors',{'k','b'})

D_AB_high=structfilter(D1,'strcmp($Evalisi$,''C'')==0 & $highFreq$>20000');
D_AB_low=structfilter(D1,'strcmp($Evalisi$,''C'')==0 & $highFreq$<20000');

structplot(D_AB_high,'CF','ac.max',D_AB_low,'CF','ac.max',...
    'markers',{'o','o'}, 'Colors',{'r','b'})
structplot(D_AB_high,'CF','diff.max',D_AB_low,'CF','diff.max',...
    'markers',{'o','o'}, 'Colors',{'r','b'})

D_AB_new=structfilter(D1,'strcmp($Evalisi$,''C'')==0 & $highFreq$==15000 & $lowFreq$==50');
structplot(D_AB_new,'CF','ac.max','markers',{'o'}, 'Colors',{'k'})
structplot(D_AB_new,'CF','diff.max','markers',{'o'}, 'Colors',{'k'})
