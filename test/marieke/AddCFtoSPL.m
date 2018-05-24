

for k=1:length(D)
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
            
        end;
    end;
end;

%correction for G0819B
D(1).CF=Dthr186(1).thr.cf;D(1).THR=Dthr186(1).thr.minthr;D(1).thrds=Dthr186(1).ds.seqid;

D(2).CF=Dthr186(2).thr.cf;D(2).THR=Dthr186(2).thr.minthr;D(2).thrds=Dthr186(2).ds.seqid;
D(3).CF=Dthr186(2).thr.cf;D(3).THR=Dthr186(2).thr.minthr;D(3).thrds=Dthr186(2).ds.seqid;

D(4).CF=Dthr186(3).thr.cf;D(4).THR=Dthr186(3).thr.minthr;D(4).thrds=Dthr186(3).ds.seqid;

D(5).CF=Dthr186(4).thr.cf;D(5).THR=Dthr186(4).thr.minthr;D(5).thrds=Dthr186(4).ds.seqid;

%correction for G0894
D(163).CF=Dthr186(117).thr.cf;D(163).THR=Dthr186(117).thr.minthr;D(163).thrds=Dthr186(117).ds.seqid;
D(164).CF=Dthr186(117).thr.cf;D(164).THR=Dthr186(117).thr.minthr;D(164).thrds=Dthr186(117).ds.seqid;
D(165).CF=Dthr186(117).thr.cf;D(165).THR=Dthr186(117).thr.minthr;D(165).thrds=Dthr186(117).ds.seqid;
D(166).CF=Dthr186(117).thr.cf;D(166).THR=Dthr186(117).thr.minthr;D(166).thrds=Dthr186(117).ds.seqid;

D(167).CF=Dthr186(118).thr.cf;D(167).THR=Dthr186(118).thr.minthr;D(167).thrds=Dthr186(118).ds.seqid;
D(168).CF=Dthr186(118).thr.cf;D(168).THR=Dthr186(118).thr.minthr;D(168).thrds=Dthr186(118).ds.seqid;
D(169).CF=Dthr186(118).thr.cf;D(169).THR=Dthr186(118).thr.minthr;D(169).thrds=Dthr186(118).ds.seqid;
