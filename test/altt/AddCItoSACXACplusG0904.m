sacxac615_A1000=structfilter(sacxac615_A,'$lowFreq$==50 & $highFreq$==15000');


for m=1:length(sacxac615_A1000)
    binwidth=0.05;Ntrial=100;AnaWindow=[50 1000];
    ds=dataset(sacxac615_A1000(m).ds1.filename,sacxac615_A1000(m).ds1.seqid);
    SPT = AnWin(ds, AnaWindow);
    N=size(SPT);
    PS=[];
    for k=1:N(1)
        SPTs = SPT(k,:);
        [p, NcoScrambled, Ppdf, Pcdf, Nco] = SACPeakSign(SPTs, binwidth, Ntrial);
        ps=p;
        PS=[PS ps];
    end;
    sacxac615_A1000(m).ConfidenceLevel=PS;
    disp(m)
end;







