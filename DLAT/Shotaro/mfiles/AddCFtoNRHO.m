for k=1:length(D)
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
D(2).CF=Dthr186(1).thr.cf;D(2).THR=Dthr186(1).thr.minthr;D(2).thrds=Dthr186(1).ds.seqid;
D(3).CF=Dthr186(1).thr.cf;D(3).THR=Dthr186(1).thr.minthr;D(3).thrds=Dthr186(1).ds.seqid;
D(4).CF=Dthr186(1).thr.cf;D(4).THR=Dthr186(1).thr.minthr;D(4).thrds=Dthr186(1).ds.seqid;
D(5).CF=Dthr186(1).thr.cf;D(5).THR=Dthr186(1).thr.minthr;D(5).thrds=Dthr186(1).ds.seqid;
D(6).CF=Dthr186(1).thr.cf;D(6).THR=Dthr186(1).thr.minthr;D(6).thrds=Dthr186(1).ds.seqid;
D(7).CF=Dthr186(1).thr.cf;D(7).THR=Dthr186(1).thr.minthr;D(7).thrds=Dthr186(1).ds.seqid;

D(8).CF=Dthr186(2).thr.cf;D(8).THR=Dthr186(2).thr.minthr;D(8).thrds=Dthr186(2).ds.seqid;
D(9).CF=Dthr186(2).thr.cf;D(9).THR=Dthr186(2).thr.minthr;D(9).thrds=Dthr186(2).ds.seqid;
D(10).CF=Dthr186(2).thr.cf;D(10).THR=Dthr186(2).thr.minthr;D(10).thrds=Dthr186(2).ds.seqid;

D(11).CF=Dthr186(3).thr.cf;D(11).THR=Dthr186(3).thr.minthr;D(11).thrds=Dthr186(3).ds.seqid;
D(12).CF=Dthr186(3).thr.cf;D(12).THR=Dthr186(3).thr.minthr;D(12).thrds=Dthr186(3).ds.seqid;
D(13).CF=Dthr186(3).thr.cf;D(13).THR=Dthr186(3).thr.minthr;D(13).thrds=Dthr186(3).ds.seqid;

D(14).CF=Dthr186(4).thr.cf;D(14).THR=Dthr186(4).thr.minthr;D(14).thrds=Dthr186(4).ds.seqid;
D(15).CF=Dthr186(4).thr.cf;D(15).THR=Dthr186(4).thr.minthr;D(15).thrds=Dthr186(4).ds.seqid;

%correction for G0894
D(448).CF=Dthr186(117).thr.cf;D(448).THR=Dthr186(117).thr.minthr;D(448).thrds=Dthr186(117).ds.seqid;
D(449).CF=Dthr186(117).thr.cf;D(449).THR=Dthr186(117).thr.minthr;D(449).thrds=Dthr186(117).ds.seqid;
D(450).CF=Dthr186(117).thr.cf;D(450).THR=Dthr186(117).thr.minthr;D(450).thrds=Dthr186(117).ds.seqid;

D(451).CF=Dthr186(118).thr.cf;D(451).THR=Dthr186(118).thr.minthr;D(451).thrds=Dthr186(118).ds.seqid;
D(452).CF=Dthr186(118).thr.cf;D(452).THR=Dthr186(118).thr.minthr;D(452).thrds=Dthr186(118).ds.seqid;

