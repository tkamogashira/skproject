%** pstshotaro.mco
%** RAP macro to plot several panels for responses to short (25 ms) tones
%** PXJ and SK '08/9/12
%**
echo on;
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
    rapcmd('gv v4 valmax');
    
    %save the maximal rate
    rapcmd('exp v4 "maxrate"');
    D(n).maxrate=maxrate;
    clear maxrate;
    
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
    
    %save the peak latency for the maximal spl
    rapcmd('exp v6 "last_pkl"');
    D(n).last_pkl=last_pkl;
    clear last_pkl;
    
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
    rapcmd('gv v10 yvar');
    
    %save the peak/sustain ratio for various spl
    rapcmd('exp v10 "PSratio"');
    D(n).PSratio=PSratio;
    clear PSratio;
    
    display([D(n).ds1.filename D(n).ds1.seqid])
    PSratio2=[];
    for k=1:length(D(n).Indepval)
        display(D(n).Indepval(k))
        rapcmd('set pkl srw 50 100');
        rapcmd(['rr x ' num2str(D(n).Indepval(k)) ' ' num2str(D(n).Indepval(k))]);
        rapcmd('nl pkl');
        rapcmd('gv v61 yvar');
        rapcmd('exp v61 "V61"');
        if V61<20
            V81=V61+5;
        else
            V81=22.5;rapcmd('v61 20');
        end;
        rapcmd('bw 0.1');
        %rapcmd('v7 5');
        rapcmd(['v81 ' num2str(V81)]);
        rapcmd('aw v61 v81');
        rapcmd(['rr x ' num2str(D(n).Indepval(k)) ' ' num2str(D(n).Indepval(k))]);
        rapcmd('nl sp');
        rapcmd('gv v21 yvar');
        rapcmd('aw v81 25');
        rapcmd(['rr x ' num2str(D(n).Indepval(k)) ' ' num2str(D(n).Indepval(k))]);
        rapcmd('nl sp');
        rapcmd('gv v31 yvar');
        rapcmd('v21 / v31');
        clear V61;clear V81
        rapcmd('exp v21 "PSratio2component"');
        display(PSratio2component)
        PSratio2=[PSratio2 PSratio2component];
        clear PSratio2component;
    end;
    display(PSratio2)
    D(n).PSratio2=PSratio2;
    clear PSratio2;
    rapcmd('rr def');
    %*
    %*
    %* page 2: PSTHs
    rapcmd('xm 35');
    rapcmd('aw 0 35');
    rapcmd('bw 0.1'); 
    %* (same bw as Blackburn & Sachs, a little coarser than nb 500, which gives bw 0.7 for 35 ms pst)
    rapcmd('col aw t');
    rapcmd('pp x 4');
    rapcmd('pp y 3');
    rapcmd('ou pst');
    %* to do: calculate # mistriggers, put with SPL
    %*bw 0.5
    %*xm 1
    %*ou isi
    %*
    rapcmd('xm def');
    rapcmd('nb def');
    rapcmd('pp def');
    rapcmd('aw def');
    rapcmd('min is 0');
    rapcmd('return');
    figure
    plot(D(n).Indepval,D(n).PSratio,'bo-',D(n).Indepval,D(n).PSratio2,'ro-')
end;


