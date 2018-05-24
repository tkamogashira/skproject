for k=1:341
    D(k).CF=NaN;
    D(k).THR=NaN;
    D(k).thrfile=NaN;
    D(k).thrds=NaN;
    
    for n=1:length(Dthr186)
        if strcmp(Dthr186(n).ds.filename,D(k).ds1.filename)==1&...
                strncmp(Dthr186(n).ds.seqid,D(k).ds1.seqid,2)==1
            D(k).CF=Dthr186(n).thr.cf;
            D(k).THR=Dthr186(n).thr.minthr;
            D(k).thrfile=Dthr186(n).ds.filename;
            D(k).thrds=Dthr186(n).ds.seqid;
            D(k).tag=Dthr186(n).tag;
        end;
    end;
end;

%correction for G0819B
D(1).CF=Dthr186(1).thr.cf;D(1).THR=Dthr186(1).thr.minthr;D(1).thrds=Dthr186(1).ds.seqid;D(1).tag=Dthr186(1).tag;

D(2).CF=Dthr186(2).thr.cf;D(2).THR=Dthr186(2).thr.minthr;D(2).thrds=Dthr186(2).ds.seqid;D(2).tag=Dthr186(2).tag;
D(3).CF=Dthr186(2).thr.cf;D(3).THR=Dthr186(2).thr.minthr;D(3).thrds=Dthr186(2).ds.seqid;D(3).tag=Dthr186(2).tag;

D(4).CF=Dthr186(3).thr.cf;D(4).THR=Dthr186(3).thr.minthr;D(4).thrds=Dthr186(3).ds.seqid;D(4).tag=Dthr186(3).tag;

D(5).CF=Dthr186(4).thr.cf;D(5).THR=Dthr186(4).thr.minthr;D(5).thrds=Dthr186(4).ds.seqid;D(5).tag=Dthr186(4).tag;

%correction for G0894
D(163).CF=Dthr186(117).thr.cf;D(163).THR=Dthr186(117).thr.minthr;D(163).thrds=Dthr186(117).ds.seqid;D(163).tag=Dthr186(117).tag;
D(164).CF=Dthr186(117).thr.cf;D(164).THR=Dthr186(117).thr.minthr;D(164).thrds=Dthr186(117).ds.seqid;D(164).tag=Dthr186(117).tag;
D(165).CF=Dthr186(117).thr.cf;D(165).THR=Dthr186(117).thr.minthr;D(165).thrds=Dthr186(117).ds.seqid;D(165).tag=Dthr186(117).tag;
D(166).CF=Dthr186(117).thr.cf;D(166).THR=Dthr186(117).thr.minthr;D(166).thrds=Dthr186(117).ds.seqid;D(166).tag=Dthr186(117).tag;

D(167).CF=Dthr186(118).thr.cf;D(167).THR=Dthr186(118).thr.minthr;D(167).thrds=Dthr186(118).ds.seqid;D(167).tag=Dthr186(118).tag;
D(168).CF=Dthr186(118).thr.cf;D(168).THR=Dthr186(118).thr.minthr;D(168).thrds=Dthr186(118).ds.seqid;D(168).tag=Dthr186(118).tag;
D(169).CF=Dthr186(118).thr.cf;D(169).THR=Dthr186(118).thr.minthr;D(169).thrds=Dthr186(118).ds.seqid;D(169).tag=Dthr186(118).tag;


%New data since G0904

for k=342:length(D)
    D(k).CF=NaN;
    D(k).THR=NaN;
    D(k).thrfile=NaN;
    D(k).thrds=NaN;
    
    for n=1:length(Dthr36)
        if strcmp(Dthr36(n).ds.filename,D(k).ds1.filename)==1&...
                strncmp(Dthr36(n).ds.seqid,D(k).ds1.seqid,2)==1
            D(k).CF=Dthr36(n).thr.cf;
            D(k).THR=Dthr36(n).thr.minthr;
            D(k).thrfile=Dthr36(n).ds.filename;
            D(k).thrds=Dthr36(n).ds.seqid;
            
        end;
    end;
end;

%add maxR
for s=1:length(D)
    if isempty(find(D(s).RaySig<=0.001))==1
        D(s).maxR=NaN;
        D(s).maxRRaySig=NaN;
        D(s).StimFreq=D(s).BinFreq(1);
    else
        [a,n]=max(D(s).R(find(D(s).RaySig<=0.001)));
        D(s).maxR=a;
        select=D(s).RaySig(find(D(s).RaySig<=0.001));
        D(s).maxRRaySig=select(n);
        clear a;clear n;clear select
        D(s).StimFreq=D(s).BinFreq(1);
    end;
end;

%add depth for old data
for k=1:341
    D(k).depth=NaN;
    
    for n=1:length(Dthr186)
        if strcmp(Dthr186(n).ds.filename,D(k).ds1.filename)==1&...
                strncmp(Dthr186(n).ds.seqid,D(k).ds1.seqid,2)==1
            D(k).depth=Dthr186(n).depth;
            
        end;
    end;
end;

%add depth for new data
for k=342:length(D)
    D(k).depth=NaN;
    
    for n=1:length(Dthr36)
        if strcmp(Dthr36(n).ds.filename,D(k).ds1.filename)==1&...
                strncmp(Dthr36(n).ds.seqid,D(k).ds1.seqid,2)==1
            D(k).depth=Dthr36(n).depth;
            
        end;
    end;
end;

%add q10
for n=1:length(D)
    if D(n).tag==0
        THR=evalthr(dataset(D(n).thrfile,D(n).thrds));close all
        D(n).thrfreq=THR.thr.freq;
        D(n).thrthr=THR.thr.thr;
        D(n).thrcf=THR.thr.cf;
        D(n).thrminthr=THR.thr.minthr;
        D(n).thrq10=THR.thr.q10;
        clear THR
        [CF,SR,minThr,BW,Qfactor]=evalthr(dataset(D(n).thrfile,D(n).thrds),'thr',40);close all
        D(n).thrq40=Qfactor;
        D(n).SR=SR;
    else
        D(n).thrfreq=NaN;
        D(n).thrthr=NaN;
        D(n).thrcf=NaN;
        D(n).thrminthr=NaN;
        D(n).thrq10=NaN;
        D(n).thrq40=NaN;
        D(n).SR=NaN;
    end;
end;

D1_A=structfilter(D,'strncmp($Evalisi$,''A'',1)');D1_Ac=structfilter(D1_A,'$CF$-$StimFreq$>-1 & $CF$-$StimFreq$<1');
D1_Ac=D1_Ac([1:3 5:84]);


