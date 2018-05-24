%** pstshotaro.mco
%** RAP macro to plot several panels for responses to short (25 ms) tones
%** PXJ and SK '08/9/12
%**

for n=1:length(D)
    rapcmd(['df ' D(n).ds1.filename])
    rapcmd('SYNC MAN')
    rapcmd(['id ' D(n).ds1.seqid])
    %** page 1: plots across SPL
    rapcmd('pp x 3');
    rapcmd('pp y 2');
    %* plot rate, dot raster etc. for entire duration
    %* RATE CURVE
    rapcmd('ou sp');
    %* DOT RASTER
    rapcmd('lw ras 1');
    rapcmd('col aw t');
    rapcmd('ou ras');
    %* PEAK LATENCY
    rapcmd('set pkl srw 50 100');
    rapcmd('ou pkl');
    %* get peak latency at highest SPL
    rapcmd('gv v5 xmax');
    rapcmd('rr x v5 v5');
    rapcmd('nl pkl');
    rapcmd('gv v6 yvar');
    rapcmd('rr def');
    %* SYNC: R AND PHASE
    rapcmd('aw 10 25');
    %* still implement: cyclint yes
    %* min is 0.5
    rapcmd('ou sy');
    rapcmd('ou ph');
    %* P/K RATIO **** temporary try
    rapcmd('bw 0.1');
    rapcmd('v7 5');
    %* v7 is a dummy to add and subtract a couple of ms from v6
    rapcmd('v8 v6+v7');
    rapcmd('aw v6 v8');
    rapcmd('nl sp');
    rapcmd('gv v1 xvar');
    rapcmd('gv v2 yvar');
    rapcmd('aw v8 25');
    rapcmd('nl sp');
    rapcmd('gv v3 yvar');
    rapcmd('v2 / v3');
    rapcmd('ou scp v1 v2');
    %*
    %*
    %* page 2: PSTHs
    rapcmd('xm 35');
    rapcmd('aw 0 35');
    rapcmd('bw 0.1'); 
    %* (same bw as Blackburn & Sachs, a little coarser than nb 500, which gives bw 0.7 for 35 ms pst)
    rapcmd('col aw t');
    rapcmd('pp x 5');
    rapcmd('pp y 3');
    %* to do: calculate # mistriggers, put with SPL
    rapcmd('ou pst');
    rapcmd('xm def');
    rapcmd('nb def');
    rapcmd('pp def');
    rapcmd('aw def');
    rapcmd('min is 0');
    rapcmd('return');
end;