for k=1:length(sacxac585)
    for n=1:length(Dthr186)
        if strcmp(Dthr186(n).ds.filename,sacxac585(k).ds1.filename)==1&...
                strncmp(Dthr186(n).ds.seqid,sacxac585(k).ds1.seqid,2)==1
            sacxac585(k).CF=Dthr186(n).thr.cf;
            sacxac585(k).THR=Dthr186(n).thr.minthr;
            sacxac585(k).thrfile=Dthr186(n).ds.filename;
            sacxac585(k).thrds=Dthr186(n).ds.seqid;
        end;
    end;
end;

%correction for G0819B

sacxac585(1).CF=Dthr186(1).thr.cf;sacxac585(1).THR=Dthr186(1).thr.minthr;sacxac585(1).thrds=Dthr186(1).ds.seqid;
sacxac585(2).CF=Dthr186(1).thr.cf;sacxac585(2).THR=Dthr186(1).thr.minthr;sacxac585(2).thrds=Dthr186(1).ds.seqid;
sacxac585(3).CF=Dthr186(1).thr.cf;sacxac585(3).THR=Dthr186(1).thr.minthr;sacxac585(3).thrds=Dthr186(1).ds.seqid;

sacxac585(4).CF=Dthr186(2).thr.cf;sacxac585(4).THR=Dthr186(2).thr.minthr;sacxac585(4).thrds=Dthr186(2).ds.seqid;
sacxac585(5).CF=Dthr186(2).thr.cf;sacxac585(5).THR=Dthr186(2).thr.minthr;sacxac585(5).thrds=Dthr186(2).ds.seqid;
sacxac585(6).CF=Dthr186(2).thr.cf;sacxac585(6).THR=Dthr186(2).thr.minthr;sacxac585(6).thrds=Dthr186(2).ds.seqid;

sacxac585(7).CF=Dthr186(3).thr.cf;sacxac585(7).THR=Dthr186(3).thr.minthr;sacxac585(7).thrds=Dthr186(3).ds.seqid;
sacxac585(8).CF=Dthr186(3).thr.cf;sacxac585(8).THR=Dthr186(3).thr.minthr;sacxac585(8).thrds=Dthr186(3).ds.seqid;
sacxac585(9).CF=Dthr186(3).thr.cf;sacxac585(9).THR=Dthr186(3).thr.minthr;sacxac585(9).thrds=Dthr186(3).ds.seqid;

sacxac585(10).CF=Dthr186(4).thr.cf;sacxac585(10).THR=Dthr186(4).thr.minthr;sacxac585(10).thrds=Dthr186(4).ds.seqid;
sacxac585(11).CF=Dthr186(4).thr.cf;sacxac585(11).THR=Dthr186(4).thr.minthr;sacxac585(11).thrds=Dthr186(4).ds.seqid;

%correction for G0894
sacxac585(444).CF=Dthr186(117).thr.cf;sacxac585(444).THR=Dthr186(117).thr.minthr;sacxac585(444).thrds=Dthr186(117).ds.seqid;
sacxac585(445).CF=Dthr186(117).thr.cf;sacxac585(445).THR=Dthr186(117).thr.minthr;sacxac585(445).thrds=Dthr186(117).ds.seqid;
sacxac585(446).CF=Dthr186(117).thr.cf;sacxac585(446).THR=Dthr186(117).thr.minthr;sacxac585(446).thrds=Dthr186(117).ds.seqid;

sacxac585(447).CF=Dthr186(118).thr.cf;sacxac585(447).THR=Dthr186(118).thr.minthr;sacxac585(447).thrds=Dthr186(118).ds.seqid;
sacxac585(448).CF=Dthr186(118).thr.cf;sacxac585(448).THR=Dthr186(118).thr.minthr;sacxac585(448).thrds=Dthr186(118).ds.seqid;

